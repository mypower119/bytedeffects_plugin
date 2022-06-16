//
//  BEActionRecognitionAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_action_recognition.h"



@protocol BEActionRecognitionResourceProvider <BEAlgorithmResourceProvider>

- (const char *)actionRecognitionModel;
- (const char *)actionRecognitionTMPL_OpenClose;
- (const char *)actionRecognitionTMPL_PLANK;
- (const char *)actionRecognitionTMPL_SITUP;
- (const char *)actionRecognitionTMPL_SQUAT;
- (const char *)actionRecognitionTMPL_PUSHUP;
- (const char *)actionRecognitionTMPL_HIGHRUN;
- (const char *)actionRecognitionTMPL_HIPBRIDGE;
- (const char *)actionRecognitionTMPL_LUNGE;
- (const char *)actionRecognitionTMPL_LUNGESQUAT;
- (const char *)actionRecognitionTMPL_KNEELINGPUSHUP;

@end

@interface BEActionRecognitionAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_action_recognition_result *actionRecognitionInfo;

@end

@interface BEActionRecognitionAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)ACTION_RECOGNITION;

- (int)initTaskWithSportName:(NSString*)name;
- (BOOL)readyPostDetect:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation readyPoseType:(bef_ai_action_recognition_start_pose_type) type;

@end
