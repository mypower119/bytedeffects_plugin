//
//  BEAlgorithmUIFactory.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEAlgorithmUIFactory.h"
#import "BEFaceUI.h"
#import "BEHandUI.h"
#import "BESkeletonUI.h"
#import "BEPetFaceUI.h"
#import "BEHeadSegUI.h"
#import "BEPortraitMattingUI.h"
#import "BEHairParserUI.h"
#import "BESkySegUI.h"
#import "BELightClsUI.h"
#import "BEHumanDistanceUI.h"
#import "BEConcentrationUI.h"
#import "BEGazeEstimationUI.h"
#import "BEC1UI.h"
#import "BEC2UI.h"
#import "BEVideoClsUI.h"
#import "BECarUI.h"
#import "BEFaceVerifyUI.h"
#import "BEFaceClusterUI.h"
#import "BEDynamicGestureUI.h"
#import "BESkinSegUI.h"
#import "BEBachSkeletonUI.h"
#import "BEChromaKeyingUI.h"

#import "BEFaceAlgorithmTask.h"
#import "BEHandAlgorithmTask.h"
#import "BESkeletonAlgorithmTask.h"
#import "BEPetFaceAlgorithmTask.h"
#import "BEHeadSegmentAlgorithmTask.h"
#import "BEPortraitMattingAlgorithmTask.h"
#import "BEHairParserAlgorithmTask.h"
#import "BESkySegAlgorithmTask.h"
#import "BELightClsAlgorithmTask.h"
#import "BEHumanDistanceAlgorithmTask.h"
#import "BEConcentrationTask.h"
#import "BEGazeEstimationTask.h"
#import "BEC1AlgorithmTask.h"
#import "BEC2AlgorithmTask.h"
#import "BEVideoClsAlgorithmTask.h"
#import "BECarDetectTask.h"
#import "BEFaceVerifyAlgorithmTask.h"
#import "BEFaceClusterAlgorithmTask.h"
#import "BEAnimojiAlgorithmTask.h"
#import "BEDynamicGestureAlgorithmTask.h"
#import "BESkinSegmentationAlgorithmTask.h"
#import "BEBachSkeletonAlgorithmTask.h"
#import "BEChromaKeyingAlgorithmTask.h"

#define REGISTER_ALGORITHM_UI(KEY, ALGORITHM_UI)\
[self register:KEY generator:^id<BEAlgorithmUI>{\
    return [[ALGORITHM_UI alloc] init];\
}];

static NSMutableDictionary<BEAlgorithmKey *, BEAlgorithmUIFactoryGenerator> *dict;
@interface BEAlgorithmUIFactory ()

@end

@implementation BEAlgorithmUIFactory

+ (void)initialize
{
    if (self == [BEAlgorithmUIFactory class]) {
        dict = [NSMutableDictionary dictionary];
        
        REGISTER_ALGORITHM_UI(BEFaceAlgorithmTask.FACE_106, BEFaceUI)
        REGISTER_ALGORITHM_UI(BEHandAlgorithmTask.HAND, BEHandUI)
        REGISTER_ALGORITHM_UI(BESkeletonAlgorithmTask.SKELETON, BESkeletonUI)
        REGISTER_ALGORITHM_UI(BEPetFaceAlgorithmTask.PET_FACE, BEPetFaceUI)
        REGISTER_ALGORITHM_UI(BEHeadSegmentAlgorithmTask.HEAD_SEGMENT, BEHeadSegUI)
        REGISTER_ALGORITHM_UI(BEPortraitMattingAlgorithmTask.PORTRAIT_MATTING, BEPortraitMattingUI)
        REGISTER_ALGORITHM_UI(BEHairParserAlgorithmTask.HAIR_PARSER, BEHairParserUI)
        REGISTER_ALGORITHM_UI(BESkySegAlgorithmTask.SKY_SEG, BESkySegUI)
        REGISTER_ALGORITHM_UI(BELightClsAlgorithmTask.LIGHT_CLS, BELightClsUI)
        REGISTER_ALGORITHM_UI(BEHumanDistanceAlgorithmTask.HUMAN_DISTANCE, BEHumanDistanceUI)
        REGISTER_ALGORITHM_UI(BEConcentrationTask.CONCENTRATION, BEConcentrationUI)
        REGISTER_ALGORITHM_UI(BEGazeEstimationTask.GAZE_ESTIMATION, BEGazeEstimationUI)
        REGISTER_ALGORITHM_UI(BEC1AlgorithmTask.C1, BEC1UI)
        REGISTER_ALGORITHM_UI(BEC2AlgorithmTask.C2, BEC2UI)
        REGISTER_ALGORITHM_UI(BEVideoClsAlgorithmTask.VIDEO_CLS, BEVideoClsUI)
        REGISTER_ALGORITHM_UI(BECarDetectTask.CAR, BECarUI)
        REGISTER_ALGORITHM_UI(BEFaceVerifyAlgorithmTask.FACE_VERIFY, BEFaceVerifyUI)
        REGISTER_ALGORITHM_UI(BEFaceClusterAlgorithmTask.FACE_CLUSTER, BEFaceClusterUI)
        REGISTER_ALGORITHM_UI(BEDynamicGestureAlgorithmTask.DYNAMIC_GESTURE, BEDynamicGestureUI)
        REGISTER_ALGORITHM_UI(BESkinSegmentationAlgorithmTask.SKIN_SEGMENTATION, BESkinSegUI)
        REGISTER_ALGORITHM_UI(BEBachSkeletonAlgorithmTask.BACH_SKELETON, BEBachSkeletonUI)
        REGISTER_ALGORITHM_UI(BEChromaKeyingAlgorithmTask.CHROMA_KEYING, BEChromaKeyingUI)
    }
}

+ (void)register:(BEAlgorithmKey *)key generator:(BEAlgorithmUIFactoryGenerator)generator {
    [dict setObject:generator forKey:key];
}

+ (id<BEAlgorithmUI>)create:(BEAlgorithmKey *)key {
    if (![dict.allKeys containsObject:key]) {
        return nil;
    }
    
    BEAlgorithmUIFactoryGenerator generator = [dict objectForKey:key];
    return generator();
}

@end
