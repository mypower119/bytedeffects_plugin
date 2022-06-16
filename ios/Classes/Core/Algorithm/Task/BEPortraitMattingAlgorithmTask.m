//
//  BEPortraitMattingAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEPortraitMattingAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "bef_effect_ai_portrait_matting.h"

static int MP_EDGE_MODE = 1;
static int MP_FRASH_EVERY = 15;

@implementation BEPortraitMattingAlgorithmResult

@end
@interface BEPortraitMattingAlgorithmTask () {
    bef_effect_handle_t             _handle;
    int                             _size[3];
    unsigned char                   *_alpha;
    int                             _alphaLen;
}

@property (nonatomic, strong) id<BEPortraitMattingResourceProvider> provider;

@end

@implementation BEPortraitMattingAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)PORTRAIT_MATTING {
    GET_TASK_KEY(portraitMatting, YES)
}

- (int)initTask {
#if BEF_PORTRAIT_MATTING_TOB
    bef_effect_result_t ret = bef_effect_ai_portrait_matting_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_portrait_matting_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_matting_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_matting_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_matting_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_matting_check_online_license, ret)
    }
    
    ret = bef_effect_ai_portrait_matting_init_model(_handle, BEF_MP_LARGE_MODEL, self.provider.portraitMattingModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_portrait_matting_init_model, ret)
    ret = bef_effect_ai_portrait_matting_set_param(_handle, BEF_MP_EdgeMode, MP_EDGE_MODE);
    CHECK_RET_AND_RETURN(bef_effect_ai_portrait_matting_set_param, ret)
    ret = bef_effect_ai_portrait_matting_set_param(_handle, BEF_MP_FrashEvery, MP_FRASH_EVERY);
    CHECK_RET_AND_RETURN(bef_effect_ai_portrait_matting_set_param, ret)
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_PORTRAIT_MATTING_TOB

    BEPortraitMattingAlgorithmResult *result = [BEPortraitMattingAlgorithmResult new];
    
    if (_alphaLen != width * height) {
        if (_alpha != nil) {
            free(_alpha);
        }
        _alpha = (unsigned char *)malloc(width * height);
    }
    bef_ai_matting_ret mattingRet = {_alpha, width, height};
    RECORD_TIME(detectMatting)
    bef_effect_result_t ret = bef_effect_ai_portrait_matting_do_detect(_handle, buffer, format, width, height, stride, rotation, false, &mattingRet);
    STOP_TIME(detectMatting)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_portrait_matting_do_detect, ret, result)
    _size[0] = mattingRet.width;
    _size[1] = mattingRet.height;
    _size[2] = 1;
    result.mask = _alpha;
    result.size = _size;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_PORTRAIT_MATTING_TOB

    bef_effect_ai_portrait_matting_destroy(_handle);
    free(_alpha);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEPortraitMattingAlgorithmTask.PORTRAIT_MATTING;
}

@end
