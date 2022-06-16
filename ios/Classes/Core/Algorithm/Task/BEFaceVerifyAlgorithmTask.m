//
//  BEFaceVerifyAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEFaceVerifyAlgorithmTask.h"
#import "bef_effect_ai_face_detect.h"
#import "BEAlgorithmTaskFactory.h"

static int MAX_NUM = BEF_AI_MAX_FACE_VERIFY_NUM;
static unsigned long long IMAGE_DETECT_CONFIG = BEF_DETECT_SMALL_MODEL | BEF_DETECT_FULL | BEF_DETECT_MODE_IMAGE_SLOW;

@implementation BEFaceVerifyAlgorithmResult

@end
@interface BEFaceVerifyAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_face_verify_info         _verifyInfo;
    BEFaceAlgorithmTask             *_faceTask;
    
    BOOL                            _currentValid;
    float                           _currentVerifyFeature[BEF_AI_FACE_FEATURE_DIM];
}

@property (nonatomic, strong) id<BEFaceVerifyResourceProvider> provider;

@end

@implementation BEFaceVerifyAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)FACE_VERIFY {
    GET_TASK_KEY(faceVerify, YES)
}

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>)licenseProvider {
    if (self = [super initWithProvider:provider licenseProvider:licenseProvider]) {
        _faceTask = [[BEFaceAlgorithmTask alloc] initWithProvider:provider licenseProvider:licenseProvider];
        _faceTask.initConfig = IMAGE_DETECT_CONFIG;
        _faceTask.detectConfig = IMAGE_DETECT_CONFIG;
    }
    return self;
}

- (int)initTask {
#if BEF_FACE_VERIFY_TOB
    bef_effect_result_t ret = bef_effect_ai_face_verify_create(self.provider.faceVerifyModelPath, MAX_NUM, &_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_face_verify_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_face_verify_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_face_verify_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_face_verify_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_face_verify_check_online_license, ret);
    }

    ret = [_faceTask initTask];
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (int)setFaceVerifySourceFeature:(unsigned char *)buffer format:(BEFormatType)format width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow {
#if BEF_FACE_VERIFY_TOB
    bef_ai_pixel_format pixelFormat = [self pixelFormatWithFormat:format];
    BEFaceAlgorithmResult *faceRet = [_faceTask process:buffer width:width height:height stride:bytesPerRow format:pixelFormat rotation:BEF_AI_CLOCKWISE_ROTATE_0];
    bef_ai_face_info *faceInfo = faceRet.faceInfo;
    if (faceInfo == nil) {
        return 0;
    }
    
    _currentValid = faceInfo->face_count == 1;
    if (_currentValid) {
        bef_effect_result_t ret = bef_effect_ai_face_extract_feature_single(_handle, buffer, pixelFormat, width, height, bytesPerRow, BEF_AI_CLOCKWISE_ROTATE_0, faceInfo->base_infos, _currentVerifyFeature);
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_extract_feature_single, ret, 0)
        return 1;
    }
    return faceInfo->face_count;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (void)resetVerify {
    _currentValid = NO;
}

- (BEFaceVerifyAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_FACE_VERIFY_TOB
    BEFaceVerifyAlgorithmResult *result = [BEFaceVerifyAlgorithmResult new];
    
    BEFaceAlgorithmResult *faceRet = [_faceTask process:buffer width:widht height:height stride:stride format:format rotation:rotation];
    bef_ai_face_info *faceInfo = faceRet.faceInfo;
    
    memset(&_verifyInfo, 0, sizeof(bef_ai_face_verify_info));
    double similarity = 0.0;
    long startTime = [[NSDate date] timeIntervalSince1970] * 1000;
    if (faceInfo != nil && faceInfo->face_count > 0) {
        RECORD_TIME(faceVerify)
        if (_currentValid) {
            float destFaceVerifyFeature[BEF_AI_FACE_FEATURE_DIM];
            bef_effect_result_t ret = bef_effect_ai_face_extract_feature_single(_handle, buffer, format, widht, height, stride, rotation, faceInfo->base_infos, destFaceVerifyFeature);
            CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_extract_feature_single, ret, result)
            double featureDistance = bef_effect_ai_face_verify(_currentVerifyFeature, destFaceVerifyFeature, BEF_AI_FACE_FEATURE_DIM);
            similarity = bef_effect_ai__dist2score(featureDistance);
            result.valid = YES;
        } else {
            bef_effect_result_t ret = bef_effect_ai_face_extract_feature(_handle, buffer, format, widht, height, stride, rotation, faceInfo, &_verifyInfo);
            CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_extract_feature, ret, result)
            result.valid = NO;
        }
        STOP_TIME(faceVerify)
    }
    
    result.verifyInfo = &_verifyInfo;
    result.similarity = similarity;
    result.costTime = similarity == 0.0 ? 0 : [[NSDate date] timeIntervalSince1970] * 1000 - startTime;
    return result;
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_FACE_VERIFY_TOB
    bef_effect_ai_face_verify_destroy(_handle);
    [_faceTask destroyTask];
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEFaceVerifyAlgorithmTask.FACE_VERIFY;
}

- (bef_ai_pixel_format)pixelFormatWithFormat:(BEFormatType)format {
    switch (format) {
        case BE_RGBA:
            return BEF_AI_PIX_FMT_RGBA8888;
        case BE_BGRA:
            return BEF_AI_PIX_FMT_BGRA8888;
        default:
            break;
    }
    return BEF_AI_PIX_FMT_RGBA8888;
}

@end
