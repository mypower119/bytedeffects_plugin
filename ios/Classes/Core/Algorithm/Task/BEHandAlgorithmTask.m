//
//  BEHandAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEHandAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static int MAX_NUM = 1;
static BOOL NARUTO_GESTURE = true;
static float ENLARGE_FACTOR = 2.f;
static unsigned long long DETECT_CONFIG = BEF_AI_HAND_MODEL_DETECT | BEF_AI_HAND_MODEL_BOX_REG |
BEF_AI_HAND_MODEL_GESTURE_CLS| BEF_AI_HAND_MODEL_KEY_POINT;

@implementation BEHandAlgorithmResult

@end
@interface BEHandAlgorithmTask () {
    bef_ai_hand_sdk_handle          _handle;
    bef_ai_hand_info                _handInfo;
    unsigned long long              _detectConfig;
}

@property (nonatomic, strong) id<BEHandResourceProvider> provider;

@end

@implementation BEHandAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)HAND {
    GET_TASK_KEY(hand, YES)
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _detectConfig = DETECT_CONFIG;
    }
    return self;
}

- (int)initTask {
#if BEF_HAND_TOB
    bef_effect_result_t ret = bef_effect_ai_hand_detect_create(&_handle, 0);
    CHECK_RET_AND_RETURN(bef_effect_ai_hand_detect_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_hand_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_hand_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_hand_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_hand_check_online_license, ret)
    }
    
    ret = bef_effect_ai_hand_detect_setmodel(_handle, BEF_AI_HAND_MODEL_DETECT, self.provider.handModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_hand_detect_setmodel, ret)
    ret = bef_effect_ai_hand_detect_setmodel(_handle, BEF_AI_HAND_MODEL_BOX_REG, self.provider.handBoxModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_hand_detect_setmodel, ret)
    ret = bef_effect_ai_hand_detect_setmodel(_handle, BEF_AI_HAND_MODEL_GESTURE_CLS, self.provider.handGestureModel);
    CHECK_RET_AND_DO(bef_effect_ai_hand_detect_setmodel, ret, {
        _detectConfig &= ~ BEF_AI_HAND_MODEL_GESTURE_CLS;
    })
    ret = bef_effect_ai_hand_detect_setmodel(_handle, BEF_AI_HAND_MODEL_KEY_POINT, self.provider.handKeyPointModel);
    CHECK_RET_AND_DO(bef_effect_ai_hand_detect_setmodel, ret, {
        _detectConfig &= ~ BEF_AI_HAND_MODEL_KEY_POINT;
    })
    ret = bef_effect_ai_hand_detect_setparam(_handle, BEF_HAND_MAX_HAND_NUM, MAX_NUM);
    CHECK_RET_AND_RETURN(bef_effect_ai_hand_detect_setparam, ret)
    ret = bef_effect_ai_hand_detect_setparam(_handle, BEF_HAND_NARUTO_GESTURE, NARUTO_GESTURE);
    CHECK_RET_AND_RETURN(bef_effect_ai_hand_detect_setparam, ret)
    ret = bef_effect_ai_hand_detect_setparam(_handle, BEF_HNAD_ENLARGE_FACTOR_REG, ENLARGE_FACTOR);
    CHECK_RET_AND_RETURN(bef_effect_ai_hand_detect_setparam, ret)
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEHandAlgorithmResult *)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_HAND_TOB
    BEHandAlgorithmResult *result = [BEHandAlgorithmResult new];
    RECORD_TIME(detectHand)
    bef_effect_result_t ret = bef_effect_ai_hand_detect(_handle, buffer, format, width, height, stride, rotation, _detectConfig, &_handInfo, 0);
    STOP_TIME(detectHand)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_hand_detect, ret, result)
    result.handInfo = &_handInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_HAND_TOB

    bef_effect_ai_hand_detect_destroy(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEHandAlgorithmTask.HAND;
}

@end
