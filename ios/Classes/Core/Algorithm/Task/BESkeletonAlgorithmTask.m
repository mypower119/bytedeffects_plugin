//
//  BESkeletonAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BESkeletonAlgorithmTask.h"

static int MAX_NUM = 1;

@implementation BESkeletonAlgorithmResult

@end

@interface BESkeletonAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_skeleton_info            *_skeletonInfo;
}

@property (nonatomic, strong) id<BESkeletonResourceProvider> provider;

@end

@implementation BESkeletonAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)SKELETON {
    GET_TASK_KEY(skeleton, YES)
}

- (int)initTask {
#if BEF_SKELETON_TOB
    bef_effect_result_t ret = bef_effect_ai_skeleton_create(self.provider.skeletonModel, &_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_skeleton_create, ret)

    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_skeleton_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_skeleton_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        ret = bef_effect_ai_skeleton_check_online_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_skeleton_check_online_license, ret);
    }
    
    ret = bef_effect_ai_skeleton_set_targetnum(_handle, MAX_NUM);
    CHECK_RET_AND_RETURN(bef_effect_ai_skeleton_set_targetnum, ret)
    
    _skeletonInfo = malloc(BEF_AI_MAX_SKELETON_NUM * sizeof(bef_ai_skeleton_info));
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BESkeletonAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_SKELETON_TOB

    BESkeletonAlgorithmResult *result = [BESkeletonAlgorithmResult new];
    int validCount = BEF_AI_MAX_SKELETON_NUM;
    RECORD_TIME(detectSkeleton)
    bef_effect_result_t ret = bef_effect_ai_skeleton_detect(_handle, buffer, format, widht, height, stride, rotation, &validCount, &_skeletonInfo);
    STOP_TIME(detectSkeleton)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_skeleton_detect, ret, result)
    result.skeletonInfo = _skeletonInfo;
    result.count = validCount;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_SKELETON_TOB

    bef_effect_ai_skeleton_destroy(_handle);
    free(_skeletonInfo);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BESkeletonAlgorithmTask.SKELETON;
}

@end
