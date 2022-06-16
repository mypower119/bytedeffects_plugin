//
//  BEDynamicGestureAlgorithmTask.h
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_chroma_keying.h"

@protocol BEChromaKeyingResourceProvider <BEAlgorithmResourceProvider>
- (const char *)chromaKeyingModelPath;
@end

@interface BEChromaKeyingAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_chroma_keying_ret *chromaKeyingInfo;

@end

@interface BEChromaKeyingAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)CHROMA_KEYING;

@end
