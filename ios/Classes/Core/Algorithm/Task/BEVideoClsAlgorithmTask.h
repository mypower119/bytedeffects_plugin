//
//  BEVideoClsAlgorithmTask.h
//  BytedEffects
//
//  Created by qun on 2020/8/17.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_video_cls.h"

@protocol BEVideoClsResourceProvider <BEAlgorithmResourceProvider>

- (const char *)videoClsModelPath;

@end

@interface BEVideoClsAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_video_cls_ret *videoInfo;

@end

@interface BEVideoClsAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)VIDEO_CLS;

@end
