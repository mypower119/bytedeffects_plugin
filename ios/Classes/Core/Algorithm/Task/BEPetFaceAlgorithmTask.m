//
//  BEPetFaceAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEPetFaceAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static long long DETECT_CONFIG = BEF_DetCat|BEF_DetDog;
static int MAX_NUM = AI_MAX_PET_NUM;

@implementation BEPetFaceAlgorithmResult

@end
@interface BEPetFaceAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_pet_face_result          _petFaceInfo;
}

@property (nonatomic, strong) id<BEPetFaceResourceProvider> provider;

@end

@implementation BEPetFaceAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)PET_FACE {
    GET_TASK_KEY(petFace, YES)
}

- (int)initTask {
#if BEF_PET_FACE_TOB
    bef_effect_result_t ret = bef_effect_ai_pet_face_create(self.provider.petFaceModelPath, DETECT_CONFIG, MAX_NUM, &_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_pet_face_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_pet_face_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_pet_face_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;

        ret = bef_effect_ai_pet_face_check_online_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_pet_face_check_online_license, ret)
    }
    
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_PET_FACE_TOB

    BEPetFaceAlgorithmResult *result = [BEPetFaceAlgorithmResult new];
    RECORD_TIME(petFace)
    bef_effect_result_t ret = bef_effect_ai_pet_face_detect(_handle, buffer, format, width, height, stride, rotation, &_petFaceInfo);
    STOP_TIME(petFace)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_pet_face_detect, ret, result)
    result.petFaceInfo = &_petFaceInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_PET_FACE_TOB
    bef_effect_ai_pet_face_release(_handle);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEPetFaceAlgorithmTask.PET_FACE;
}

@end
