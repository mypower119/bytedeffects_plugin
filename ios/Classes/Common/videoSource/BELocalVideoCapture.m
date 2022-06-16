//
//  BELocalVideoCapture.m
//  Common
//
//  Created by qun on 2021/5/17.
//

#import "BELocalVideoCapture.h"
#import "BEImageOpeartion.h"
#import <UIKit/UIKit.h>

@interface BELocalVideoCapture () {
    dispatch_queue_t                _queue;
    AVAssetReader                   *_reader;
    AVAssetTrack                    *_videoTrack;
    AVAssetReaderTrackOutput        *_trackOutput;
    int                             _videoRotation;
    double                          _frameDuration;
    BOOL                            _firstFrame;
    CGSize                          _size;
    BOOL                            _resumed;
    volatile BOOL                   _stoped;
}

@end

@implementation BELocalVideoCapture

@synthesize delegate = _delegate;

- (instancetype)initWithAsset:(AVAsset *)asset {
    if (self = [super init]) {
        _queue = dispatch_queue_create("local video capture", DISPATCH_QUEUE_SERIAL);
        
        [self resetVideo:asset];
    }
    return self;
}

- (void)dealloc
{
    [self stopRunning];
}

- (void)resetVideo:(AVAsset *)asset {
    _stoped = YES;
    _firstFrame = YES;
    NSError *error;
    _reader = [AVAssetReader assetReaderWithAsset:asset error:&error];
    _videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    _size = _videoTrack.naturalSize;
    double frame = _videoTrack.nominalFrameRate;
    _frameDuration = 1.0 / frame;
    CGAffineTransform transform = _videoTrack.preferredTransform;
    _videoRotation = (int)(atan2(transform.b, transform.a) * 180 / M_PI + 360) % 360;
    
    NSDictionary *videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA],
                                    (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]};
    if (_videoTrack) {
        _trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:_videoTrack outputSettings:videoSettings];
        if ([_reader canAddOutput:_trackOutput]) {
            [_reader addOutput:_trackOutput];
        }
    }
    
    [_reader startReading];
}

- (void)startRunning {
    _resumed = YES;
    dispatch_async(_queue, ^{
        if (!_stoped || !_resumed) return;
        double lastFrame = 0;
        while (true) {
            double current = [NSDate date].timeIntervalSince1970;
            if (current - lastFrame <= _frameDuration) {
                [NSThread sleepForTimeInterval:lastFrame + _frameDuration - current];
                continue;
            } else {
                lastFrame = current;
            }
            if (!_resumed) {
                [self be_onVideoPause:0];
                break;
            }
            
            AVAssetReaderStatus status = [_reader status];
            if (status != AVAssetReaderStatusReading) {
                [self be_onVideoEnd];
                break;
            }
            
            CMSampleBufferRef sampleBuffer = [_trackOutput copyNextSampleBuffer];
            if (sampleBuffer == nil) {
                AVAssetReaderStatus status = [_reader status];
                if (status != AVAssetReaderStatusReading) {
                    [self be_onVideoEnd];
                    break;
                } else {
                    continue;
                }
            }
            
            if (_firstFrame) {
                for (int i = 0; i < 2; i++) {
                    [self.delegate videoCapture:self didOutputSampleBuffer:sampleBuffer withRotation:_videoRotation];
                }
                _firstFrame = NO;
                _resumed = NO;
            } else {
                [self.delegate videoCapture:self didOutputSampleBuffer:sampleBuffer withRotation:_videoRotation];
            }
            
            CFRelease(sampleBuffer);
        }
    });
    if ([self.delegate respondsToSelector:@selector(videoCaptureDidStart)]) {
        [self.delegate videoCaptureDidStart];
    }
}

- (void)stopRunning {
    _resumed = NO;
}

- (void)resume {
}

- (void)pause {
    
}

- (CGRect)getZoomedRectWithRect:(CGRect)rect scaleToFit:(BOOL)scaleToFit {
    return CGRectMake(0, 0, _size.width, _size.height);
}

- (CGSize)videoSize {
    return (_videoRotation % 180 == 0) ? _size : CGSizeMake(_size.height, _size.width);
}

- (int)videoRotation {
    return _videoRotation;
}

- (BOOL)frontCamera {
    return NO;
}

#pragma mark - private
- (void)be_onVideoEnd {
    _stoped = YES;
    _resumed = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(videoCaptureDidEnd)]) {
            [self.delegate videoCaptureDidEnd];
        }
    });
}

- (void)be_onVideoPause:(double)clock {
    _stoped = YES;
}

@end

#pragma mark - BEFormatedLocalVideoCapture
@interface BEFormatedLocalVideoCapture() <BEVideoSourceProtocol>

