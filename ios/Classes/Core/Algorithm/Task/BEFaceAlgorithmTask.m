//
//  BEFaceAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/6.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEFaceAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static unsigned long long DETECT_CONFIG = BEF_DETECT_SMALL_MODEL | BEF_DETECT_FULL | BEF_DETECT_MODE_VIDEO;
static int MAX_FACE = 10;
static unsigned long long ATTR_DETECT_CONFIG = BEF_FACE_ATTRIBUTE_AGE|BEF_FACE_ATTRIBUTE_HAPPINESS|BEF_FACE_ATTRIBUTE_EXPRESSION|BEF_FACE_ATTRIBUTE_GENDER|BEF_FACE_ATTRIBUTE_ATTRACTIVE|BEF_FACE_ATTRIBUTE_CONFUSE;

@implementation BEFaceAlgorithmResult
@end

@interface BEFaceAlgorithmTask () {
    bef_effect_handle_t         _handle;
    bef_effect_handle_t         _attrHandle;
    bef_ai_face_info            _faceInfo;
    bef_ai_face_attribute_result    _faceAttr;
    
    bef_ai_mouth_mask_info       _faceMouthMask;
    bef_ai_teeth_mask_info       _faceTeethMask;
    bef_ai_face_mask_info        _faceRestMask;
}

@property (nonatomic, strong) id<BEFaceResourceProvider> provider;

@end

@implementation BEFaceAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)FACE_106 {
    GET_TASK_KEY(face, YES)
}

+ (BEAlgorithmKey *)FACE_280 {
    GET_TASK_KEY(face280, NO)
}

+ (BEAlgorithmKey *)FACE_ATTR {
    GET_TASK_KEY(faceAttr, NO)
}

+ (BEAlgorithmKey *)FACE_MASK {
    GET_TASK_KEY(faceMask, NO)
}

+ (BEAlgorithmKey *)MOUTH_MASK {
    GET_TASK_KEY(mouthMask, NO)
}

+ (BEAlgorithmKey *)TEETH_MASK {
    GET_TASK_KEY(teethMask, NO)
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _initConfig = DETECT_CONFIG;
        _detectConfig = DETECT_CONFIG;
        _maxFaceNum = MAX_FACE;
    }
    return self;
}

