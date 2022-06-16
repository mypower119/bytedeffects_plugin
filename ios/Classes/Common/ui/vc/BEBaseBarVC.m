//
//  BEBaseBarVC.m
//  Common
//
//  Created by qun on 2021/6/1.
//

#import "BEBaseBarVC.h"
#import "BEVideoCapture.h"
#import "BEProfileRecordManager.h"
#import "BEPopoverVC.h"
#import "BELocaleManager.h"
#import "Masonry.h"
#import <Toast/UIView+Toast.h>
#import "TZImagePickerController.h"

@interface BEBaseBarVC () <TZImagePickerControllerDelegate>

@property (nonatomic, weak) id<UIGestureRecognizerDelegate> savedGestureDelegate;
@property (atomic, assign) BOOL captureNextFrame;
@property (nonatomic, assign) BOOL isShowProfile;
@property (nonatomic, strong) BEProfileRecordManager *profileRecordManager;

//  {zh} 曝光相关  {en} Exposure related
@property (nonatomic, assign) BOOL touchExposureEnable;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BEBaseBarVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShowProfile = NO;
    }
    return self;
}

- (void)dealloc
{
    [self releaseTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [self baseBarAddObservers];
    
    [super viewDidLoad];
    
    [self.view addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    switch (self.videoSourceConfig.type) {
        case BEVideoSourceCamera:
            break;
        case BEVideoSourceImage:
            [self.baseView showBar:(BEBaseBarAll & (~BEBaseBarSwitch) & (~BEBaseBarImagePicker))];
            break;
        case BEVideoSourceVideo:
            [self.baseView showBar:(BEBaseBarAll & (~BEBaseBarSwitch) & (~BEBaseBarImagePicker))];
            self.baseView.btnPlay.hidden = NO;
            break;
    }
    
    [self showProfile:NO];
    [self setupTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.savedGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self.savedGestureDelegate;
    
    [self releaseTimer];
}

#pragma mark - notification
- (void)baseBarAddObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(baseBarDidReceiveErrorLog:)
                                                 name:@"kBESdkErrorNotification"
                                               object:nil];
}

- (void)baseBarDidReceiveErrorLog:(NSNotification *)note {
    NSString *log = note.userInfo[@"data"];
    log = [BELocaleManager convertLocaleLog:log];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hideToast];
        [self.view makeToast:log];
    });
}

#pragma mark - BEVideoMetadataDelegate
- (void)videoCapture:(BEVideoCapture *)camera didOutputFaceMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects {
    BOOL detectedFace = 0;
    CGPoint point = CGPointMake(0.5, 0.5);
    for (AVMetadataFaceObject *face in metadataObjects)
    {
        //        NSLog(@"Face detected with ID: %li", (long)face.faceID);
        //        NSLog(@"Face bounds: %@", NSStringFromCGRect(face.bounds));
        
        float faceMiddleWidth = (face.bounds.origin.x + face.bounds.size.width) / 2;
        float faceMiddleHeight = (face.bounds.origin.y + face.bounds.size.height) / 2;
        
        point = CGPointMake(faceMiddleWidth, faceMiddleHeight);
        detectedFace ++;
        break;
    }
    
    // {zh} 半脸情况下避免测光点在过于边缘的位置导致的过曝，在靠近屏幕边缘时候测光点改回中心位置 {en} In the case of half face, avoid overexposure caused by the metering point at the position where the edge is too high, and change the metering point to the center position when it is close to the edge of the screen
    if(point.x > 0.8 || point.x < 0.2 || point.y< 0.05 ||point.y > 0.95)
    {
        point = CGPointMake(0.5, 0.5);
    }
    
    [self didChangeExporsureDetectPoint:point fromFace:detectedFace>0];
}

- (void)didChangeExporsureDetectPoint:(CGPoint)point fromFace:(BOOL)fromFace {
    if([_timer isValid]) return;
    
    if (![self.videoSource isKindOfClass:[BEVideoCapture class]]) {
        return;
    }
    
    BEVideoCapture *capture = (BEVideoCapture *)self.videoSource;
    
    if(!_touchExposureEnable && !fromFace)
    {
        [capture setExposurePointOfInterest:CGPointMake(0.5f, 0.5f)];
        [capture setFocusPointOfInterest:CGPointMake(0.5f, 0.5f)];
        _touchExposureEnable = YES;
        return;
    }
    
    _touchExposureEnable = !fromFace;
    
    if(_touchExposureEnable) return;
    
    if (point.x == 0 && point.y == 0) {
        return;
    }

    [capture setExposurePointOfInterest:point];
    [capture setFocusPointOfInterest:point];
    
}

- (void)setupTimer {
    [self releaseTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTouchState) userInfo:nil repeats:NO];
    [_timer invalidate];
}

- (void)resetTimer {
    __weak typeof(self)weakSelf = self;
    [weakSelf.timer invalidate];
    weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTouchState) userInfo:nil repeats:NO];
}

- (void)updateTouchState {
    if(_touchExposureEnable)
    {
        _touchExposureEnable = NO;
        [_timer invalidate];
    }
}

