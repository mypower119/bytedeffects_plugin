//
//  BEPortraitMattingAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"

@protocol BEPortraitMattingResourceProvider <BEAlgorithmResourceProvider>
- (const char *)portraitMattingModelPath;
@end

@interface BEPortraitMattingAlgorithmResult : NSObject

@property (nonatomic, assign) unsigned char *mask;
@property (nonatomic, assign) int *size;

@end

@interface BEPortraitMattingAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)PORTRAIT_MATTING;

@end