//work as a timer, take effect when each screen refreash
@property(nonatomic, strong) CADisplayLink* displayLink;
//track output to get
@property(nonatomic, strong) AVAssetReaderTrackOutput *trackOutput;
//asset reader to  to read the tarck
@property(nonatomic, strong) AVAssetReader* assetReader;
//the output format of the stream
@property(nonatomic, assign) OSType outputType;
//size of the video
@property(nonatomic, assign) CGSize videoSize;
//rotation, under the option [0, 90, 180, 270]
@property(nonatomic, assign) int rotation;

@end


@implementation BEFormatedLocalVideoCapture

@synthesize delegate = _delegate;

-(instancetype)initWithAsset:(AVAsset *)asset imageFormat:(OSType)type{
    if (type != kCVPixelFormatType_32BGRA && type != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange && type != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange){
        NSLog(@"Not supported video capture format now");
        return nil;
    }
    
    if (self = [super init]){
        _outputType = type;
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallBack:)];
        [[self displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[self displayLink] setPaused:YES];
        
        // control in 30 fps, or it will beyond 30 like a fast move
        if (@available(iOS 10.0, *)){
            _displayLink.preferredFramesPerSecond = 30;
        }else {
            _displayLink.frameInterval = 2;
        }
        if (asset){
            [self setVideoCaptureSetting:asset];
        }
        
    }
    return self;
}


// set the video capture settings
-(void) setVideoCaptureSetting:(AVAsset*)asset{
    NSError* error = nil;
    
    // init assset read
    _assetReader = [AVAssetReader assetReaderWithAsset:asset error:&error];
    if(error){
        NSLog(@"AVAssetReader assetReaderWithAsset is %@", error);
    }
    
    // set reading related
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    [outputSettings setObject:@(_outputType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [outputSettings setObject:[NSDictionary dictionary] forKey:(id)kCVPixelBufferIOSurfacePropertiesKey];
    
    //get the infomation of asset track, and set  the size, rotation
    AVAssetTrack* videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    _videoSize = videoTrack.naturalSize;
    CGAffineTransform transform = videoTrack.preferredTransform;
    _rotation = [self getVideoDegree:transform];
    if (_rotation != 0 && _rotation != 180){
        int height = _videoSize.height;
        _videoSize.height = _videoSize.width;
        _videoSize.width = height;
    }
    
    // init video track output
    _trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:outputSettings];
    
    if ([_assetReader canAddOutput:_trackOutput]){
        [_assetReader addOutput:_trackOutput];
    }
    
    if (![_assetReader startReading]){
        NSLog(@"Error when assetReader start Reading");
        _trackOutput = nil;
    }
    
#if BEF_AUTO_PROFILE
    [self localVideoStartRunning];
#endif
}

// This function is to get the degree of the deconde videon
- (int)getVideoDegree:(CGAffineTransform)transform
{
    int degree = 0;
    if (transform.b == 1.0 && transform.c == -1.0) {
        degree = 90;
    } else if (transform.a == -1.0 && transform.d == -1.0) {
        degree = 180;
    } else if (transform.b == -1.0 && transform.c == 1.0) {
        degree = 270;
    }
    return degree;
    
}

#pragma mark -- CallBacks
-(void) displayLinkCallBack:(CADisplayLink *)sender{
    //   {zh} iphont 原始刷新率是60帧，这里需要保证不超过30帧     {en} The original refresh rate of iphont is 60 frames, which needs to be guaranteed not to exceed 30 frames 
    
    //it seems every time it will create a new samplebuffer
    CMSampleBufferRef sampleBufferRef = nil;
    
    if (_trackOutput){
        sampleBufferRef = [_trackOutput copyNextSampleBuffer];
        
    }
    if (_assetReader && _assetReader.status == AVAssetReaderStatusCompleted){
        _assetReader = nil;
        _trackOutput = nil;
    }
    
    if (sampleBufferRef){
        [self.delegate videoCapture:self didOutputSampleBuffer:sampleBufferRef withRotation:self.videoRotation];
        CFRelease(sampleBufferRef);
    }
}

#pragma mark -- BEVideoCaptureProtocol
-(void)localVideoStartRunning{
    [self.displayLink setPaused:NO];
    if ([self.delegate respondsToSelector:@selector(videoCaptureDidStart)]) {
        [self.delegate videoCaptureDidStart];
    }
}

-(void)startRunning{
    
}
-(void)stopRunning{
    
}
-(void)pause{
    //    if (_displayLink && !_displayLink.isPaused){
    //        [_displayLink setPaused:YES];
    //    }
}

-(void)resume{
    //    if (_displayLink && _displayLink.isPaused){
    //        [_displayLink setPaused:NO];
    //    }
}

-(CGSize)videoSize{
    return _videoSize;
}

- (int)videoRotation {
    return 0;
}

- (BOOL)frontCamera {
    return NO;
}

@end

