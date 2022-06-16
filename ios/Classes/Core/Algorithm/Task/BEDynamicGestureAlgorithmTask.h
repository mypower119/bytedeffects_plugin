//
//  BEDynamicGestureAlgorithmTask.h
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_dynamic_gesture.h"

@protocol BEDynamicGestureResourceProvider <BEAlgorithmResourceProvider>
- (const char *)dynamicGestureModelPath;
@end

@interface BEDynamicGestureAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_dynamic_gesture_info *gestureInfo;
@property (nonatomic, assign) int gestureNum;

@end

@interface BEDynamicGestureAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)DYNAMIC_GESTURE;

@end
