//
//  BEHandAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_hand.h"

@protocol BEHandResourceProvider <BEAlgorithmResourceProvider>

- (const char *)handModel;
- (const char *)handBoxModel;
- (const char *)handGestureModel;
- (const char *)handKeyPointModel;

@end

@interface BEHandAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_hand_info *handInfo;

@end


@interface BEHandAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)HAND;

@end
