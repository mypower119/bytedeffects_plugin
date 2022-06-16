//
//  BEAlgorithmResourceHelper.h
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#ifndef BEAlgorithmResourceHelper_h
#define BEAlgorithmResourceHelper_h

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

@interface BEAlgorithmResourceHelper : NSObject <BEFaceResourceProvider, BEHandResourceProvider, BESkeletonResourceProvider, BEPetFaceResourceProvider, BEHeadSegmentResourceProvider, BEPortraitMattingResourceProvider, BEHairParserResourceProvider, BESkyResourceProvider, BELightClsResourceProvider, BEHumanDistanceResourceProvider, BEConcentrationResourceProvider, BEGazeEstimationResourceProvider, BEC1ResourceProvider, BEC2ResourceProvider, BEVideoClsResourceProvider, BECarResourceProvider, BEFaceVerifyResourceProvider, BEFaceClusterResourceProvider, BEAnimojiResourceProvider,BEActionRecognitionResourceProvider,BEDynamicGestureResourceProvider,BESkinSegmentationResourceProvider,BEBachSkeletonResourceProvider,BEChromaKeyingResourceProvider>

@end

#endif /* BEAlgorithmResourceHelper_h */
