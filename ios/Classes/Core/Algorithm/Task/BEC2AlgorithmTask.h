//
//  BEC2AlgorithmTask.h
//  BytedEffects
//
//  Created by qun on 2020/8/17.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_c2.h"

@protocol BEC2ResourceProvider <BEAlgorithmResourceProvider>
- (const char *)c2Model;
@end

@interface BEC2AlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_c2_ret *c2Info;

@end

@interface BEC2AlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)C2;

@end
