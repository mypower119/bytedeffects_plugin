//
//  BEVideoSourceProvider.h
//  Common
//
//  Created by qun on 2021/5/17.
//

#ifndef BEVideoSourceProvider_h
#define BEVideoSourceProvider_h

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const BEEffectCameraDidAuthorizationNotification;

@protocol BEVideoSourceProtocol;

typedef NS_ENUM(NSInteger, VideoCaptureError) {
    VideoCaptureErrorAuthNotGranted = 0,
    VideoCaptureErrorFailedCreateInput = 1,
    VideoCaptureErrorFailedAddDataOutput = 2,
    VideoCaptureErrorFailedAddDeviceInput = 3,
};

@protocol BEVideoSourceDelegate <NSObject>
//   {zh} / @brief 输出 CMSampleBufferRef 回调     {en} /@Brief output CMSampleBufferRef callback 
- (void)videoCapture:(id<BEVideoSourceProtocol>)source didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer withRotation:(int)rotation;

//   {zh} / @brier 输出 buffer 回调     {en} /@Brier output buffer callback 
/// @param source source
/// @param buffer buffer
//   {zh} / @param width 宽     {en} /@param width 
//   {zh} / @param height 高     {en} /@param height 
/// @param bytesPerRow bytesPerRow
//   {zh} / @param format buffer 格式     {en} /@param format buffer format 
//   {zh} / @param timeStamp 时间戳     {en} @param timeStamp 
- (void)videoCapture:(id<BEVideoSourceProtocol>)source didOutputBuffer:(unsigned char *)buffer width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow format:(OSType)format timeStamp:(double)timeStamp;

@optional
- (void)videoCapture:(id<BEVideoSourceProtocol>)source didFailedToStartWithError:(VideoCaptureError)error;
- (void)videoCaptureDidEnd;
- (void)videoCaptureDidStart;

@end


@protocol BEVideoSourceProtocol <NSObject>

@property (nonatomic, weak) id <BEVideoSourceDelegate> delegate;

//   {zh} / @brief 启动     {en} /@brief start 
- (void)startRunning;

//   {zh} / @brief 停止     {en} /@brief stop 
- (void)stopRunning;

//   {zh} / @brief 暂停     {en} /@brief pause 
- (void)pause;

//   {zh} / @brief 恢复     {en} /@brief recovery 
- (void)resume;

//   {zh} / @brief 输出图像大小     {en} /@Brief output image size 
- (CGSize)videoSize;

//   {zh} / @brief 图像旋转角度     {en} /@Brief image rotation angle 
- (int)videoRotation;

//   {zh} / @brief 是否为前置相机     {en} /@Brief whether it is a front camera 
- (BOOL)frontCamera;

- (void)cameraBack:(NSString *)imagePath;

@end

#endif /* BEVideoSourceProvider_h */
