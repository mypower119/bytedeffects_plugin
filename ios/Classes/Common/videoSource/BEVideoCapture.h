// Copyright (C) 2018 Beijing Bytedance Network Technology Co., Ltd.


#import "BEVideoSourceProvider.h"

@class BEVideoCapture;
@protocol BEVideoMetadataDelegate <NSObject>
@optional
- (void)videoCapture:(BEVideoCapture *)camera didOutputFaceMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects;
- (void)videoCapture:(BEVideoCapture *)camera didOutputQRCodeMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects;
@end


@interface BEVideoCapture : NSObject <BEVideoSourceProtocol>

//   {zh} / meta 代理     {en} Agent/meta 
@property (nonatomic, weak) id <BEVideoMetadataDelegate> metadelegate;

//   {zh} / 默认相机，默认为 AVCaptureDevicePositionFront     {en} /Default camera, default is AVCaptureDevicePositionFront 
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

//   {zh} / 输出格式，仅支持 kCVPixelFormatType_32BGRA,     {en} /Output format, only support kCVPixelFormatType_32BGRA, 
/// kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
@property (nonatomic, assign) OSType outputFormat;

//   {zh} / 分辨率，默认 720p     {en} /Resolution, default 720p 
@property (nonatomic, copy) AVCaptureSessionPreset sessionPreset;

//   {zh} / 相机角度，默认 AVCaptureVideoOrientationPortrait     {en} /Camera angle, default AVCaptureVideoOrientationPortrait 
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

//   {zh} / 是否反转，默认 YES     {en} /Whether to reverse, default YES 
@property (nonatomic, assign) BOOL isFlipped;

//   {zh} / 相机 fov     {en} /Camera fov 
@property (nonatomic, assign, readonly) float currentFOV;

//   {zh} / metadata 功能类型，用于一些检测功能，如二维码扫描，人脸检测，默认 AVMetadataObjectTypeFace     {en} /Metadata function type, for some detection functions, such as QR code scanning, face detection, default AVMetadataObjectTypeFace 
@property (nonatomic, strong) AVMetadataObjectType metadataType;

//   {zh} / metadata 检测范围，需要在设置 metadataType 之前设置才能生效，默认 0,0,1,1     {en} /Metadata detection range, which needs to be set before setting metadataType to take effect, default 0,0,1,1 
@property (nonatomic, assign) CGRect metadataRect;

//   {zh} / @brief 切换相机     {en} /@Briefing switch camera 
- (void)switchCamera;

//   {zh} / @brief 设置曝光参数     {en} /@Briefly set exposure parameters 
//   {zh} / @param exposure 曝光参数     {en} /@param exposure parameters 
- (void)setExposure:(float) exposure;

//   {zh} / @brief 设置曝光检测点     {en} /@Briefly set the exposure detection point 
//   {zh} / @param point 检测点     {en} /@param point detection point 
- (void)setExposurePointOfInterest:(CGPoint) point;

//   {zh} / @brief 设置聚焦检测点     {en} /@Briefly set the focus detection point 
//   {zh} / @param point 检测点     {en} /@param point detection point 
- (void)setFocusPointOfInterest:(CGPoint) point;

//   {zh} /// @brief 相机捕获变为扫描二维码     {en} ///@brief camera capture changed to scan QR code 
//- (void)changeToQRCodeScan:(CGRect)scanRect;
//
//   {zh} /// @brief  相机捕获变为原始的流捕获     {en} ///@brief camera capture becomes original stream capture 
//- (void)changeToNormalCapture;

@end
