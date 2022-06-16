//
//  BECarDamageDetectTask.m
//  BytedEffects
//
//  Created by qun on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BECarDetectTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "bef_effect_ai_car_detect.h"

@implementation BECarAlgorithmResult

@end
@interface BECarDetectTask () {
    bef_ai_car_handle         _handle;
    bef_ai_car_ret              _carInfo;
}

@property (nonatomic, strong) id<BECarResourceProvider> provider;

@end

@implementation BECarDetectTask

@dynamic provider;

+ (BEAlgorithmKey *)CAR {
    GET_TASK_KEY(car, YES)
}

+ (BEAlgorithmKey *)CAR_DETECT {
    GET_TASK_KEY(carDetect, NO)
}

+ (BEAlgorithmKey *)CAR_BRAND_DETECT {
    GET_TASK_KEY(carBrand, NO)
}

- (int)initTask {
#if BEF_CAR_DETECT_TOB
    int ret = bef_effect_ai_car_detect_create_handle(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_create_handle, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_car_detect_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_car_detect_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_check_online_license, ret);
    }
    
    ret = bef_effect_ai_car_detect_init_model(_handle, BEF_AI_CarDetectModel, self.provider.carDetectModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_init_model, ret)
    ret = bef_effect_ai_car_detect_init_model(_handle, BEF_AI_BrandDetectModel, self.provider.carLandmarkModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_init_model, ret)
    ret = bef_effect_ai_car_detect_init_model(_handle, BEF_AI_BrandOcrModel, self.provider.carPlateOcrModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_init_model, ret)
    ret = bef_effect_ai_car_detect_init_model(_handle, BEF_AI_CarTrackModel, self.provider.carTrackModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_car_detect_init_model, ret)
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BECarAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_CAR_DETECT_TOB
    BECarAlgorithmResult *result = [BECarAlgorithmResult new];
    memset(&_carInfo, 0, sizeof(bef_ai_car_ret));
    RECORD_TIME(carDetect)
    int ret = bef_effect_ai_car_detect_detect(_handle, buffer, format, widht, height, stride, rotation, &_carInfo);
    STOP_TIME(carDetect)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_car_detect_detect, ret, result)
    
    result.carInfo = &_carInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_CAR_DETECT_TOB
    bef_effect_ai_car_detect_destroy(_handle);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BECarDetectTask.CAR;
}

- (void)setConfig:(BEAlgorithmKey *)key p:(NSObject *)p {
#if BEF_CAR_DETECT_TOB
    [super setConfig:key p:p];
    
    int ret = bef_effect_ai_car_detect_set_paramf(_handle, BEF_AI_BrandRec, [self boolConfig:BECarDetectTask.CAR_BRAND_DETECT orDefault:NO] ? 1.f : -1.f);
    ret = bef_effect_ai_car_detect_set_paramf(_handle, BEF_AI_CarDetct, [self boolConfig:BECarDetectTask.CAR_DETECT orDefault:NO] ? 1.f : -1.f);
#endif
}

@end
