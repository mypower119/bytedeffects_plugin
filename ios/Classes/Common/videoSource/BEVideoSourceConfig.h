//
//  BEVideoSourceConfig.h
//  Common
//
//  Created by qun on 2021/5/17.
//

#ifndef BEVideoSourceConfig_h
#define BEVideoSourceConfig_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, BEVideoSourceType) {
    BEVideoSourceCamera = 0,
    BEVideoSourceImage = 1,
    BEVideoSourceVideo = 2,
};

FOUNDATION_EXTERN NSString *const VIDEO_SOURCE_CONFIG_KEY;

@interface BEVideoSourceConfig : NSObject

+ (instancetype)initWithType:(BEVideoSourceType)type position:(AVCaptureDevicePosition)devicePosition;

//   {zh} / 类型，相机/图片/视频     {en} /Type, Camera/Picture/Video 
@property (nonatomic, assign) BEVideoSourceType type;

//   {zh} / 相机模式下，相机位置     {en} /Camera mode, camera position 
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

//   {zh} / 相机模式下，默认分辨率，默认为 1280*720     {en} /Camera mode, default resolution, default is 1280 * 720 
@property (nonatomic, strong) AVCaptureSessionPreset preset;

//   {zh} / 相机模式下，metadata 检测类型，默认 nil     {en} /Camera mode, metadata detection type, default nil 
@property (nonatomic, copy) AVMetadataObjectType metadtaType;

//   {zh} / 相机模式下，metadata 检测范围，默认 CGRectZero     {en} /Camera mode, metadata detection range, default CGRectZero 
@property (nonatomic, assign) CGRect metadataRect;

//   {zh} / 图片模式下，图片资源     {en} /Picture mode, picture resources 
@property (nonatomic, strong) UIImage *image;

//   {zh} / 视频模式下，视频资源     {en} /Video mode, video resources 
@property (nonatomic, strong) AVAsset *asset;

// {zh} / 媒体资源路径，用于自动化测试时指定图片/视频路径 {en} /Media resource path, used to specify the picture/video path during automated testing
// {zh} / 在调用 image/asset 时会自动根据 mediaPath 取对应的 UIImage/AVAsset {en} /When calling image/asset, the corresponding UIImage/AVAsset will be automatically taken according to mediaPath
@property (nonatomic, strong) NSString *mediaPath;

/// 画面的缩放比例，默认 1.f
@property (nonatomic, assign) CGFloat scale;

@end

#endif /* BEVideoSourceConfig_h */
