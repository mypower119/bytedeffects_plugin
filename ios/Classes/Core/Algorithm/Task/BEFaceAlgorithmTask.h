//
//  BEFaceAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/6.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_face_detect.h"
#import "bef_effect_ai_face_attribute.h"

@protocol BEFaceResourceProvider <BEAlgorithmResourceProvider>

- (const char *)faceModel;
- (const char *)faceExtraModel;
- (const char *)faceAttrModel;

@end

@interface BEFaceAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_face_info *faceInfo;
@property (nonatomic, assign) bef_ai_face_attribute_result *faceAttrInfo;
@property (nonatomic, assign) bef_ai_face_mask_info *faceMask;
@property (nonatomic, assign) bef_ai_mouth_mask_info *mouthMask;
@property (nonatomic, assign) bef_ai_teeth_mask_info *teethMask;

@end

@interface BEFaceAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)FACE_106;
+ (BEAlgorithmKey *)FACE_280;
+ (BEAlgorithmKey *)FACE_ATTR;
+ (BEAlgorithmKey *)FACE_MASK;
+ (BEAlgorithmKey *)MOUTH_MASK;
+ (BEAlgorithmKey *)TEETH_MASK;

@property (nonatomic, assign) unsigned long long initConfig;
@property (nonatomic, assign) unsigned long long detectConfig;
@property (nonatomic, assign) int maxFaceNum;

@end
