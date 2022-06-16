//
//  BEBaseVC.h
//  Common
//
//  Created by qun on 2021/5/17.
//

#ifndef BEBaseVC_h
#define BEBaseVC_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BEVideoSourceConfig.h"
#import "BEVideoSourceProvider.h"
#import "BEVideoCapture.h"
#import "BEImageUtils.h"
#import "BEGLView.h"

//   {zh} / 基类，内部包含两个功能：     {en} /Base class, which contains two functions internally: 
// {zh} / 1. 对 VideoSource 的封装，可以通过 BEVideoSourceConfig {en} /1. The encapsulation of VideoSource can be done by BEVideoSourceConfig
//   {zh} / 控制它是输出相机采集流、图片解析流还是视频解析流，子类只需实现 processWithCVPixelBuffer:rotation:timeStamp     {en} /Control whether it outputs camera capture stream, picture analysis stream or video analysis stream. The subclass only needs to implement processWithCVPixelBuffer: rotation: timeStamp 
//   {zh} / 完成 SDK 调用即可     {en} /Complete the SDK call 
// {zh} / 2. 对 GLKView 的封装，提供了 glContext 等信息，子类可直接调用 drawGLTextureOnScreen:rotation {en} /2. The encapsulation of GLKView provides information such as glContext. Subclasses can directly call drawGLTextureOnScreen: rotation
//   {zh} / 将纹理绘制到屏幕上     {en} /Draw texture to screen 
@interface BEBaseVC : UIViewController <BEVideoSourceDelegate, BEVideoMetadataDelegate>
//   {zh} / 配置信息字典，内含诸如 BEVideoSourceConfig 等信息，各子类可自行从中取出自定义的 config     {en} /Configuration information dictionary, containing information such as BEVideoSourceConfig, from which each subclass can extract its own custom config 
@property (nonatomic, strong) NSDictionary<NSString *, NSObject *> *configDict;

// {zh} / 视频流配置项，可以通过它完成视频流的配置 {en} /Video stream configuration item, you can use it to complete the configuration of the video stream
@property (nonatomic, strong) BEVideoSourceConfig *videoSourceConfig;

//   {zh} / 视频流封装类协议，含有所有视频流的公用方法     {en} /Video stream encapsulation class protocol, containing all common methods for video streams 
@property (nonatomic, strong) id<BEVideoSourceProtocol> videoSource;
@property (nonatomic, weak) id <BEVideoSourceProtocol> delegate;

// {zh} / gl 上下文，可供 SDK 使用 {en} /Gl context, available for SDK
@property (nonatomic, strong) EAGLContext *glContext;

//   {zh} / 图像处理类，提供一些基础的图像转换功能     {en} /Image processing class, provides some basic image conversion functions 
@property (nonatomic, strong) BEImageUtils *imageUtils;

//   {zh} / 区分每一个页面的 key，可用于每一个页面的持久化存储用 key 等功能，     {en} /Distinguish the key of each page, which can be used for functions such as the persistent storage key of each page, 
// {zh} / 默认的实现是直接取 ViewController 类名，子类可根据自身情况重写 {en} /The default implementation is to take the ViewController class name directly, and the subclass can be rewritten according to its own situation
@property (nonatomic, readonly) NSString *viewControllerKey;

@property (nonatomic, strong) BEGLView *glView;

// protected

//   {zh} / @brief 绘制纹理     {en} /@brief drawing texture 
// {zh} / @param texture 纹理封装，具体见 BEGLTexture {en} /@param texture package, see BEGLTexture for details
// {zh} / @param rotation 旋转角度 {en} /@param rotation angle
- (void)drawGLTextureOnScreen:(id<BEGLTexture>)texture rotation:(int)rotation;

//   {zh} / @brief 保存纹理到本地     {en} /@brief save texture to local 
//   {zh} / @param texture 纹理封装，具体见 BEGLTexture     {en} /@param texture package, see BEGLTexture for details 
- (void)saveGLTextureToLocal:(id<BEGLTexture>)texture;

//   {zh} / @brief 保存图像到本地     {en} /@brief save image to local
- (void)saveImageToLocal:(UIImage*)image;

// sdk lifecycle

//   {zh} / @brief SDK 初始化，需子类实现     {en} /@Brief SDK initialization, subclass implementation required 
- (int)initSDK;

//   {zh} / @brief SDK 处理，需子类实现     {en} /@brief SDK processing, need subclass implementation 
// {zh} / @param pixelBuffer 视频流输出 CVPixelBuffer {en} /@param pixelBuffer video stream output CVPixelBuffer
// {zh} / @param rotation 旋转角度 {en} /@param rotation angle
//   {zh} / @param timeStamp 时间戳     {en} @param timeStamp 
- (void)processWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(int)rotation timeStamp:(double)timeStamp;

//   {zh} / @brief SDK 销毁，需子类实现     {en} /@Brief SDK destruction, need subclass implementation 
- (void)destroySDK;

/// @brief SDK 调用线程同步锁
- (void)lockSDK;

/// @brief SDK 调用线程同步锁
- (void)unlockSDK;

// video source

//   {zh} / 视频模式下提供的方法，启动视频播放     {en} /The method provided in video mode starts video playback 
- (void)startPlayVideo;
@end

#endif /* BEBaseVC_h */
