//
//  BEBaseVC.m
//  Common
//
//  Created by qun on 2021/5/17.
//

#import "BEBaseVC.h"
#import "BEVideoSourceProvider.h"
#import "BEVideoCapture.h"
#import "BEImageCapture.h"
#import "BELocalVideoCapture.h"
#import "BEBaseBarView.h"
#import "BEGLUtils.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

static NSRecursiveLock *SDK_LOCK = nil;

@interface BEBaseVC ()

@property (atomic, assign) BOOL videoSourcePaused;
@property (nonatomic, assign) BOOL videoIsPlay;
@property (nonatomic, assign) BOOL isInBackground;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgIdentifier;

@end

@implementation BEBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoSourceConfig = (BEVideoSourceConfig *)self.configDict[VIDEO_SOURCE_CONFIG_KEY];
    if (self.videoSourceConfig == nil) {
        NSLog(@"invalid video source config");
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SDK_LOCK = [[NSRecursiveLock alloc] init];
    });
    
    [self.view addSubview:self.glView];
    [self.glView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.glView.x_scale = self.glView.y_scale = self.videoSourceConfig.scale;
    
    //    {zh} 一个页面中有两个线程需要 gl 环境，分别是 SDK 线程离屏渲染，与 GLKView 主线程渲染        {en} There are two threads in a page that need gl environment, namely SDK thread off-screen rendering and GLKView main thread rendering  
    //  {zh} 所以同样的需要两个共享的 glContext 分别用于两个线程。  {en} So the same requires two shared glContext for each thread.
    //  {zh} 另外有一个问题，如果两个线程、两个 glContext，当第二个 SDK 进行销毁的时候，  {en} Another problem is that if two threads and two glContext, when the second SDK is destroyed,
    //    {zh} 如果第一个 SDK 正在调用 process，会导致环境混乱 crash，所以第二个页面需要复用上一个页面的 glContext。        {en} If the first SDK is calling process, it will cause the environment to crash, so the second page needs to reuse the glContext of the previous page.  
    if (self.glContext == nil) {
        self.glContext = [BEGLUtils createContextWithDefaultAPI:kEAGLRenderingAPIOpenGLES3 sharegroup:self.glView.context.sharegroup];
    } else {
        self.glView.context = [BEGLUtils createContextWithDefaultAPI:kEAGLRenderingAPIOpenGLES3 sharegroup:self.glContext.sharegroup];
    }
    
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    
    self.imageUtils = [[BEImageUtils alloc] init];
    if ([self initSDK] == 0) {
        [self be_createSource];
        [self baseVCAddObserver];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.videoSource) {
        [self.videoSource resume];
        self.videoSourcePaused = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.videoSource) {
        self.videoSourcePaused = YES;
        [self.videoSource pause];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.glContext != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    [self destroySDK];
}

#pragma mark - observe，检测进出后台，主要用于 video 模式下进入后台暂停、回到前台继续
- (void)baseVCAddObserver {
    if (self.videoSourceConfig.type == BEVideoSourceVideo) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeToForground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (void)comeToForground {
    if (self.videoSourceConfig.type == BEVideoSourceVideo) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgIdentifier];
        self.bgIdentifier = UIBackgroundTaskInvalid;
        [self.navigationController setNavigationBarHidden:YES];
        _isInBackground = NO;
        if (_videoIsPlay) {
            [self.videoSource startRunning];
        }
    }
}

- (void)comeToBackground {
    if (self.videoSourceConfig.type == BEVideoSourceVideo) {
        self.bgIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgIdentifier];
            self.bgIdentifier = UIBackgroundTaskInvalid;
        }];
        _isInBackground = YES;
        if (_videoIsPlay) {
            [self.videoSource stopRunning];
        }
    }
}

#pragma mark - public，功能方法，供子类来调用
- (void)drawGLTextureOnScreen:(id<BEGLTexture>)texture rotation:(int)rotation {
    [self.glView renderWithTexture:texture.texture size:CGSizeMake(texture.width, texture.height) applyingOrientation:rotation fitType:[self be_fitCenterDraw] ? 1 : 0];
}

- (void)saveGLTextureToLocal:(id<BEGLTexture>)texture {
    if ([texture isKindOfClass:[BEPixelBufferGLTexture class]]) {
        CVPixelBufferRef pixelBuffer = [(BEPixelBufferGLTexture *)texture pixelBuffer];
        UIImage *image = [self.imageUtils transforBufferToUIImage:[self.imageUtils transforCVPixelBufferToBuffer:pixelBuffer outputFormat:BE_BGRA]];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self image:image didFinishSavingWithError:error contextInfo:(__bridge void *)(self) assetURL:assetURL];
            });
            
        }];
    } else {
        // TODO: directly transfer glTexture to buffer
    }
}

