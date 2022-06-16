//
//  BEC1AlgorithmTask.h
//  BytedEffects
//
//  Created by qun on 2020/8/14.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_c1.h"

@protocol BEC1ResourceProvider <BEAlgorithmResourceProvider>
- (const char *)c1ModelPath;
@end

@interface BEC1AlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_c1_output *c1Info;

@end

@interface BEC1AlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)C1;

@end
