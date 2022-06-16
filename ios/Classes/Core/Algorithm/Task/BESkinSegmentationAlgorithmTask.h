//
//  BEDynamicGestureAlgorithmTask.h
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_skin_segmentation.h"

@protocol BESkinSegmentationResourceProvider <BEAlgorithmResourceProvider>
- (const char *)skinSegmentationModelPath;
@end

@interface BESkinSegmentationAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_skin_segmentation_ret *skinSegInfo;

@end

@interface BESkinSegmentationAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)SKIN_SEGMENTATION;

@end
