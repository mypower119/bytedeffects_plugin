//
//  BESkeletonAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_skeleton.h"

@protocol BESkeletonResourceProvider <BEAlgorithmResourceProvider>

- (const char *)skeletonModel;

@end

@interface BESkeletonAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_skeleton_info *skeletonInfo;
@property (nonatomic, assign) int count;

@end

@interface BESkeletonAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)SKELETON;

@end
