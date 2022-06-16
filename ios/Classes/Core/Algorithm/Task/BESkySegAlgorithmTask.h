//
//  BESkySegAlgorithmTask.h
//  BytedEffects
//
//  Created by qun on 2020/10/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BESkySegAlgorithmTask_h
#define BESkySegAlgorithmTask_h

#import "BEAlgorithmTask.h"

@protocol BESkyResourceProvider <BEAlgorithmResourceProvider>

- (const char *)skySegModelPath;

@end

@interface BESkySegAlgorithmResult : NSObject

@property (nonatomic, assign) unsigned char *mask;
@property (nonatomic, assign) int *size;
@property (nonatomic, assign) BOOL hasSky;

@end

@interface BESkySegAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)SKY_SEG;

@end

#endif /* BESkySegAlgorithmTask_h */
