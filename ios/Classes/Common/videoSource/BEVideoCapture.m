// Copyright (C) 2018 Beijing Bytedance Network Technology Co., Ltd.
#import "BEVideoCapture.h"

#import <UIKit/UIKit.h>

//#import "BEStudioConstants.h"
//#import "BEMacro.h"
#import "BETimeRecoder.h"

@interface BEVideoCapture()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput * dataOutput;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) dispatch_queue_t bufferQueue;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, strong) NSMutableArray *observerArray;
@property (nonatomic, strong) AVCaptureMetadataOutput *metaDataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation BEVideoCapture

@synthesize delegate = _delegate;
@synthesize metadelegate = _metadelegate;
@synthesize devicePosition = _devicePosition;
@synthesize sessionPreset = _sessionPreset;
@synthesize outputFormat = _outputFormat;

#pragma mark - Lifetime
- (instancetype)init {
    self = [super init];
    if (self) {
        _isPaused = YES;
        _isFlipped = YES;
        _devicePosition = AVCaptureDevicePositionFront;
        _outputFormat = kCVPixelFormatType_32BGRA;
        _videoOrientation = AVCaptureVideoOrientationPortrait;
        _sessionPreset = AVCaptureSessionPreset1280x720;
        _observerArray = [NSMutableArray array];
        _metadataRect = CGRectMake(0, 0, 1, 1);
        _metadataType = AVMetadataObjectTypeFace;
    }
    return self;
}

