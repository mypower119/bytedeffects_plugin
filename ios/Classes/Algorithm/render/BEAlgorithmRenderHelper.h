// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreVideo/CoreVideo.h>
#import "bef_effect_ai_public_define.h"

typedef struct be_rgba_color {
    float red;
    float green;
    float blue;
    float alpha;
}be_rgba_color;

typedef struct be_render_helper_line {
    float x1;
    float y1;
    float x2;
    float y2;
} be_render_helper_line;

@interface BEGLProgram : NSObject

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment;
- (void)destroy;

@end

@interface BEPointProgram : BEGLProgram

- (void)drawPoint:(float)x y:(float)y color:(be_rgba_color)color size:(float)size;
- (void)drawPoints:(bef_ai_fpoint *)points withCount:(int)count withColor:(be_rgba_color)color withSize:(float)size;

@end

@interface BELineProgram : BEGLProgram

- (void)drawLine:(be_render_helper_line)line withColor:(be_rgba_color)color withWidth:(float)width;
- (void)drawLines:(bef_ai_fpoint *)line withCount:(int)count withColor:(be_rgba_color)color withWidth:(float)width;
- (void)drawLineStrip:(bef_ai_fpoint *)lines withCount:(int)count withColor:(be_rgba_color)color withWidth:(float)width;
- (void)drawRect:(bef_ai_rectf *)rect withColor:(be_rgba_color)color withWidth:(float)width;

@end

@interface BEMaskProgram : BEGLProgram

@end

@interface BEColorMaskProgram : BEMaskProgram

- (void)drawMask:(unsigned char *)mask withColor:(be_rgba_color)color withSize:(int *)size;

@end

@interface BETextureMaskProgram : BEMaskProgram

- (void)drawMask:(unsigned char *)mask withTexture:(GLuint)texture withSize:(int *)size;

@end

@interface BEAffineColorMaskProgram : BEColorMaskProgram

- (void)drawMask:(unsigned char *)mask withColor:(be_rgba_color)color withSize:(int *)size withAffine:(float *)affine withViportWidth:(int)width height:(int)height;

@end

@interface BEDrawFaceMaskProgram : BEGLProgram
- (void)drawSegment:(unsigned char*)mask affine:(float*)affine withColor:(be_rgba_color)color currentTexture:(GLuint)texture  size:(int*)size withViportWidth:(int)width height:(int)height;
@end

@interface BEDrawCircularsProgram : BEGLProgram
- (void)drawCircular:(float*)points withColor:(be_rgba_color)color;
@end

@interface BEDrawDashLineProgram : BEGLProgram
- (void)drawDashLine:(be_render_helper_line)line withColor:(be_rgba_color)color withWidth:(float)width;
@end

@interface BEAlgorithmRenderHelper : NSObject

- (void)setViewWidth:(int)iWidth height:(int)iHeight;
- (void)setResizeRatio:(float)ratio;

- (void)drawRect:(bef_ai_rect*)rect withColor:(be_rgba_color)color lineWidth:(float)lineWidth;
- (void)drawLines:(bef_ai_fpoint*) lines withCount:(int)count withColor:(be_rgba_color)color lineWidth:(float)lineWidth;
- (void)drawLinesStrip:(bef_ai_fpoint*) lines withCount:(int)count withColor:(be_rgba_color)color lineWidth:(float)lineWidth;
- (void)drawLine:(be_render_helper_line*)line withColor:(be_rgba_color)color lineWidth:(float)lineWidth;

- (void)drawPoint:(int)x y:(int)y withColor:(be_rgba_color)color pointSize:(float)pointSize;
- (void)drawPoints:(bef_ai_fpoint*)points count:(int)count color:(be_rgba_color)color pointSize:(float)pointSize;

- (void)drawMask:(unsigned char*)mask withColor:(be_rgba_color)color currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int*)size;
- (void)drawMask:(unsigned char *)mask withTexture:(GLuint)texture currentTexture:(GLuint)currentTexture frameBuffer:(GLuint)frameBuffer size:(int *)size;
- (void)drawMask:(unsigned char*)mask affine:(float*)affine withColor:(be_rgba_color)color currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int*)size;
- (void)drawPortraitMask:(unsigned char *)mask withBackground:(GLuint)backgroundTexture currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int *)size;


- (void)drawTexture:(GLuint)texture;
- (void)drawSegment:(unsigned char*)mask affine:(float*)affine withColor:(be_rgba_color)color currentTexture:(GLuint)texture  size:(int*)size;
- (void)drawCircular:(int)x y:(int)y withColor:(be_rgba_color)color radius:(float)radius;
- (void)drawDashLine:(be_render_helper_line*)line withColor:(be_rgba_color)color lineWidth:(float)lineWidth;
@end

