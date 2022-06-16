//
//  BESkeletonAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEActionRecognitionAlgorithmTask.h"

@implementation BEActionRecognitionAlgorithmResult

@end

@interface BEActionRecognitionAlgorithmTask () {
    bef_effect_handle_t             _handle;
    bef_ai_action_recognition_result            *_actionRecognitionInfo;
    int _confirm_time;
}

@property (nonatomic, strong) id<BEActionRecognitionResourceProvider> provider;

@end

@implementation BEActionRecognitionAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)ACTION_RECOGNITION {
    GET_TASK_KEY(action_recognition, YES)
}

- (int)initTaskWithSportName:(NSString*)name {
#if BEF_ACTION_RECOGNITION_TOB
    bef_effect_result_t ret = bef_effect_ai_action_recognition_create(self.provider.actionRecognitionModel, &_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_action_recognition_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_action_recognition_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_action_recognition_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_action_recognition_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_action_recognition_check_online_license, ret)
    }
    const char* path = NULL;
    [self getTemplatePathWithSportsName:name path:&path];
    ret = bef_effect_ai_action_recognition_set_template(_handle,path);
    CHECK_RET_AND_RETURN(bef_effect_ai_action_recognition_set_template, ret)
    
    _actionRecognitionInfo = malloc(sizeof(bef_ai_action_recognition_result));
    
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

-(void)getTemplatePathWithSportsName:(NSString*)name path:(const char**)path
{
    _confirm_time = 3000;
    if([name isEqualToString:@"openclose"])
    {
        *path = self.provider.actionRecognitionTMPL_OpenClose;
        _confirm_time = 2000;
    }
    else if([name isEqualToString:@"plank"])
    {
        *path = self.provider.actionRecognitionTMPL_PLANK;
    }
    else if([name isEqualToString:@"situp"])
    {
        *path = self.provider.actionRecognitionTMPL_SITUP;
    }
    else if([name isEqualToString:@"squat"])
    {
        *path = self.provider.actionRecognitionTMPL_SQUAT;
    }
    else if([name isEqualToString:@"pushup"])
    {
        *path = self.provider.actionRecognitionTMPL_PUSHUP;
    }
    else if([name isEqualToString:@"lunge"])
    {
        *path = self.provider.actionRecognitionTMPL_LUNGE;
    }
    else if([name isEqualToString:@"lunge_squat"])
    {
        *path = self.provider.actionRecognitionTMPL_LUNGESQUAT;
    }
    else if([name isEqualToString:@"high_run"])
    {
        *path = self.provider.actionRecognitionTMPL_HIGHRUN;
    }
    else if([name isEqualToString:@"hip_bridge"])
    {
        *path = self.provider.actionRecognitionTMPL_HIPBRIDGE;
    }
    else if([name isEqualToString:@"kneeling_pushup"])
    {
        *path = self.provider.actionRecognitionTMPL_KNEELINGPUSHUP;
    }
    else
    {
        NSAssert(1, @"no template for %@!",name);
    }    
}

- (BEActionRecognitionAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_ACTION_RECOGNITION_TOB

    BEActionRecognitionAlgorithmResult *result = [BEActionRecognitionAlgorithmResult new];
    RECORD_TIME(detectActionRecognition)
    bef_effect_result_t ret = bef_effect_ai_action_recognition_count(_handle, buffer, format, widht, height, stride, rotation,_confirm_time,  _actionRecognitionInfo);
    STOP_TIME(detectActionRecognition)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_action_recognition_count, ret, result)
    result.actionRecognitionInfo = _actionRecognitionInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_ACTION_RECOGNITION_TOB

    bef_effect_ai_action_recognition_destroy(_handle);
    free(_actionRecognitionInfo);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BOOL)readyPostDetect:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation readyPoseType:(bef_ai_action_recognition_start_pose_type) type {
#if BEF_ACTION_RECOGNITION_TOB

    bef_ai_action_recognition_start_pose_result result;
    RECORD_TIME(readyPoseDetect)
    bef_effect_result_t ret = bef_effect_ai_action_recognition_start_pose_detect(_handle, buffer, format, widht, height, stride, rotation,  type, &result);
    STOP_TIME(readyPoseDetect)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_action_recognition_start_pose_detect, ret, NO)
        
    return result.is_detected;
    
#endif
    return nil;
}

- (BEAlgorithmKey *)key {
    return BEActionRecognitionAlgorithmTask.ACTION_RECOGNITION;
}

@end
