//
//  BEImageCapture.h
//  Common
//
//  Created by qun on 2021/5/17.
//

#ifndef BEImageCapture_h
#define BEImageCapture_h

#import "BEVideoSourceProvider.h"

@interface BEImageCapture : NSObject <BEVideoSourceProtocol>

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithProfilerImagePaths:(NSArray<NSString*> *)paths presentTime:(unsigned int)time;
- (void)resetImage:(UIImage *)image;

@end


#endif /* BEImageCapture_h */
