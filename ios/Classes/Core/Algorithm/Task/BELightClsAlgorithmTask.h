//
//  BELightClsAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_lightcls.h"

@protocol BELightClsResourceProvider <BEAlgorithmResourceProvider>

- (const char *)lightClsModelPath;

@end

@interface BELightClsAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_light_cls_result *ligthInfo;

@end

@interface BELightClsAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)LIGHT_CLS;

@end