- (void)releaseTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - BEGestureDelegate
- (void)gestureManager:(BEGestureManager *)manager onGesture:(BEGestureType)gesture x:(CGFloat)x y:(CGFloat)y dx:(CGFloat)dx dy:(CGFloat)dy factor:(CGFloat)extra {
    if (gesture != BEGestureTypeTap) {
        return;
    }
    
    if(!_touchExposureEnable )
    {
        _touchExposureEnable = YES;
        [self resetTimer];
    }
    
    if (![self.videoSource isKindOfClass:[BEVideoCapture class]]) {
        return;
    }
    
    BEVideoCapture *capture = (BEVideoCapture *)self.videoSource;
    
    CGRect bouns =  self.view.bounds;
    CGPoint point = CGPointMake(x / bouns.size.width, y / bouns.size.height);
    
    if ([capture respondsToSelector:@selector(setExposurePointOfInterest:)]) {
        [capture setExposurePointOfInterest:point];
    }
    if ([capture respondsToSelector:@selector(setFocusPointOfInterest:)]) {
        [capture setFocusPointOfInterest:point];
    }
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapBack:(UIView *)sender {
    if (self.videoSourceConfig.type == BEVideoSourceCamera ||
        self.presentingViewController == nil    //  {zh} 自动化测试模式下，是直接从 MainVC push 到图片/视频页面，所以也需要直接 pop  {en} In automated test mode, it is pushed directly from MainVC to the picture/video page, so it is also necessary to pop directly
        ) {
        //  {zh} 图片模式是在 MainVC 基础上 push 的，  {en} Picture mode is pushed on MainVC,
        //    {zh} 需要 pop 到 MainVC        {en} Need to pop to MainVC
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //    {zh} 图片模式和视频模式，是在 imagePickerViewController 的基础上 push 的，        {en} Picture mode and video mode are pushed based on the imagePickerViewController,  
        //  {zh} 所以需要 dismiss 整个 navigationController  {en} So we need to dismiss the entire navigationController
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)baseView:(BEBaseBarView *)view didTapRecord:(UIView *)sender {
    self.captureNextFrame = YES;
}



- (void)baseView:(BEBaseBarView *)view didTapImagePicker:(UIView *)sender {
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    vc.autoDismiss = NO;
    vc.allowPickingVideo = YES;
    vc.allowPickingGif = NO;
    vc.allowPickingOriginalPhoto = NO;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)baseView:(BEBaseBarView *)view didTapSetting:(UIView *)sender {
    
}

- (void)baseView:(BEBaseBarView *)view didTapSwitchCamera:(UIView *)sender {
    if (self.videoSourceConfig.type == BEVideoSourceCamera) {
        [(BEVideoCapture *)self.videoSource switchCamera];
    }
}

- (void)baseView:(BEBaseBarView *)view didTapPlay:(UIView *)sender {
    sender.hidden = YES;
    [self startPlayVideo];
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                    options:options
                                              resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            BEVideoSourceConfig *config = [BEVideoSourceConfig new];
            config.type = BEVideoSourceVideo;
            config.asset = asset;
            NSMutableDictionary *dict = [self.configDict mutableCopy];
            [dict setObject:config forKey:VIDEO_SOURCE_CONFIG_KEY];
            BEBaseVC *vc = [[[self class] alloc] init];
            vc.glContext = self.glContext;
            vc.configDict = dict;
            [picker pushViewController:vc animated:YES];
        });
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (photos.count == 1) {
        if (isSelectOriginalPhoto) {
            [[TZImageManager manager] getOriginalPhotoWithAsset:assets[0] completion:^(UIImage *photo, NSDictionary *info) {
                if ([[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue]) return;
                [self imagePickerController:picker onSelectImageAvailable:photo];
            }];
        } else {
            [self imagePickerController:picker onSelectImageAvailable:photos[0]];
        }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker onSelectImageAvailable:(UIImage *)image {
    BEVideoSourceConfig *config = [BEVideoSourceConfig new];
    config.type = BEVideoSourceImage;
    config.image = image;
    NSMutableDictionary *dict = [self.configDict mutableCopy];
    [dict setObject:config forKey:VIDEO_SOURCE_CONFIG_KEY];
    BEBaseVC *vc = [[[self class] alloc] init];
    vc.glContext = self.glContext;
    vc.configDict = dict;
    [picker pushViewController:vc animated:YES];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - save image
- (void)drawGLTextureOnScreen:(id<BEGLTexture>)texture rotation:(int)rotation {
    if (self.captureNextFrame) {
        self.captureNextFrame = NO;
        [self saveGLTextureToLocal:texture];
    }
    
    [super drawGLTextureOnScreen:texture rotation:rotation];
    
    if (self.isShowProfile) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.profileRecordManager record];
            [self.baseView updateProfile:self.profileRecordManager.frameCount frameTime:self.profileRecordManager.frameTime resolution:self.videoSource.videoSize];
        });
    }
}

#pragma mark - public
- (void)showPopoverViewWithConfigs:(NSArray *)configs anchor:(UIView *)anchor {
    BEPopoverVC *vc = [BEPopoverVC new];
    vc.anchorView = anchor;
    vc.configs = configs;
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)showProfile:(BOOL)isShow {
    self.isShowProfile = isShow;
    [self.baseView showProfile:isShow];
}

#pragma mark - getter
- (BEBaseBarView *)baseView {
    if (_baseView == nil) {
        BEBaseBarView *baseView = [[BEBaseBarView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        baseView.delegate = self;
        _baseView = baseView;
    }
    return _baseView;
}

- (BEProfileRecordManager *)profileRecordManager {
    if (_profileRecordManager) {
        return _profileRecordManager;
    }
    
    _profileRecordManager = [BEProfileRecordManager new];
    return _profileRecordManager;
}

- (BEGestureManager *)gestureManager {
    if (_gestureManager == nil) {
        _gestureManager = [[BEGestureManager alloc] init];
        _gestureManager.delegate = self;
    }
    return _gestureManager;
}

@end