- (int)initTask {
#if BEF_FACE_TOB
    int ret = bef_effect_ai_face_detect_create(_initConfig, self.provider.faceModel, &_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_face_detect_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_face_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_face_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_face_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_check_online_license, ret)
    }
    
    ret = bef_effect_ai_face_detect_setparam(_handle, BEF_FACE_PARAM_MAX_FACE_NUM, _maxFaceNum);
    CHECK_RET_AND_RETURN(bef_effect_ai_face_detect_setparam, ret)
    ret = bef_effect_ai_face_detect_add_extra_model(_handle, TT_MOBILE_FACE_280_DETECT, self.provider.faceExtraModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_face_detect_add_extra_model, ret)
    ret = bef_effect_ai_face_attribute_create(0, self.provider.faceAttrModel, &_attrHandle);
    CHECK_RET_AND_RETURN(bef_effect_ai_face_attribute_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_face_attribute_check_license(_attrHandle, [self.licenseProvider licensePath]);
        CHECK_RET_AND_RETURN(bef_effect_ai_face_attribute_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        ret = bef_effect_ai_face_attribute_check_online_license(_attrHandle, [self.licenseProvider licensePath]);
        CHECK_RET_AND_RETURN(bef_effect_ai_face_attribute_check_online_license, ret)
    }
    
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEFaceAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_FACE_TOB

    BEFaceAlgorithmResult *result = [BEFaceAlgorithmResult new];

    memset(&_faceInfo, 0, sizeof(bef_ai_face_info));
    RECORD_TIME(detectFace)
    bef_effect_result_t ret = bef_effect_ai_face_detect(_handle, buffer, format, widht, height, stride, rotation, _detectConfig, &_faceInfo);
    STOP_TIME(detectFace)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_detect, ret, result)
    
    result.faceInfo = &_faceInfo;
    
    if ([self boolConfig:BEFaceAlgorithmTask.FACE_ATTR orDefault:NO]) {
        memset(&_faceAttr, 0, sizeof(bef_ai_face_attribute_result));
        RECORD_TIME(detectFaceAttr)
        bef_effect_result_t ret = bef_effect_ai_face_attribute_detect_batch(_attrHandle, buffer, format, widht, height, stride, _faceInfo.base_infos, _faceInfo.face_count, ATTR_DETECT_CONFIG, &_faceAttr);
        STOP_TIME(detectFaceAttr)
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_attribute_detect_batch, ret, result)
        
        result.faceAttrInfo = &_faceAttr;
    }
    
    if ([self boolConfig:BEFaceAlgorithmTask.MOUTH_MASK orDefault:NO]) {
        memset(&_faceMouthMask, 0, sizeof(bef_ai_mouth_mask_info));
        RECORD_TIME(mouth_mask_detect)
        ret = bef_effect_ai_face_mask_detect(_handle, _detectConfig,BEF_FACE_DETECT_MOUTH_MASK, &_faceMouthMask);
        STOP_TIME(mouth_mask_detect)
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_mask_detect, ret, result);
        
        result.mouthMask = &_faceMouthMask;
    }
    
    if ([self boolConfig:BEFaceAlgorithmTask.TEETH_MASK orDefault:NO]) {
        memset(&_faceTeethMask, 0, sizeof(bef_ai_teeth_mask_info));
        RECORD_TIME(teeth_mask_detect)
        ret = bef_effect_ai_face_mask_detect(_handle, _detectConfig,BEF_FACE_DETECT_TEETH_MASK, &_faceTeethMask);
        STOP_TIME(teeth_mask_detect)
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_mask_detect, ret, result);
        
        result.teethMask = &_faceTeethMask;
    }
    
    if ([self boolConfig:BEFaceAlgorithmTask.FACE_MASK orDefault:NO]) {
        memset(&_faceRestMask, 0, sizeof(bef_ai_face_mask_info));
        RECORD_TIME(face_mask_detect)
        ret = bef_effect_ai_face_mask_detect(_handle, _detectConfig, BEF_FACE_DETECT_FACE_MASK, &_faceRestMask);
        STOP_TIME(face_mask_detect)
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_face_mask_detect, ret, result);
        
        result.faceMask = &_faceRestMask;
    }
    
    return result;
#endif
    return nil;

    
}

- (int)destroyTask {
#if BEF_FACE_TOB
    bef_effect_ai_face_detect_destroy(_handle);
    bef_effect_ai_face_attribute_destroy(_attrHandle);
    
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEFaceAlgorithmTask.FACE_106;
}

- (void)setConfig:(BEAlgorithmKey *)key p:(NSObject *)p {
    [super setConfig:key p:p];
    
    _detectConfig = BEF_DETECT_MODE_VIDEO | BEF_DETECT_FULL;
    if ([self boolConfig:BEFaceAlgorithmTask.FACE_280 orDefault:NO]) {
        _detectConfig = BEF_DETECT_MODE_VIDEO | BEF_DETECT_FULL | TT_MOBILE_FACE_280_DETECT;
    }
    
    if ([self boolConfig:BEFaceAlgorithmTask.FACE_MASK orDefault:NO]) {
        _detectConfig |= TT_MOBILE_FACE_240_DETECT | AI_FACE_MASK_DETECT;
    }
    
    if ([self boolConfig:BEFaceAlgorithmTask.MOUTH_MASK orDefault:NO]) {
        _detectConfig |= TT_MOBILE_FACE_240_DETECT | AI_MOUTH_MASK_DETECT;
    }
    
    if ([self boolConfig:BEFaceAlgorithmTask.TEETH_MASK orDefault:NO]) {
        _detectConfig |= TT_MOBILE_FACE_240_DETECT | AI_TEETH_MASK_DETECT;
    }
}

@end
