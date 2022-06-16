//
//  BEAdaptiveSharpenTask.h
//  BytedEffects
//
//  Created by Bytedance on 2020/12/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEAdaptiveSharpenTask_h
#define BEAdaptiveSharpenTask_h

#import "BEAlgorithmTask.h"

@protocol BEAdaptiveSharpenResourceProvider <NSObject>

- (NSString *)licensePath;

@end

@interface BEAdaptiveSharpenTask:NSObject

@property (nonatomic, strong) id<BELicenseProvider> provider;

-(int) initTask;
-(CVPixelBufferRef)processCVPixelBuffer:(CVPixelBufferRef)srcBuffer;
-(int)destroyTask;
@end

#endif /* BeLensVideoSR_h */
