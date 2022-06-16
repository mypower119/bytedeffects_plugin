//
//  BEImageOpeartion.h
//  BytedEffects
//
//  Created by Bytedance on 2020/11/26.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEImageOpeartion_h
#define BEImageOpeartion_h

#import <Foundation/Foundation.h>
#import <CoreVideo/CVPixelBuffer.h>

@protocol BEImageOperationBufferProtocol <NSObject>

@optional

-(CVPixelBufferRef _Nullable )transforPixelbuffer:(nonnull CVPixelBufferRef)srcPixelBuffer destFormat:(OSType)type;

-(CVPixelBufferRef _Nullable )rotatePixelBuffer:(nonnull CVPixelBufferRef)srcPixelBuffer angle:(float)angle;

@end

@protocol BEImageOpeartionTextureProtocal <NSObject>

@optional
-(int)transforTexture:(int)srcTexture srcFormat:(OSType)srcType destTexture:(int)destTexture destFormat:(OSType)destType;

@end

//@interface BEImageTextureOperation: NSObject <BEImageOpeartionTextureProtocal>
//+(instancetype) sharedInstance;
//@end

@interface BEImageBufferOperation: NSObject <BEImageOperationBufferProtocol>

+ (instancetype) sharedInstance;

@end

#endif /* BEImageOpeartion_h */
