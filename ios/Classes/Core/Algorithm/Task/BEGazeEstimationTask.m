//
//  BEGazeEstimationTask.m
//  BytedEffects
//
//  Created by qun on 2020/9/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEGazeEstimationTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "BEFaceAlgorithmTask.h"

static const int LINE_LEN = 0;

@implementation BEGazeEstimationAlgorithmResult

@end
@interface BEGazeEstimationTask () {
    bef_ai_gaze_handle             _handle;
    bef_ai_gaze_estimation_info     _gazeInfo;
    BEFaceAlgorithmTask             *_faceTask;
}

@property (nonatomic, strong) id<BEGazeEstimationResourceProvider> provider;

@end

@implementation BEGazeEstimationTask

@dynamic provider;

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>) licenseProvider {
    self = [super initWithProvider:provider licenseProvider:licenseProvider];
    if (self) {
        _faceTask = [[BEFaceAlgorithmTask alloc] initWithProvider:provider licenseProvider:licenseProvider];
    }
    return self;
}

+ (BEAlgorithmKey *)GAZE_ESTIMATION {
    GET_TASK_KEY(gazeEstimation, NO)
}

- (int)initTask {
#if BEF_GAZE_ESTIMATION_TOB
    bef_effect_result_t ret = bef_effect_ai_gaze_estimation_create_handle(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_gaze_estimation_create_handle, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_gaze_estimation_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_gaze_estimation_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_gaze_estimation_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_gaze_estimation_check_online_license, ret)
    }
    
    ret = bef_effect_ai_gaze_estimation_init_model(_handle, BEF_GAZE_ESTIMATION_MODEL1, self.provider.gazeModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_gaze_estimation_init_model, ret)
    ret = [_faceTask initTask];
    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
    
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_GAZE_ESTIMATION_TOB
    BEGazeEstimationAlgorithmResult *result = [BEGazeEstimationAlgorithmResult new];
    
    BEFaceAlgorithmResult *faceRet = [_faceTask process:buffer width:width height:height stride:stride format:format rotation:rotation];
    
    memset(&_gazeInfo, 0, sizeof(bef_ai_gaze_estimation_info));
    bef_ai_face_info *faceInfo = faceRet.faceInfo;
    if (faceInfo != nil && faceInfo->face_count > 0) {
        RECORD_TIME(gazeEstimation)
        bef_effect_result_t ret = bef_effect_ai_gaze_estimation_detect(_handle, buffer, format, width, height, stride, rotation, faceInfo, LINE_LEN, &_gazeInfo);
        STOP_TIME(gazeEstimation)
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_gaze_estimation_detect, ret, result)
    }
    
    result.gazeInfo = &_gazeInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_GAZE_ESTIMATION_TOB
    bef_effect_ai_gaze_estimation_destroy(_handle);
    [_faceTask destroyTask];
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEGazeEstimationTask.GAZE_ESTIMATION;
}

@end
