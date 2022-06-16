//
//  BEHeadSegmentAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"
#import "bef_effect_ai_headseg.h"

@protocol BEHeadSegmentResourceProvider <BEFaceResourceProvider>
- (const char *)headSegmentModelPath;
@end

@interface BEHeadSegmentAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_headseg_output *headSegInfo;

@end

@interface BEHeadSegmentAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)HEAD_SEGMENT;

@end
