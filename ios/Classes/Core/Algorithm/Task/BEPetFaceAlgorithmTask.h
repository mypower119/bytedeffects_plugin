//
//  BEPetFaceAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_pet_face.h"

@protocol BEPetFaceResourceProvider <BEAlgorithmResourceProvider>

- (const char *)petFaceModelPath;

@end

@interface BEPetFaceAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_pet_face_result *petFaceInfo;

@end

@interface BEPetFaceAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)PET_FACE;

@end
