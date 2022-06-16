//
//  BEDynamicGestureAlgorithmTask.h
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_bach_skeleton.h"

@protocol BEBachSkeletonResourceProvider <BEAlgorithmResourceProvider>

- (const char *)bachSkeletonModel;

@end

@interface BEBachSkeletonAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_bach_skeleton_info *skeletonInfo;
@property (nonatomic, assign) int count;

@end

@interface BEBachSkeletonAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)BACH_SKELETON;

@end
