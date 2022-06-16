//
//  BEDynamicGestureAlgorithmResult.m
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEDynamicGestureAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static int MAX_NUM = 1;

@implementation BEDynamicGestureAlgorithmResult

@end
@interface BEDynamicGestureAlgorithmTask () {
    bef_effect_handle_t           _handle;
    bef_ai_dynamic_gesture_info   *_gestureInfo;
}

@property (nonatomic, strong) id<BEDynamicGestureResourceProvider> provider;

@end

@implementation BEDynamicGestureAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)DYNAMIC_GESTURE {
    GET_TASK_KEY(dynamicGesture, YES)
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (int)initTask {
#if BEF_DYNAMIC_GESTURE_TOB
    bef_effect_result_t ret = bef_effect_ai_dynamic_gesture_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_dynamic_gesture_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_dynamic_gesture_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_dynamic_gesture_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_dynamic_gesture_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_dynamic_gesture_check_online_license, ret);
    }
    
    ret = bef_effect_ai_dynamic_gesture_init(_handle, self.provider.dynamicGestureModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_dynamic_gesture_init, ret)
    
    ret = bef_effect_ai_dynamic_gesture_set_paramS(_handle, BEF_AI_DYNAMIC_GESTURE_MODEL_GESTURE_CLS, "tsm_action_v1.2.model");
    CHECK_RET_AND_RETURN(bef_effect_ai_dynamic_gesture_set_paramS, ret);
    
    _gestureInfo = malloc(BEF_MAX_GESTURE_HAND_NUM * sizeof(bef_ai_dynamic_gesture_info));
    
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEDynamicGestureAlgorithmResult *)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_DYNAMIC_GESTURE_TOB
    int gestureNum = BEF_MAX_GESTURE_HAND_NUM;
    BEDynamicGestureAlgorithmResult *result = [BEDynamicGestureAlgorithmResult new];
    RECORD_TIME(dynamicGesture)
    bef_effect_result_t ret = bef_effect_ai_dynamic_gesture_detect(_handle, buffer, format, width, height, stride, rotation, &gestureNum, &_gestureInfo);
    STOP_TIME(dynamicGesture)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_hand_detect, ret, result)
    result.gestureInfo = _gestureInfo;
    result.gestureNum = gestureNum;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_DYNAMIC_GESTURE_TOB
    free(_gestureInfo);
    return bef_effect_ai_dynamic_gesture_release(_handle);
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEDynamicGestureAlgorithmTask.DYNAMIC_GESTURE;
}

@end
