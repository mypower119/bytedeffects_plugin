//
//  BeLensVideoSR.h
//  BytedEffects
//
//  Created by Bytedance on 2020/12/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEVideoSRTask_h
#define BEVideoSRTask_h

#import <CoreVideo/CoreVideo.h>
#import "BEAlgorithmTask.h"

@protocol BEVideoSRResourceProvider <NSObject>

- (NSString *)licensePath;
- (NSString *)videoSRModelPath;

@end

@interface BEVideoSRTask:NSObject

@property (nonatomic, strong) id<BELicenseProvider> provider;

-(int) initTask;
-(CVPixelBufferRef)processCVPixelBuffer:(CVPixelBufferRef)srcBuffer;
-(int)destroyTask;
@end

#endif /* BeLensVideoSR_h */
