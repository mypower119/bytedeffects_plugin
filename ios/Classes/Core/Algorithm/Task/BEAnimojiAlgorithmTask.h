//
//  BEAnimojiAlgorithmTask.h
//  BytedEffects
//
//  Created by qun on 2020/11/16.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEAnimojiAlgorithmTask_h
#define BEAnimojiAlgorithmTask_h

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_animoji.h"

@protocol BEAnimojiResourceProvider <BEAlgorithmResourceProvider>

- (const char *)animojiModelPath;

@end

@interface BEAnimojiAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_animoji_info *info;

@end

@interface BEAnimojiAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)ANIMOJI;

@end

#endif /* BEAnimojiAlgorithmTask_h */
