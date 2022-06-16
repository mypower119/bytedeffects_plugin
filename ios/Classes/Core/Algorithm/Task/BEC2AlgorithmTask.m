//
//  BEC2AlgorithmTask.m
//  BytedEffects
//
//  Created by qun on 2020/8/17.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEC2AlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "bef_effect_ai_c2.h"

@implementation BEC2AlgorithmResult

@end
@interface BEC2AlgorithmTask () {
    bef_ai_c2_handle         _handle;
    bef_ai_c2_ret               *_c2Info;
}

@property (nonatomic, strong) id<BEC2ResourceProvider> provider;

@end

@implementation BEC2AlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)C2 {
    GET_TASK_KEY(c2, YES)
}

- (int)initTask {
#if BEF_C2_TOB
    bef_effect_result_t ret = bef_effect_ai_c2_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_c2_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_c2_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_c2_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_c2_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_c2_check_online_license, ret);
    }
    
    _c2Info = bef_effect_ai_c2_init_ret(_handle);
    ret = bef_effect_ai_c2_set_model(_handle, BEF_AI_kC2Model1, self.provider.c2Model);
    CHECK_RET_AND_RETURN(bef_effect_ai_c2_set_model, ret)
    ret = bef_effect_ai_c2_set_paramF(_handle, BEF_AI_C2_USE_VIDEO_MODE, 1);
    CHECK_RET_AND_RETURN(bef_effect_ai_c2_set_paramF, ret)
    ret = bef_effect_ai_c2_set_paramF(_handle, BEF_AI_C2_USE_MultiLabels, 1);
    CHECK_RET_AND_RETURN(bef_effect_ai_c2_set_paramF, ret)
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEC2AlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_C2_TOB
    if (_c2Info == nil) return nil;
    
    BEC2AlgorithmResult *result = [BEC2AlgorithmResult new];
    RECORD_TIME(c2)
    bef_effect_result_t ret = bef_effect_ai_c2_detect(_handle, buffer, format, widht, height, stride, rotation, _c2Info);
    STOP_TIME(c2)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_c2_detect, ret, result)
    
    result.c2Info = _c2Info;
    return result;
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_C2_TOB
    bef_effect_ai_c2_release_ret(_handle, _c2Info);
    bef_effect_ai_c2_release(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}


- (BEAlgorithmKey *)key {
    return BEC2AlgorithmTask.C2;
}

@end