- (void)dealloc {
    if (!_session) {
        return;
    }
    _isPaused = YES;
    [_session beginConfiguration];
    [_session removeOutput:_dataOutput];
    [_session removeInput:_deviceInput];
    [_session commitConfiguration];
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    _session = nil;
    for (id observer in self.observerArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

#pragma mark - Public
- (void)startRunning {
    if (!_session) {
        [self _setupCaptureSession];
        return;
    }
    if (!(_dataOutput || _metaDataOutput)) {
        return;
    }
    if (_session && ![_session isRunning]) {
        [_session startRunning];
        _isPaused = NO;
    }
    if ([self.delegate respondsToSelector:@selector(videoCaptureDidStart)]) {
        [self.delegate videoCaptureDidStart];
    }
}

- (void)stopRunning {
    if (_session && [_session isRunning]) {
        [_session stopRunning];
        _isPaused = YES;
    }
}

- (void)pause {
    _isPaused = true;
}

- (void)resume {
    _isPaused = false;
    if ([self.delegate respondsToSelector:@selector(videoCaptureDidStart)]) {
        [self.delegate videoCaptureDidStart];
    }
}


- (void)switchCamera {
    if (_session == nil) {
        return;
    }
    AVCaptureDevicePosition targetPosition = _devicePosition == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack: AVCaptureDevicePositionFront;
    
    [self setDevicePosition:targetPosition];
}

- (void)setDevicePosition:(AVCaptureDevicePosition)targetPosition {
    if (_devicePosition == targetPosition) {
        return;
    }
    
    if (_session == nil) {
        _devicePosition = targetPosition;
        return;
    }
    
    AVCaptureDevice *targetDevice = [self _cameraDeviceWithPosition:targetPosition];
    if (targetDevice == nil) {
        return;
    }
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:targetDevice error:&error];
    if(!deviceInput || error) {
        [self _throwError:VideoCaptureErrorFailedCreateInput];
        NSLog(@"Error creating capture device input: %@", error.localizedDescription);
        return;
    }
    [self pause];
    [_session beginConfiguration];
    [_session removeInput:_deviceInput];
    if ([_session canAddInput:deviceInput]) {
        [_session addInput:deviceInput];
        _deviceInput = deviceInput;
        _device = targetDevice;
        _devicePosition = targetPosition;
        
        [self setOrientation:_videoOrientation];
        [self setFlip:targetPosition == AVCaptureDevicePositionFront ? YES : NO];
        
    }
    [_session commitConfiguration];
    [self resume];
}

- (void)setFlip:(BOOL)isFlip {
    if (_session == nil || _dataOutput == nil) {
        return;
    }
    AVCaptureConnection *videoConnection = [_dataOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection) {
        if ([videoConnection isVideoMirroringSupported]) {
            [videoConnection setVideoMirrored:isFlip];
            _isFlipped = isFlip;
        }
    }
}

- (void)setOrientation:(AVCaptureVideoOrientation)orientation {
    if (_session == nil || _dataOutput == nil) {
        return;
    }
    AVCaptureConnection *videoConnection = [_dataOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection) {
        if ([videoConnection isVideoOrientationSupported]) {
            [videoConnection setVideoOrientation:orientation];
            _videoOrientation = orientation;
        }
    }
}

- (CGFloat)maxBias {
    return 1.58;
}

- (CGFloat)minBias {
    return -1.38;
}

- (CGFloat)ratio {
    return [self maxBias] - [self minBias];
}

- (void)setExposure:(float)exposure {
    if (_device == nil) return ;
    
    NSError *error;
   
    //syn exposureTargetBias logic
    CGFloat bias = [self maxBias] - exposure * [self ratio];
    bias = MIN(MAX(bias, [self minBias]), [self maxBias]);
    
    [_device lockForConfiguration:&error];
    [_device setExposureTargetBias:bias completionHandler:nil];
    
    if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
        [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    
    [_device unlockForConfiguration];
    [_session commitConfiguration];
}

- (void) setExposurePointOfInterest:(CGPoint) point{
    if (_device == nil) return ;
    
    [_device lockForConfiguration:nil];
    if ([_device isExposurePointOfInterestSupported]) {
        [_device setExposurePointOfInterest:point];
    }
    
    if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
        [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    
    [_device unlockForConfiguration];
}

- (void) setFocusPointOfInterest:(CGPoint) point{
    if (_device == nil)  return ;
    
    [_device lockForConfiguration:nil];
    
    if ([_device isFocusPointOfInterestSupported])
        [_device setFocusPointOfInterest:point];
    
    if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
        [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    
    [_device unlockForConfiguration];
}

#pragma mark - Private
- (void)_requestCameraAuthorization:(void (^)(BOOL granted))handler {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            handler(granted);
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        handler(true);
    } else {
        handler(false);
    }
}

// request for authorization first
- (void)_setupCaptureSession {
    [self _requestCameraAuthorization:^(BOOL granted) {
        if (granted) {
            [self __setupCaptureSession];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BEEffectCameraDidAuthorizationNotification object:nil userInfo:nil];
        } else {
            [self _throwError:VideoCaptureErrorAuthNotGranted];
        }
    }];
}

- (void)__setupCaptureSession {
    _session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    
    if ([_session canSetSessionPreset:self.sessionPreset]) {
        [_session setSessionPreset:self.sessionPreset];
    }else {
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        _sessionPreset = AVCaptureSessionPresetHigh;
    }
    [_session commitConfiguration];
    _device = [self _cameraDeviceWithPosition:self.devicePosition];
    [self _setCameraParaments];
    [self setExposure:0.5];
    
    _bufferQueue = dispatch_queue_create("HTSCameraBufferQueue", NULL);
    
    // Input
    NSError *error = nil;
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (!_deviceInput) {
        [_delegate videoCapture:self didFailedToStartWithError:VideoCaptureErrorFailedCreateInput];
        return;
    }
    
    // Output
    int iCVPixelFormatType = _outputFormat;
    _dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [_dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:iCVPixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [_dataOutput setSampleBufferDelegate:self queue:_bufferQueue];
    
    [_session beginConfiguration];
    if ([_session canAddOutput:_dataOutput]) {
        [_session addOutput:_dataOutput];
    } else {
        [self _throwError:VideoCaptureErrorFailedAddDataOutput];
        NSLog( @"Could not add video data output to the session" );
    }
    if ([_session canAddInput:_deviceInput]) {
        [_session addInput:_deviceInput];
    }else{
        [self _throwError:VideoCaptureErrorFailedAddDeviceInput];
        NSLog( @"Could not add device input to the session" );
    }
    
    [_session commitConfiguration];
    
    if (self.metadataType != nil) {
        [self setupMetaObjectType:self.metadataType rectOfInteret:self.metadataRect];
    }
    
    [self setFlip:self.devicePosition == AVCaptureDevicePositionFront ? YES : NO];
    [self setOrientation:_videoOrientation];
    
    [self registerNotification];
    [self startRunning];
}

//   {zh} / 设置相机捕获流的信息，ios的相机输出流支持人脸检测和曝光检测，在我们的应用中，二者对检测区域所有不用，所以只共存一个     {en} /Set the information of the camera capture stream. The camera output stream of ios supports face detection and exposure detection. In our application, the two do not use the detection area, so only one exists 
//   {zh} / @param type 人脸检测或者二维码检测     {en} /@param type face detection or QR code detection 
//   {zh} / @param rect 检测的区域大小     {en} /@Param rect detection area size 
-(void)setupMetaObjectType:(AVMetadataObjectType)type rectOfInteret:(CGRect)rect {
    [_session beginConfiguration];
    //    {zh} 如果原来有的话，先从原来的捕获中删除        {en} Delete from the original capture if there is one  
    if (_metaDataOutput){
        [_session removeOutput:_metaDataOutput];
    }
    
    //    {zh} 设置新的捕获流程        {en} Setting up a new capture process  
    AVCaptureMetadataOutput* metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    if ([_session canAddOutput:metadataOutput]) {
        [_session addOutput:metadataOutput];

        NSArray<AVMetadataObjectType>* mataObjects = [metadataOutput availableMetadataObjectTypes];
        if([mataObjects containsObject:type])
        {
            NSArray *metadataObjectTypes = @[type];
            metadataOutput.metadataObjectTypes = metadataObjectTypes;

            //   {zh} 人脸检测用到的硬件加速，而且许多重要的任务都在主线程，一般指定主线程     {en} Face detection uses hardware acceleration, and many important tasks are in the main thread, generally specify the main thread 
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            //   {zh} 指定AVCaptureMetadataOutputObjectsDelegate     {en} Specify AVCaptureMetadataOutputObjectsDelegate 
            [metadataOutput setMetadataObjectsDelegate:self  queue:mainQueue];
        }
        
        metadataOutput.rectOfInterest = rect;
    }

    _metaDataOutput = metadataOutput;
    [_session commitConfiguration];    
}

- (void)_setCameraParaments {
    [_device lockForConfiguration:nil];
    
    //   {zh} 设置自动对焦     {en} Set autofocus 
    if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
        [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    
    //   {zh} 设置自动曝光     {en} Set Auto Exposure 
    if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
        [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    
    //   {zh} 设置曝光补偿的值     {en} Set the value of exposure compensation 
//    [_device setExposureTargetBias:0.98 completionHandler:nil];

    [_device unlockForConfiguration];
}


- (void)registerNotification
{
    __weak typeof(self) weakSelf = self;
    [self.observerArray addObject:[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf startRunning];
    }]];
    
    [self.observerArray addObject:[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf stopRunning];
    }]];
}

- (void)_throwError:(VideoCaptureError)error {
    if (_delegate && [_delegate respondsToSelector:@selector(videoCapture:didFailedToStartWithError:)]) {
        [_delegate videoCapture:self didFailedToStartWithError:error];
    }
}

- (AVCaptureDevice *)_cameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDevice *deviceRet = nil;
    if (position != AVCaptureDevicePositionUnspecified) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == position) {
                deviceRet = device;
            }
        }
    }
    return deviceRet;
}

