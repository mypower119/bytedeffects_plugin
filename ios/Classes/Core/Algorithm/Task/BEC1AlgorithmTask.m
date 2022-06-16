//
//  BEC1AlgorithmTask.m
//  BytedEffects
//
//  Created by qun on 2020/8/14.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEC1AlgorithmTask.h"
#import "bef_effect_ai_c1.h"

@implementation BEC1AlgorithmResult

@end
@interface BEC1AlgorithmTask () {
    bef_ai_c1_handle         _handle;
    bef_ai_c1_output            _c1Info;
}

@property (nonatomic, strong) id<BEC1ResourceProvider> provider;

@end

@implementation BEC1AlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)C1 {
    GET_TASK_KEY(c1, YES)
}

- (int)initTask {
#if BEF_C1_TOB

    bef_effect_result_t ret = bef_effect_ai_c1_create(&_handle, BEF_AI_C1_MODEL_SMALL, self.provider.c1ModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_c1_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_c1_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_c1_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;

        ret = bef_effect_ai_c1_check_onine_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_c1_check_onine_license, ret)
    }

    ret = bef_effect_ai_c1_set_param(_handle, BEF_AI_C1_USE_MultiLabels, 1);
    CHECK_RET_AND_RETURN(bef_effect_ai_c1_set_param, ret)
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEC1AlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_C1_TOB
    BEC1AlgorithmResult *result = [BEC1AlgorithmResult new];
    RECORD_TIME(c1)
    bef_effect_result_t ret = bef_effect_ai_c1_detect(_handle, buffer, format, widht, height, stride, rotation, &_c1Info);
    STOP_TIME(c1)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_c1_detect, ret, result)
    result.c1Info = &_c1Info;
    return result;
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_C1_TOB
    bef_effect_ai_c1_release(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEC1AlgorithmTask.C1;
}

@end
