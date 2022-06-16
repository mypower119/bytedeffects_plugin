//
//  BEHumanDistanceAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEHumanDistanceAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"
#import <sys/utsname.h>

@implementation BEHumanDistanceAlgorithmResult

@end
@interface BEHumanDistanceAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_human_distance_result    _humanDistanceInfo;
    BEFaceAlgorithmTask             *_faceTask;
    
    float                           _fov;
    BOOL                            _frontCamera;
}

@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) id<BEHumanDistanceResourceProvider> provider;

@end

@implementation BEHumanDistanceAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)HUMAN_DISTANCE {
    GET_TASK_KEY(humanDistance, YES)
}

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>)licenseProvider {
    if (self = [super initWithProvider:provider licenseProvider:licenseProvider]) {
        _faceTask = [[BEFaceAlgorithmTask alloc] initWithProvider:provider licenseProvider:licenseProvider];
        [_faceTask setConfig:BEFaceAlgorithmTask.FACE_ATTR p:[NSNumber numberWithBool:YES]];
    }
    return self;
}

- (int)initTask {
#if BEF_DISTANCE_TOB
    bef_effect_result_t ret = bef_effect_ai_human_distance_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_human_distance_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_human_distance_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_human_distance_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_human_distance_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_human_distance_check_online_license, ret)
    }

//    ret = bef_effect_ai_human_distance_load_model(_handle, BEF_HumanDistanceModel1, self.provider.humanDistanceModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_human_distance_load_model, ret)
    ret = [_faceTask initTask];
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_DISTANCE_TOB
    BEHumanDistanceAlgorithmResult *result = [BEHumanDistanceAlgorithmResult new];
    
    BEFaceAlgorithmResult *faceRet = [_faceTask process:buffer width:width height:height stride:stride format:format rotation:rotation];
    bef_ai_face_info *faceInfo = faceRet.faceInfo;
    bef_ai_face_attribute_result *faceAttrInfo = faceRet.faceAttrInfo;
    
    if (faceAttrInfo != nil) {
        RECORD_TIME(humanDistance)
        bef_effect_result_t ret = bef_effect_ai_human_distance_detect_V2(_handle, buffer, format, width, height, stride, [self.deviceName UTF8String], _frontCamera, rotation, faceInfo, faceAttrInfo, &_humanDistanceInfo);
        STOP_TIME(humanDistance)
        CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_human_distance_detect_V2, ret, result)
    }
    
    result.distanceInfo = &_humanDistanceInfo;
    result.faceInfo = faceInfo;
    return result;
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_DISTANCE_TOB
    [_faceTask destroyTask];
    bef_effect_ai_human_distance_destroy(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEHumanDistanceAlgorithmTask.HUMAN_DISTANCE;
}

- (void)setFOV:(float)fov {
    _fov = fov;
#if BEF_DISTANCE_TOB
    bef_effect_ai_human_distance_setparam(_handle, BEF_HumanDistanceCameraFov, fov);
#endif
}

- (void)setConfig:(BEAlgorithmKey *)key p:(NSObject *)p {
    [super setConfig:key p:p];
    
    if ([key isEqual:self.class.ALGORITHM_FOV]) {
        [self setFOV:[(NSNumber *)p floatValue]];
    }
}

- (NSString *)deviceName {
    if (_deviceName == nil) {
        struct utsname info;
        uname(&info);
        _deviceName = [NSString stringWithCString: info.machine encoding:NSASCIIStringEncoding];
    }
    return _deviceName;
}

@end
