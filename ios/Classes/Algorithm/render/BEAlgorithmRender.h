//
//  BEAlgorithmRender.h
//  Algorithm
//
//  Created by qun on 2021/5/31.
//

#ifndef BEAlgorithmRender_h
#define BEAlgorithmRender_h

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>

//   {zh} / 算法结果绘制类，用于将算法结果绘制到目标纹理上     {en} /Algorithm result rendering class for drawing algorithm results to target textures 
@interface BEAlgorithmRender : NSObject

- (void)setRenderTargetTexture:(GLuint)texture width:(int)width height:(int)height resizeRatio:(float)ratio;
- (void)drawAlgorithmResult:(id)result;
- (void)destroy;

@end

#endif /* BEAlgorithmRender_h */
