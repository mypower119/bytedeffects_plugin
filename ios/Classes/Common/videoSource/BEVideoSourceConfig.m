//
//  BEVideoSourceConfig.m
//  Common
//
//  Created by qun on 2021/5/17.
//

#import "BEVideoSourceConfig.h"

NSString *const VIDEO_SOURCE_CONFIG_KEY = @"VIDEO_SOURCE_CONFIG_KEY";
@implementation BEVideoSourceConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = BEVideoSourceCamera;
        _devicePosition = AVCaptureDevicePositionFront;
        _preset = AVCaptureSessionPreset1280x720;
        _metadataRect = CGRectZero;
        _metadtaType = nil;
        _scale = 1.f;
    }
    return self;
}

+ (instancetype)initWithType:(BEVideoSourceType)type position:(AVCaptureDevicePosition)devicePosition {
    BEVideoSourceConfig *config = [self new];
    config.type = type;
    config.devicePosition = devicePosition;
    return config;
}

- (UIImage *)image {
    if (_image == nil) {
        return [self be_imageFromPath];
    }
    return _image;
}

- (AVAsset *)asset {
    if (_asset == nil) {
        return [self be_assetFromPath];
    }
    return _asset;
}

#pragma mark - private
- (UIImage *)be_imageFromPath {
    if (_mediaPath == nil) {
        return nil;
    }
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:self.mediaPath];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (AVAsset *)be_assetFromPath {
    if (_mediaPath == nil) {
        return nil;
    }
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *videoPath = [documentPath stringByAppendingPathComponent:self.mediaPath];
    return [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
}

@end
