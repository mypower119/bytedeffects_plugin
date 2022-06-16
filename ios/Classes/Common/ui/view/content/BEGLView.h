// Copyright (C) 2018 Beijing Bytedance Network Technology Co., Ltd.
#import <GLKit/GLKit.h>

@interface BEGLView : GLKView

@property (nonatomic, assign) CGFloat x_scale;
@property (nonatomic, assign) CGFloat y_scale;

- (void)resetWidthAndHeight;
- (void)renderWithTexture:(unsigned int)name
                     size:(CGSize)size
      applyingOrientation:(int)orientation
                  fitType:(int)fitType;
- (void)releaseContext;
@end
