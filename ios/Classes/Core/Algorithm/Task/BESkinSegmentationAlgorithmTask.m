//
//  BEDynamicGestureAlgorithmResult.m
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BESkinSegmentationAlgorithmTask.h"

@implementation BESkinSegmentationAlgorithmResult

@end
@interface BESkinSegmentationAlgorithmTask () {
    bef_effect_handle_t           _handle;
    bef_ai_skin_segmentation_ret  _skinSegInfo;
}

@property (nonatomic, strong) id<BESkinSegmentationResourceProvider> provider;

@end

@implementation BESkinSegmentationAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)SKIN_SEGMENTATION {
    GET_TASK_KEY(skinSegmentation, YES)
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (int)initTask {
#if BEF_SKIN_SEGMENTATION_TOB
    bef_effect_result_t ret = bef_effect_ai_skin_segmentation_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_skin_segmentation_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_skin_segmentation_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_skin_segmentation_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_skin_segmentation_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_skin_segmentation_check_online_license, ret);
    }
    
    ret = bef_effect_ai_skin_segmentation_init(_handle, self.provider.skinSegmentationModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_skin_segmentation_init, ret)
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BESkinSegmentationAlgorithmResult *)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_SKIN_SEGMENTATION_TOB
    BESkinSegmentationAlgorithmResult *result = [BESkinSegmentationAlgorithmResult new];
    RECORD_TIME(skinSegmentation)
    bef_effect_result_t ret = bef_effect_ai_skin_segmentation_detect(_handle, buffer, format, width, height, stride, rotation, &_skinSegInfo);
    STOP_TIME(skinSegmentation)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_skin_segmentation_detect, ret, result);
    
    result.skinSegInfo = &_skinSegInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_SKIN_SEGMENTATION_TOB

    return bef_effect_ai_skin_segmentation_release(_handle);
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BESkinSegmentationAlgorithmTask.SKIN_SEGMENTATION;
}

@end
