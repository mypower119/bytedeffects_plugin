//
//  BELightClsAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BELightClsAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static int FPS = 5;
@implementation BELightClsAlgorithmResult

@end
@interface BELightClsAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_light_cls_result         _lightClsInfo;
}

@property (nonatomic, strong) id<BELightClsResourceProvider> provider;

@end

@implementation BELightClsAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)LIGHT_CLS {
    GET_TASK_KEY(lightCls, YES)
}

- (int)initTask {
#if BEF_LIGHT_TOB
    bef_effect_result_t ret = bef_effect_ai_lightcls_create(&_handle, self.provider.lightClsModelPath, FPS);
    CHECK_RET_AND_RETURN(bef_effect_ai_lightcls_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_lightcls_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_lightcls_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;

        ret = bef_effect_ai_lightcls_check_online_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_lightcls_check_online_license, ret);
    }

    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_LIGHT_TOB

    BELightClsAlgorithmResult *result = [BELightClsAlgorithmResult new];
    RECORD_TIME(detectLight)
    bef_effect_result_t ret = bef_effect_ai_lightcls_detect(_handle, buffer, format, width, height, stride, rotation, &_lightClsInfo);
    STOP_TIME(detectLight)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_lightcls_detect, ret, result)
    result.ligthInfo = &_lightClsInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_LIGHT_TOB

    bef_effect_ai_lightcls_release(_handle);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BELightClsAlgorithmTask.LIGHT_CLS;
}

@end
