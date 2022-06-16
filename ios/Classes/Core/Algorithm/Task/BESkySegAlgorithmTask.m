//
//  BESkySegAlgorithmTask.m
//  BytedEffects
//
//  Created by qun on 2020/10/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BESkySegAlgorithmTask.h"
#import "bef_effect_ai_skyseg.h"
#import "BEAlgorithmTaskFactory.h"

static int WIDTH = 128;
static int HEIGHT = 224;

@implementation BESkySegAlgorithmResult

@end
@interface BESkySegAlgorithmTask () {
    bef_ai_skyseg_handle            _handle;
    unsigned char                   *_skySegInfo;
    int                             _size[3];
    int                             _skySegInfoLen;
}

@property (nonatomic, strong) id<BESkyResourceProvider> provider;

@end

@implementation BESkySegAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)SKY_SEG {
    GET_TASK_KEY(skySeg, YES)
}

- (int)initTask {
#if BEF_SKY_SEG_TOB
    bef_effect_result_t ret = bef_effect_ai_skyseg_create_handle(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_skyseg_create_handle, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_skyseg_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_skyseg_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_skyseg_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_check_online_license, ret);
    }
    
    ret = bef_effect_ai_skyseg_init_model(_handle, self.provider.skySegModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_skyseg_init_model, ret)
    ret = bef_effect_ai_skyseg_set_param(_handle, WIDTH, HEIGHT);
    CHECK_RET_AND_RETURN(bef_effect_ai_skyseg_set_param, ret)
    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_SKY_SEG_TOB
    BESkySegAlgorithmResult *result = [BESkySegAlgorithmResult new];
    bef_effect_result_t ret = bef_effect_ai_skyseg_get_output_shape(_handle, _size, _size + 1, _size + 2);
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_skyseg_get_output_shape, ret, result)
    if (_skySegInfoLen != _size[0] * _size[1] * _size[2]) {
        if (_skySegInfo != nil) {
            free(_skySegInfo);
        }
        _skySegInfoLen = _size[0] * _size[1] * _size[2];
        _skySegInfo = malloc(_skySegInfoLen);
    }
    
    bool hasSky;
    RECORD_TIME(skySeg)
    ret = bef_effect_ai_skyseg_detect(_handle, buffer, format, width, height, stride, rotation, _skySegInfo, false, true, &hasSky);
    STOP_TIME(skySeg)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_skyseg_detect, ret, result)
    result.mask = _skySegInfo;
    result.size = _size;
    result.hasSky = hasSky;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_SKY_SEG_TOB
    bef_effect_ai_skyseg_destroy(_handle);
    free(_skySegInfo);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BESkySegAlgorithmTask.SKY_SEG;
}

@end