- (void)setMetadataType:(AVMetadataObjectType)metadataType {
    _metadataType = metadataType;
    if (_session == nil) return;
    
    [self stopRunning];
    [self setupMetaObjectType:metadataType rectOfInteret:self.metadataRect];
    [self startRunning];
}

-(AVCaptureSession*)getCaptureSession{
    return _session;
}

#pragma mark - Util

- (CGSize)videoSize {
    if (_dataOutput.videoSettings) {
        CGFloat width = [[_dataOutput.videoSettings objectForKey:@"Width"] floatValue];
        CGFloat height = [[_dataOutput.videoSettings objectForKey:@"Height"] floatValue];
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

- (int)videoRotation {
    return 0;
}

- (BOOL)frontCamera {
    return self.devicePosition == AVCaptureDevicePositionFront;
}

#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (!_isPaused) {
        if (_delegate && [_delegate respondsToSelector:@selector(videoCapture:didOutputSampleBuffer:withRotation:)]) {
            [_delegate videoCapture:self didOutputSampleBuffer:sampleBuffer withRotation:0];
        }
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (_metadataType == AVMetadataObjectTypeFace){
        //   {zh} 将人脸数据传给委托对象     {en} Pass face data to delegate 
        if (!_isPaused) {
            if (_metadelegate && [_metadelegate respondsToSelector:@selector(videoCapture:didOutputFaceMetadataObjects:)]) {
                [_metadelegate videoCapture:self didOutputFaceMetadataObjects:metadataObjects];
            }
        }
    } else if (_metadataType == AVMetadataObjectTypeQRCode){
        if (!_isPaused) {
            if (_metadelegate && [_metadelegate respondsToSelector:@selector(videoCapture:didOutputQRCodeMetadataObjects:)]) {
                [_metadelegate videoCapture:self didOutputQRCodeMetadataObjects:metadataObjects];
            }
        }
    }
}

#pragma mark - getter && setter

//    {zh} 设置视频流的分辨率        {en} Set the resolution of the video stream
- (void)setSessionPreset:(AVCaptureSessionPreset)sessionPreset {
    if ([sessionPreset isEqualToString:_sessionPreset]) {
        return;
    }
    if (!_session) {
        _sessionPreset = sessionPreset;
        return;
    }
    [self pause];
    [_session beginConfiguration];
    if ([_session canSetSessionPreset:sessionPreset]) {
        [_session setSessionPreset:sessionPreset];
        _sessionPreset = sessionPreset;
    }
    [self.session commitConfiguration];
    [self resume];
}

- (void)setOutputFormat:(OSType)outputFormat {
    if (_outputFormat == outputFormat) {
        return;
    }
    _outputFormat = outputFormat;
    if (_session == nil) {
        return;
    }

    int iCVPixelFormatType = _outputFormat;
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:iCVPixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [dataOutput setSampleBufferDelegate:self queue:_bufferQueue];
    [self pause];
    [_session beginConfiguration];
    [_session removeOutput:_dataOutput];
    if ([_session canAddOutput:dataOutput]) {
        [_session addOutput:dataOutput];
        _dataOutput = dataOutput;
    }else{
        [self _throwError:VideoCaptureErrorFailedAddDataOutput];
        NSLog(@"session add data output failed when change output buffer pixel format.");
    }
    [_session commitConfiguration];
    [self resume];
    /// make the buffer portrait
    [self setOrientation:_videoOrientation];
    [self setFlip:self.devicePosition == AVCaptureDevicePositionFront ? YES : NO];
}

- (CGRect)coverToMetadataOutputRectOfInterestForRect:(CGRect)cropRect {
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 0.0;
    
    if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        p2 = 1920./1080;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        p2 = 1280./720;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        p2 = 640./480.;
    }

    if (p1 < p2) {
        CGFloat fixHeight = size.width * p2;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        return CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                    (size.width-(cropRect.size.width+cropRect.origin.x))/size.width,
                                                    cropRect.size.height/fixHeight,
                                                    cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * (1/p2);
        CGFloat fixPadding = (fixWidth - size.width)/2;
        return CGRectMake(cropRect.origin.y/size.height,
                                                    (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth,
                                                    cropRect.size.height/size.height,
                                                    cropRect.size.width/size.width);
    }
}

- (float)currentFOV {
    if (!_device) {
        return 0.f;
    }
    return _device.activeFormat.videoFieldOfView;
}

@end

