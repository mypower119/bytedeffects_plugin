//
//  BEDynamicGestureAlgorithmResult.m
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEBachSkeletonAlgorithmTask.h"

@implementation BEBachSkeletonAlgorithmResult

@end

@interface BEBachSkeletonAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_bach_skeleton_info       *_skeletonInfo;
}

@property (nonatomic, strong) id<BEBachSkeletonResourceProvider> provider;

@end

@implementation BEBachSkeletonAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)BACH_SKELETON {
    GET_TASK_KEY(bachSkeleton, YES)
}

- (int)initTask {
#if BEF_BACH_SKELETON_TOB
    bef_effect_result_t ret = bef_effect_ai_bach_skeleton_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_bach_skeleton_create, ret)

    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_bach_skeleton_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_bach_skeleton_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_bach_skeleton_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_bach_skeleton_check_online_license, ret);
    }
    
    ret = bef_effect_ai_bach_skeleton_init(_handle, self.provider.bachSkeletonModel);
    
    _skeletonInfo = malloc(BEF_AI_MAX_BACH_SKELETON_NUM * sizeof(bef_ai_bach_skeleton_info));
    
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEBachSkeletonAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_BACH_SKELETON_TOB

    BEBachSkeletonAlgorithmResult *result = [BEBachSkeletonAlgorithmResult new];
    int validCount = BEF_AI_MAX_BACH_SKELETON_NUM;
    RECORD_TIME(detectSkeleton)
    bef_effect_result_t ret = bef_effect_ai_bach_skeleton_detect(_handle, buffer, format, widht, height, stride, rotation, &validCount, &_skeletonInfo);
    STOP_TIME(detectSkeleton)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_bach_skeleton_detect, ret, result)
    result.skeletonInfo = _skeletonInfo;
    result.count = validCount;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_BACH_SKELETON_TOB
    free(_skeletonInfo);
    return bef_effect_ai_bach_skeleton_release(_handle);
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEBachSkeletonAlgorithmTask.BACH_SKELETON;
}

@end
