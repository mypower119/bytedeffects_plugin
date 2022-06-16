//
//  BEHumanDistanceAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"
#import "bef_effect_ai_face_detect.h"
#import "bef_effect_ai_human_distance.h"

@protocol BEHumanDistanceResourceProvider <BEFaceResourceProvider>

@end

@interface BEHumanDistanceAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_face_info *faceInfo;
@property (nonatomic, assign) bef_ai_human_distance_result *distanceInfo;

@end

@interface BEHumanDistanceAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)HUMAN_DISTANCE;

- (void)setFOV:(float)fov;

@end
