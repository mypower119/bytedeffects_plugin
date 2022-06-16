//
//  BEAlgorithmTaskFactory.m
//  Core
//
//  Created by qun on 2021/5/17.
//

#import "BEAlgorithmTaskFactory.h"
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
#import "BEActionRecognitionAlgorithmTask.h"
#import "BEDynamicGestureAlgorithmTask.h"
#import "BESkinSegmentationAlgorithmTask.h"
#import "BEBachSkeletonAlgorithmTask.h"
#import "BEChromaKeyingAlgorithmTask.h"

#define REGISTER_ALGORITHM_TASK(CLASS, KEY)\
[self register:CLASS.KEY generator:^BEAlgorithmTask *(id<BEAlgorithmResourceProvider> provider, id<BELicenseProvider> licenseProvider) {\
return [[CLASS alloc] initWithProvider:provider licenseProvider:licenseProvider];\
}];

static NSMutableDictionary<BEAlgorithmKey *, BEAlgorithmTaskGenerator> *dict;

@implementation BEAlgorithmTaskFactory

+ (void)initialize
{
    if (self == [BEAlgorithmTaskFactory class]) {
        dict = [NSMutableDictionary dictionary];
    }
    
    REGISTER_ALGORITHM_TASK(BEFaceAlgorithmTask, FACE_106)
    REGISTER_ALGORITHM_TASK(BEHandAlgorithmTask, HAND)
    REGISTER_ALGORITHM_TASK(BESkeletonAlgorithmTask, SKELETON)
    REGISTER_ALGORITHM_TASK(BEPetFaceAlgorithmTask, PET_FACE)
    REGISTER_ALGORITHM_TASK(BEHeadSegmentAlgorithmTask, HEAD_SEGMENT)
    REGISTER_ALGORITHM_TASK(BEPortraitMattingAlgorithmTask, PORTRAIT_MATTING)
    REGISTER_ALGORITHM_TASK(BEHairParserAlgorithmTask, HAIR_PARSER)
    REGISTER_ALGORITHM_TASK(BESkySegAlgorithmTask, SKY_SEG)
    REGISTER_ALGORITHM_TASK(BELightClsAlgorithmTask, LIGHT_CLS)
    REGISTER_ALGORITHM_TASK(BEHumanDistanceAlgorithmTask, HUMAN_DISTANCE)
    REGISTER_ALGORITHM_TASK(BEConcentrationTask, CONCENTRATION)
    REGISTER_ALGORITHM_TASK(BEGazeEstimationTask, GAZE_ESTIMATION)
    REGISTER_ALGORITHM_TASK(BEC1AlgorithmTask, C1)
    REGISTER_ALGORITHM_TASK(BEC2AlgorithmTask, C2)
    REGISTER_ALGORITHM_TASK(BEVideoClsAlgorithmTask, VIDEO_CLS)
    REGISTER_ALGORITHM_TASK(BECarDetectTask, CAR)
    REGISTER_ALGORITHM_TASK(BEFaceVerifyAlgorithmTask, FACE_VERIFY)
    REGISTER_ALGORITHM_TASK(BEFaceClusterAlgorithmTask, FACE_CLUSTER)
    REGISTER_ALGORITHM_TASK(BEAnimojiAlgorithmTask, ANIMOJI)
    REGISTER_ALGORITHM_TASK(BEActionRecognitionAlgorithmTask, ACTION_RECOGNITION)
    REGISTER_ALGORITHM_TASK(BEDynamicGestureAlgorithmTask, DYNAMIC_GESTURE)
    REGISTER_ALGORITHM_TASK(BESkinSegmentationAlgorithmTask, SKIN_SEGMENTATION)
    REGISTER_ALGORITHM_TASK(BEBachSkeletonAlgorithmTask, BACH_SKELETON)
    REGISTER_ALGORITHM_TASK(BEChromaKeyingAlgorithmTask, CHROMA_KEYING)
}

+ (BEAlgorithmTask *)create:(BEAlgorithmKey *)key provider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>) licenseProvider {
    if ([dict.allKeys containsObject:key]) {
        return dict[key](provider, licenseProvider);
    }
    return nil;
}

+ (void)register:(BEAlgorithmKey *)key generator:(BEAlgorithmTaskGenerator)generator {
    dict[key] = generator;
}

@end
