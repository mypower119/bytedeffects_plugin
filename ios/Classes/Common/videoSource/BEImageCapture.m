//
//  BEImageCapture.m
//  Common
//
//  Created by qun on 2021/5/17.
//

#import "BEImageCapture.h"
#import <UIKit/UIKit.h>

@interface BEImageCapture() {
    unsigned char           *_imageBuffer;
    int                      _width;
    int                      _height;
    int                      _bytesPerRow;
    
    dispatch_queue_t        _queue;
    NSTimer                 *_timer;
    BOOL                     _resumed;
}

@property (atomic, strong) NSMutableArray<NSString* > * profilerImagePaths;
@property (atomic, strong) NSTimer *imagePresentTimer;
@property (atomic, assign) unsigned int imagePresentTime;
@end

@implementation BEImageCapture

@synthesize delegate = _delegate;

- (void)dealloc {
    if (_imageBuffer) {
        free(_imageBuffer);
        _imageBuffer = NULL;
    }
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
//        _queue = dispatch_get_main_queue();
        _queue = dispatch_queue_create("image capture", DISPATCH_QUEUE_SERIAL);
        [self resetImage:image];
    }
    return self;
}

// Current used under profiler
- (instancetype)initWithProfilerImagePaths:(NSArray<NSString*> *)paths presentTime:(unsigned int)time{
    if (self = [super init]){
        _queue = dispatch_queue_create("image capture", DISPATCH_QUEUE_SERIAL);
        _profilerImagePaths = [[NSMutableArray alloc] initWithArray:paths];
        _imagePresentTime = time;
        
        if ([_profilerImagePaths count] <= 0){
            return self;
        }
        // Set the first image to profiler
        UIImage *image = [self be_readImage:[_profilerImagePaths firstObject]];
        [_profilerImagePaths removeObjectAtIndex:0];
        [self resetImage:image];
    }
    return self;
}

- (void)resetImage:(UIImage *)image {
    if (_imageBuffer) {
        free(_imageBuffer);
        _imageBuffer = NULL;
    }
    _width = (int)CGImageGetWidth(image.CGImage);
    _height = (int)CGImageGetHeight(image.CGImage);
    _bytesPerRow = 4 * _width;
    _imageBuffer = (unsigned char *)malloc(_width * _height * 4);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(_imageBuffer, _width, _height,
                                                 bitsPerComponent, _bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, _width, _height), image.CGImage);
    CGContextRelease(context);
}

- (void)startRunning {
    _resumed = YES;
    if (_timer && _timer.isValid) {
        return;
    }
    [self be_releaseTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(be_timeRun:) userInfo:nil repeats:YES];
    
#if BEF_AUTO_PROFILE
    //Cast the time to double, in case of the loss of decimal point
    NSTimeInterval interval = (double)_imagePresentTime / 1000;
    _imagePresentTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                          target:self selector:@selector(be_profilerTimer:) userInfo:nil repeats:YES];
#endif
    if ([self.delegate respondsToSelector:@selector(videoCaptureDidStart)]) {
        [self.delegate videoCaptureDidStart];
    }
}

- (void)stopRunning {
    _resumed = NO;
    [self be_releaseTimer];
    
}

- (void)resume {
    _resumed = YES;
    if ([self.delegate respondsToSelector:@selector(videoCaptureDidStart)]) {
        [self.delegate videoCaptureDidStart];
    }
}

- (void)pause {
    _resumed = NO;
}

- (CGRect)getZoomedRectWithRect:(CGRect)rect scaleToFit:(BOOL)scaleToFit {
    return CGRectMake(0, 0, _width, _height);
}

- (CGSize)videoSize {
    return CGSizeMake(_width, _height);
}

- (int)videoRotation {
    return 0;
}

- (BOOL)frontCamera {
    return NO;
}

#pragma mark - private

- (void)be_timeRun:(NSTimer *)timer {
    if (_resumed) {
        dispatch_async(_queue, ^{
            [self.delegate videoCapture:self didOutputBuffer:_imageBuffer width:_width height:_height bytesPerRow:_bytesPerRow format:kCVPixelFormatType_32BGRA timeStamp:[[NSDate date] timeIntervalSince1970]];
        });
    }
}

- (void)be_releaseTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Profiler time callback


-(void)be_profilerTimer:(NSTimer *)timer{
    // No images, just return
    if ([_profilerImagePaths count] <= 0){
        [timer invalidate];
        _imagePresentTimer = nil;
        
        [self stopRunning];
        return ;
    }
    
    [self pause];
    NSString* imagePath = [_profilerImagePaths firstObject];
    NSLog(@"Profiler images image:%@", imagePath);
    UIImage *image = [self be_readImage:imagePath];
    
    // Pop front
    [_profilerImagePaths removeObjectAtIndex:0];
    [self resetImage:image];
    [self resume];
}

- (UIImage*)be_readImage:(NSString*) path{
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    // Bigger picture will cost more memory
    // When in effect, this will cose hugh memory
    // Here we resize the UIImage to as most 720P
    CGFloat width = [image size].width;
    CGFloat height = [image size].height;
    
    // When reize, we need to keep the ratio
    if (width >= 720.0 || height >= 1080.0){
        float ratio = height / width;
        float source_ratio  = 1080.0 / 720.0;
        
        float dest_height = 0.0, dest_width = 0.0;
        
        if (ratio >= source_ratio){ // Means height is too much
            dest_height = 1080.0;
            dest_width = dest_height / ratio;
        } else { // Mean wight is too much
            dest_width = 720.0;
            dest_height = dest_width * ratio;
        }
        
        // Resize image code in ios
        {
            CGSize new_size = CGSizeMake(dest_width, dest_height);
            UIGraphicsBeginImageContextWithOptions(new_size, NO, 0.0);
            [image drawInRect:CGRectMake(0, 0, new_size.width, new_size.height)];
            UIImage *dest_image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return dest_image;
        }
    }
    return image;
}
@end
