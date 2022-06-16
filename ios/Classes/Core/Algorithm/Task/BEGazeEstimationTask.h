//
//  BEGazeEstimationTask.h
//  BytedEffects
//
//  Created by qun on 2020/9/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"
#import "bef_effect_ai_gaze_estimation.h"

@protocol BEGazeEstimationResourceProvider <BEAlgorithmResourceProvider, BEFaceResourceProvider>

- (const char *)gazeModel;

@end

@interface BEGazeEstimationAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_gaze_estimation_info *gazeInfo;

@end

@interface BEGazeEstimationTask : BEAlgorithmTask

+ (BEAlgorithmKey *)GAZE_ESTIMATION;

@end
