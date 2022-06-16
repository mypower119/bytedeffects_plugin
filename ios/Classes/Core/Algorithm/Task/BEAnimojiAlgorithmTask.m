//
//  BEAnimojiAlgorithmTask.m
//  BytedEffects
//
//  Created by qun on 2020/11/16.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAnimojiAlgorithmTask.h"
#import "bef_effect_ai_animoji.h"

static const int INPUT_WIDTH = 256;
static const int INPUT_HEIGHT = 256;

@implementation BEAnimojiAlgorithmResult

@end

@interface BEAnimojiAlgorithmTask () {
    bef_ai_animoji_handle           _handle;
    bef_ai_animoji_info             _info;
}

@property (nonatomic, strong) id<BEAnimojiResourceProvider> provider;

@end


@implementation BEAnimojiAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)ANIMOJI {
    GET_TASK_KEY(animoji, YES)
}

- (int)initTask {
#if 0
    bef_effect_result_t ret = bef_effect_ai_animoji_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_animoji_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_animoji_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_animoji_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_animoji_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_animoji_check_online_license, ret)
    }
    
    ret = bef_effect_ai_animoji_set_model(_handle, self.provider.animojiModelPath, INPUT_WIDTH, INPUT_HEIGHT);
    CHECK_RET_AND_RETURN(bef_effect_ai_animoji_set_model, ret)
    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAnimojiAlgorithmResult *)process:(const char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if 0
    BEAnimojiAlgorithmResult *result = [BEAnimojiAlgorithmResult new];
    memset(&_info, 0, sizeof(bef_ai_animoji_info));
    RECORD_TIME(animoji)
    bef_effect_result_t ret = bef_effect_ai_animoji_detect(_handle, buffer, format, widht, height, stride, rotation, &_info);
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_animoji_detect, ret, result)
    STOP_TIME(animoji)
    result.info = &_info;
    return result;
#endif
    return nil;
}

- (int)destroyTask {
#if 0
    bef_effect_ai_animoji_release(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEAnimojiAlgorithmTask.ANIMOJI;
}

@end