- (void)saveImageToLocal:(UIImage*)image {
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)self);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self image:image didFinishSavingWithError:error contextInfo:(__bridge void *)(self) assetURL:assetURL];
            });
        
        }];
    } else {
        // TODO: directly transfer glTexture to buffer
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void *)contextInfo assetURL:(NSURL*)assetURL {
    if(error) {
        NSLog(@"fail to save photo");
        [self.delegate cameraBack:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.view.window makeToast:NSLocalizedString(@"ablum_have_been_saved", nil) duration:(NSTimeInterval)(3.0) position:CSToastPositionCenter];
        
//        https://github.com/KasemJaffer/flutter_absolute_path/blob/master/ios/Classes/SwiftFlutterAbsolutePathPlugin.swift
        
        PHContentEditingInputRequestOptions *editingOptions = [[PHContentEditingInputRequestOptions alloc] init];
        PHAsset *pha = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil].lastObject;
        
        [pha requestContentEditingInputWithOptions:editingOptions completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
            NSString* pathhh = contentEditingInput.fullSizeImageURL.absoluteString;
            NSString *imagePath = [pathhh stringByReplacingOccurrencesOfString:@"file://"
                                                          withString:@""];
            [self.delegate cameraBack:imagePath];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)startPlayVideo {
    if (self.isInBackground) {
        return;
    }
    
    if ([self.videoSource respondsToSelector:@selector(localVideoStartRunning)]) {
        [(BEFormatedLocalVideoCapture *)self.videoSource localVideoStartRunning];
    } else {
        [self.videoSource startRunning];
    }
}

- (void)lockSDK {
    [SDK_LOCK lock];
}

- (void)unlockSDK {
    [SDK_LOCK unlock];
}

#pragma mark - BEVideoSourceDelegate，视频回调，两种方式，返回 CVPixelBuffer 或 buffer
- (void)videoCapture:(id<BEVideoSourceProtocol>)source didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer withRotation:(int)rotation {
    if (self.videoSourcePaused) {
        return;
    }
    
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CMTime sampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    double timeStamp = (double)sampleTime.value/sampleTime.timescale;
    
    [SDK_LOCK lock];
    [self processWithCVPixelBuffer:pixelBuffer rotation:rotation timeStamp:timeStamp];
    [SDK_LOCK unlock];
}

- (void)videoCapture:(id<BEVideoSourceProtocol>)source didOutputBuffer:(unsigned char *)buffer width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow format:(OSType)format timeStamp:(double)timeStamp {
    if (self.videoSourcePaused) {
        return;
    }
    
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    
    BEBuffer *b = [[BEBuffer alloc] init];
    b.buffer = buffer;
    b.width = width;
    b.height = height;
    b.bytesPerRow = bytesPerRow;
    b.format = [self.imageUtils getFormatForOSType:format];
    
    CVPixelBufferRef pixelBuffer = [self.imageUtils transforBufferToCVPixelBuffer:b outputFormat:BE_BGRA];
    [SDK_LOCK lock];
    [self processWithCVPixelBuffer:pixelBuffer rotation:0 timeStamp:timeStamp];
    [SDK_LOCK unlock];
}

#pragma mark - private
- (void)be_createSource {
    switch (self.videoSourceConfig.type) {
        case BEVideoSourceCamera:
        {
            BEVideoCapture *capture = [[BEVideoCapture alloc] init];
            capture.metadelegate = self;
            capture.outputFormat = kCVPixelFormatType_32BGRA;
            if (self.videoSourceConfig.devicePosition) {
                capture.devicePosition = self.videoSourceConfig.devicePosition;
            }
            if (self.videoSourceConfig.metadtaType != nil) {
                capture.metadataRect = self.videoSourceConfig.metadataRect;
                capture.metadataType = self.videoSourceConfig.metadtaType;
            }
            if (self.videoSourceConfig.preset) {
                capture.sessionPreset = self.videoSourceConfig.preset;
            }
            
            self.videoSource = capture;
            [capture startRunning];
        }
            break;
        case BEVideoSourceImage:
        {
            BEImageCapture *capture = [[BEImageCapture alloc] initWithImage:self.videoSourceConfig.image];
            self.videoSource = capture;
            [capture startRunning];
        }
            break;
        case BEVideoSourceVideo:
        {
            BELocalVideoCapture *capture = [[BELocalVideoCapture alloc] initWithAsset:self.videoSourceConfig.asset];
            self.videoSource = capture;
            [capture startRunning];
        }
            break;
    }
    
    if (self.videoSource == nil) {
        @throw [NSException exceptionWithName:@"" reason:@"video source must not be nil" userInfo:nil];
    }
    
    self.videoSource.delegate = self;
}

- (BOOL)be_fitCenterDraw {
    return self.videoSourceConfig.type != BEVideoSourceCamera;
}

#pragma mark - getter
- (BEGLView *)glView {
    if (_glView == nil) {
        _glView = [[BEGLView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    }
    return _glView;
}

- (NSString *)viewControllerKey {
    return NSStringFromClass(self.class);
}

@end
