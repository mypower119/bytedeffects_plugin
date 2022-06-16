// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#import "BEAlgorithmRenderHelper.h"

#import "bef_effect_ai_api.h"
#import <GLKit/GLKit.h>

#define TTF_STRINGIZE(x) #x
#define TTF_STRINGIZE2(x) TTF_STRINGIZE(x)
#define TTF_SHADER_STRING(text) @ TTF_STRINGIZE2(text)

static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING
(
attribute vec4 position;
attribute vec4 inputTextureCoordinate;
varying vec2 textureCoordinate;
void main(){
    textureCoordinate = inputTextureCoordinate.xy;
    gl_Position = position;
}
);

static NSString *const CAMREA_RESIZE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 void main()
 {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
 }
);

static NSString *const LINE_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 position;
 void main() {
     gl_Position = position;
 }
 );

static NSString *const LINE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 uniform vec4 color;
 void main() {
     gl_FragColor = color;
 }
 );

static NSString *const POINT_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 position;
 uniform float uPointSize;
 void main() {
     gl_Position = position;
     gl_PointSize = uPointSize;
 }
 );

static NSString *const POINT_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 uniform vec4 color;
 void main() {
     gl_FragColor = color;
 }
 );

static NSString *const MASK_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 void main(){
     textureCoordinate = vec2(inputTextureCoordinate.x, 1.0 - inputTextureCoordinate.y);
     gl_Position = position;
 }
 );

static NSString *const MASK_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputMaskTexture;
 uniform vec4 maskColor;
 void main(){
     float maska = texture2D(inputMaskTexture, textureCoordinate).a;
     gl_FragColor = vec4(maskColor.rgb, maska * maskColor.a);
 }
 );

static NSString *const MASK_WITH_TEXTURE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputMaskTexture;
 uniform sampler2D forgroundTexture;
 void main(){
     float maska = texture2D(inputMaskTexture, textureCoordinate).a;
    vec4 maskColor = texture2D(forgroundTexture, textureCoordinate);
     gl_FragColor = vec4(maskColor.rgb, maska * maskColor.a);
 }
 );

static NSString *const MASK_WITH_BG_TEXTURE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputMaskTexture;
 uniform sampler2D forgroundTexture;
 void main(){
     float maska = texture2D(inputMaskTexture, textureCoordinate).a;
    vec4 maskColor = texture2D(forgroundTexture, textureCoordinate);
     gl_FragColor = vec4(maskColor.rgb, (1.0 - maska) * maskColor.a);
 }
 );

static NSString *const MASK_AFFINE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputTexture;
 uniform sampler2D inputMaskTexture;
 uniform mat3 affine;
 uniform float viewport_width;
 uniform float viewport_height;
 uniform float mask_width;
 uniform float mask_height;
 uniform vec4 maskColor;
 
 void main(){
     vec4 color = texture2D(inputTexture, textureCoordinate);
    vec2 image_coord = vec2(textureCoordinate.x * viewport_width, textureCoordinate.y * viewport_height);
    vec3 affine_coord = affine * vec3(image_coord, 1.0);
    vec2 tex_coord = vec2(affine_coord.x / mask_width, affine_coord.y / mask_height);
//    if (distance(tex_coord, vec2(0.5, 0.5)) > 0.5) {gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0); return;}
    if (tex_coord.x > 1.0 || tex_coord.x < 0.0 || tex_coord.y > 1.0 || tex_coord.y < 0.0) {gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0); return;}
    //float maska = 1.0 - texture2D(inputMaskTexture, tex_coord).a;
    float maska = texture2D(inputMaskTexture, tex_coord).a;
    gl_FragColor = vec4(maskColor.rgb, maska*maskColor.a);
 }
 );

static NSString *const MASK_PORTRAIT_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputTexture;
 uniform sampler2D backgroundTexture;
 uniform sampler2D inputMaskTexture;
 void main(){
    vec4 color = texture2D(inputTexture, textureCoordinate);
    vec4 backgroundColor = texture2D(backgroundTexture, textureCoordinate);
    float maska =  1.0 - texture2D(inputMaskTexture, textureCoordinate).a;
    gl_FragColor = vec4( mix(color.rgb, backgroundColor.rgb, maska) , 1.0);
 }
 );

static NSString *const DRAW_FACE_MASK_VERTEX = TTF_SHADER_STRING
(
attribute vec4 position;
attribute vec4 inputTextureCoordinate;
varying vec2 textureCoordinate;
varying vec2 maskCoordinate;
uniform mat4 warpMat;
void main(){
    textureCoordinate = inputTextureCoordinate.xy;
    gl_Position =  position;
    maskCoordinate = (warpMat * vec4(inputTextureCoordinate.xy, 0.0, 1.0)).xy;
}
);

static NSString *const DRAW_FACE_MASK_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying highp vec2 textureCoordinate;
 varying highp vec2 maskCoordinate;
 uniform sampler2D inputMask;
 uniform vec3 maskColor;
 void main()
 {
    vec4 color =  vec4(0.0, 0.0, 0.0, 0.0);
    
    if(clamp(maskCoordinate, 0.0, 1.0) != maskCoordinate)
    {
        gl_FragColor = color;
    }
    else
    {
        float mask = texture2D(inputMask, maskCoordinate).a;
    
        gl_FragColor = vec4(maskColor, mask*0.45);
    }
    
 }
);

static NSString *const DRAW_SPORT_ASSISTANT_VERTEXT = TTF_SHADER_STRING
(
 precision mediump float;
 attribute vec4 a_Position;
 attribute vec2 a_TextureCoordinates;
 varying vec2 v_TextureCoordinates;

 void main()
 {
     v_TextureCoordinates = a_TextureCoordinates;
     gl_Position = a_Position;
 }
);

static NSString *const DRAW_SPORT_ASSISTANT_FRAGMENT = TTF_SHADER_STRING
(
 precision highp float;
 varying highp vec2 v_TextureCoordinates;
 uniform sampler2D inputImageTexture;
 uniform vec4 color;

 void main()
 {
    vec2 tex;
    tex.x = v_TextureCoordinates.x;
    tex.y = 1.0 - v_TextureCoordinates.y;
    
    vec4 brush = texture2D(inputImageTexture, tex);
    brush = brush * color;
    gl_FragColor = brush;
 }
);

static NSString *const DRAW_DASH_LINE_VERTEXT = TTF_SHADER_STRING
(
 precision mediump float;
 attribute vec4 a_Position;
 attribute float inU;
 varying   float outU;

 void main()
 {
     outU        = inU;
     gl_Position = vec4( a_Position.xy, 0.0, 1.0 );
 }
);

static NSString *const DRAW_DASH_LINE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying float     outU;
 uniform sampler2D u_stippleTexture;
 uniform vec4 color;

 void main()
 {
     float stipple = texture2D(u_stippleTexture, vec2(outU, 0.0)).a;
     if (stipple < 0.5)
         discard;
     gl_FragColor = color;
 }
 
);

typedef void(^OnBindData)(void);

static float TEXTURE_FLIPPED[] = {0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f,};
static float TEXTURE_RORATION_0[] = {0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f,};
static float TEXTURE_ROTATED_90[] = {0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f,};
static float TEXTURE_ROTATED_180[] = {1.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f,};
static float TEXTURE_ROTATED_270[] = {1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f,};
static float CUBE[] = {-1.0f, -1.0f, 1.0f, -1.0f, -1.0f, 1.0f, 1.0f, 1.0f,};

@interface BEGLProgram () {
    @protected
    GLuint          _program;
    GLuint          _position;
    GLuint          _color;
}

@end

@implementation BEGLProgram

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super init]) {
        GLuint vertexShader = [self compileShader:vertex withType:GL_VERTEX_SHADER];
        GLuint fragmentShader = [self compileShader:fragment withType:GL_FRAGMENT_SHADER];
        
        _program = glCreateProgram();
        glAttachShader(_program, vertexShader);
        glAttachShader(_program, fragmentShader);
        glLinkProgram(_program);
        
        GLint linkSuccess;
        glGetProgramiv(_program, GL_LINK_STATUS, &linkSuccess);
        if (linkSuccess == GL_FALSE){
            NSLog(@"BERenderHelper link shader error");
        }
        
        if (vertexShader) {
            glDeleteShader(vertexShader);
        }
        
        if (fragmentShader) {
            glDeleteShader(fragmentShader);
        }
        
        glUseProgram(_program);
        _position = glGetAttribLocation(_program, "position");
        _color = glGetUniformLocation(_program, "color");
    }
    return self;
}

- (void)destroy {
    glDeleteProgram(_program);
}

- (GLuint)compileShader:(NSString *)shaderString withType:(GLenum)shaderType {
    GLuint shaderHandle = glCreateShader(shaderType);
    const char * shaderStringUTF8 = [shaderString UTF8String];
    
    int shaderStringLength = (int) [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    GLint success;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &success);
    
    if (success == GL_FALSE){
        NSLog(@"BErenderHelper compiler shader error: %s", shaderStringUTF8);
        return 0;
    }
    return shaderHandle;
}

@end

@interface BEPointProgram () {
    GLuint          _size;
}

@end

@implementation BEPointProgram

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        _size = glGetUniformLocation(_program, "uPointSize");
    }
    return self;
}

- (void)drawPoint:(float)x y:(float)y color:(be_rgba_color)color size:(float)size {
    GLfloat positions[] = {
        x, y
    };
    
    glUseProgram(_program);
    glVertexAttribPointer(_position, 2, GL_FLOAT, false, 0, positions);
    glEnableVertexAttribArray(_position);
    
    glUniform4f(_color, color.red, color.green, color.blue, color.alpha);
    glUniform1f(_size, size);
    glDrawArrays(GL_POINTS, 0, 1);
    glDisableVertexAttribArray(_position);
}

- (void)drawPoints:(bef_ai_fpoint *)points withCount:(int)count withColor:(be_rgba_color)color withSize:(float)size {
    GLfloat positions[count * 2];
    for (int i = 0; i < count; i++) {
        positions[i * 2] = points[i].x;
        positions[i * 2 + 1] = points[i].y;
    }
    
    glUseProgram(_program);
    glVertexAttribPointer(_position, 2, GL_FLOAT, false, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_position);
    
    glUniform4f(_color, color.red, color.green, color.blue, color.alpha);
    glUniform1f(_size, size);
    glDrawArrays(GL_POINTS, 0, count);
    glDisableVertexAttribArray(_position);
}

@end

@interface BELineProgram () {
    
}

@end

@implementation BELineProgram

- (void)drawLine:(be_render_helper_line)line withColor:(be_rgba_color)color withWidth:(float)width {
    GLfloat positions[] = {
        line.x1, line.y1, line.x2, line.y2
    };
    
    [self be_draw:positions withCount:2 withColor:color withWidth:width withMode:GL_LINES];
}

- (void)drawLines:(bef_ai_fpoint *)lines withCount:(int)count withColor:(be_rgba_color)color withWidth:(float)width {
    if (count < 0) return;
    
    GLfloat positions[2 * count];
    for (int i = 0; i < count; i++) {
        positions[2 * i] = lines[i].x;
        positions[2 * i + 1] = lines[i].y;
    }
    
    [self be_draw:positions withCount:count withColor:color withWidth:width withMode:GL_LINES];
}

- (void)drawLineStrip:(bef_ai_fpoint *)lines withCount:(int)count withColor:(be_rgba_color)color withWidth:(float)width {
    if (count < 0) return;
    
    GLfloat positions[2 * count];
    for (int i = 0; i < count; i++) {
        positions[2 * i] = lines[i].x;
        positions[2 * i + 1] = lines[i].y;
    }
    
    [self be_draw:positions withCount:count withColor:color withWidth:width withMode:GL_LINE_STRIP];
}

- (void)drawRect:(bef_ai_rectf *)rect withColor:(be_rgba_color)color withWidth:(float)width {
    GLfloat positions[] = {
        rect->left, rect->top,
        rect->left, rect->bottom,
        rect->right, rect->bottom,
        rect->right, rect->top,
        rect->left, rect->top
    };
    
    [self be_draw:positions withCount:5 withColor:color withWidth:width withMode:GL_LINE_STRIP];
}

- (void)be_draw:(GLfloat *)positions withCount:(int)count withColor:(be_rgba_color)color withWidth:(float)width withMode:(GLenum)mode {
    glUseProgram(_program);
    glVertexAttribPointer(_position, 2, GL_FLOAT, false, 2 * sizeof(GLfloat), positions);
    glEnableVertexAttribArray(_position);
    
    glUniform4f(_color, color.red, color.green, color.blue, color.alpha);
    glLineWidth(width);
    glDrawArrays(mode, 0, count);
    glDisableVertexAttribArray(_position);
}

@end

@interface BEMaskProgram () {
    @protected
    GLuint              _maskTexture;
    GLuint              _maskCoordinateLocation;
    
    GLuint              _cacheTexture;
}

@end

@implementation BEMaskProgram

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        
        _maskTexture = glGetUniformLocation(_program, "inputMaskTexture");
        _maskCoordinateLocation = glGetAttribLocation(_program, "inputTextureCoordinate");
        
        _cacheTexture = 0;
    }
    return self;
}

- (void)be_draw:(unsigned char *)mask withSize:(int *)size withBindData:(OnBindData)bindData {
    glUseProgram(_program);
    glVertexAttribPointer(_position, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_position);
    glVertexAttribPointer(_maskCoordinateLocation, 2, GL_FLOAT, false, 0, TEXTURE_FLIPPED);
    glEnableVertexAttribArray(_maskCoordinateLocation);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    if (_cacheTexture == 0) {
        glGenTextures(1, &_cacheTexture);
        glBindTexture(GL_TEXTURE_2D, _cacheTexture);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    } else {
        glBindTexture(GL_TEXTURE_2D, _cacheTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _cacheTexture);
    glUniform1i(_maskTexture, 0);
    
    bindData();
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisable(GL_BLEND);
    
    glDisableVertexAttribArray(_maskCoordinateLocation);
    glDisableVertexAttribArray(_position);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, 0);
    glUseProgram(0);
}

- (void)destroy {
    [super destroy];
    glDeleteTextures(1, &_cacheTexture);
}

@end

@interface BEColorMaskProgram () {
    @protected
    GLuint              _maskColor;
}

@end

@implementation BEColorMaskProgram

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        
        _maskColor = glGetUniformLocation(_program, "maskColor");
    }
    return self;
}

- (void)drawMask:(unsigned char *)mask withColor:(be_rgba_color)color withSize:(int *)size {
    [self be_draw:mask withSize:size withBindData:^() {
        glUniform4f(self->_maskColor, color.red, color.green, color.blue, color.alpha);
    }];
}

@end

@interface BETextureMaskProgram () {
    @protected
    GLuint              _maskTexture;
}

@end

@implementation BETextureMaskProgram

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        
        _maskTexture = glGetUniformLocation(_program, "forgroundTexture");
    }
    return self;
}

- (void)drawMask:(unsigned char *)mask withTexture:(GLuint)texture withSize:(int *)size {
    [self be_draw:mask withSize:size withBindData:^{
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, texture);
        glUniform1i(self->_maskTexture, 1);
    }];
}

@end

@interface BEAffineColorMaskProgram () {
    @protected
    GLuint              _maskWidth;
    GLuint              _maskHeight;
    GLuint              _viewportWidth;
    GLuint              _viewportHeight;
    GLuint              _affine;
}

@end

@implementation BEAffineColorMaskProgram

- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        
        _affine = glGetUniformLocation(_program, "affine");
        _maskWidth = glGetUniformLocation(_program, "mask_width");
        _maskHeight = glGetUniformLocation(_program, "mask_height");
        _viewportWidth = glGetUniformLocation(_program, "viewport_width");
        _viewportHeight = glGetUniformLocation(_program, "viewport_height");
    }
    return self;
}

- (void)drawMask:(unsigned char *)mask withColor:(be_rgba_color)color withSize:(int *)size withAffine:(float *)affine withViportWidth:(int)width height:(int)height {
    [self be_draw:mask withSize:size withBindData:^{
        float m[9] = {
            affine[0], (float) affine[3], 0.0f,
           affine[1], (float) affine[4], 0.0f,
            affine[2], affine[5] , 0.0f
        };
        
        glUniformMatrix3fv(self->_affine, 1, GL_FALSE, m);
        glUniform4f(self->_maskColor, color.red, color.green, color.blue, color.alpha);
        glUniform1f(self->_maskWidth, size[0]);
        glUniform1f(self->_maskHeight, size[1]);
        glUniform1f(self->_viewportWidth, width);
        glUniform1f(self->_viewportHeight, height);
    }];
}

@end
    
@interface BEDrawFaceMaskProgram () {
    @protected
    //face mask
//    GLuint _faceMaskInputImageTexture;
    GLuint _faceMaskTextureCoordinate;
    GLuint _faceMaskSeg;
    GLuint _faceMaskWrapMat;
    GLuint _faceMaskColor;
    GLuint _faceMaskTexture;
}

@end
    

@implementation BEDrawFaceMaskProgram
    
- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        
        _faceMaskTextureCoordinate = glGetAttribLocation(_program, "inputTextureCoordinate");
        _faceMaskSeg = glGetUniformLocation(_program, "inputMask");
        _faceMaskWrapMat = glGetUniformLocation(_program, "warpMat");
        _faceMaskColor = glGetUniformLocation(_program, "maskColor");
    
    }
    return self;
}
    
/*
* draw face segment
*/

- (void)drawSegment:(unsigned char*)mask affine:(float*)affine withColor:(be_rgba_color)color currentTexture:(GLuint)texture  size:(int*)size withViportWidth:(int)width height:(int)height
{
    float maskWidth = size[0] * 1.0f;
    float maskHeight = size[1] * 1.0f;

    glUseProgram(_program);
    glVertexAttribPointer(_position, 2, GL_FLOAT, false, 0, CUBE);
    glEnableVertexAttribArray(_position);

    glVertexAttribPointer(_faceMaskTextureCoordinate, 2, GL_FLOAT, false, 0, TEXTURE_RORATION_0);
    glEnableVertexAttribArray(_faceMaskTextureCoordinate);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    float scaleX = width / maskWidth;
    float scaleY = height / maskHeight;
    if (_faceMaskWrapMat >= 0) {
         float m[16] = {
             affine[0]*scaleX, affine[3]*scaleX, 0.0f, 0.0f,
             affine[1]*scaleY, affine[4]*scaleY, 0.0f, 0.0f,
             0.0f, 0.0f, 1.0f, 0.0f,
             affine[2]/ maskWidth,  affine[5]/ maskHeight, 0.0f, 1.0f
         };
         glUniformMatrix4fv(_faceMaskWrapMat, 1, GL_FALSE, m);
     }

    glUniform3f(_faceMaskColor, color.red, color.green, color.blue);

//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, texture);
//    glUniform1i(_faceMaskInputImageTexture, 0);

    glActiveTexture(GL_TEXTURE0);
    if (!_faceMaskTexture){
        glGenTextures(1, &_faceMaskTexture);
        glBindTexture(GL_TEXTURE_2D, _faceMaskTexture);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }else{
        glBindTexture(GL_TEXTURE_2D, _faceMaskTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size[0], size[1], 0, GL_ALPHA, GL_UNSIGNED_BYTE, mask);
    }
    glUniform1i(_faceMaskSeg, 0);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisable(GL_BLEND);
    glDisableVertexAttribArray(_position);
    glDisableVertexAttribArray(_faceMaskTextureCoordinate);

    glBindTexture(GL_TEXTURE_2D, 0);

}

- (void)destroy {
    [super destroy];
    if(_faceMaskTexture)
    {
        glDeleteTextures(1, &_faceMaskTexture);
    }

}
@end

@interface BEDrawCircularsProgram () {
    @protected
    GLuint _brushTex;
    GLuint a_Position;
    GLuint a_TextureCoordinates;
    GLuint inputImageTexture;
    GLuint _color;
}

@end
    

@implementation BEDrawCircularsProgram
    
- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        a_Position = glGetAttribLocation(_program, "a_Position");
        a_TextureCoordinates = glGetAttribLocation(_program, "a_TextureCoordinates");
        _color = glGetUniformLocation(_program, "color");
        inputImageTexture = glGetUniformLocation(_program, "inputImageTexture");
    }
    return self;
}

-(void)generateCircularTexture
{
    UIGraphicsBeginImageContext(CGSizeMake(128, 128));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = CGRectMake(4, 4, 120, 120);
    CGContextAddEllipseInRect(context, frame);
    [[UIColor whiteColor] set];
    CGContextFillPath(context);
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef spriteImage = [reSizeImage CGImage];
    if (!spriteImage) {
        @throw [NSException exceptionWithName:@"generete fitness texture failed" reason:@"" userInfo:nil];
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    glGenTextures(1, &_brushTex);
    glBindTexture(GL_TEXTURE_2D, _brushTex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
}

- (void)drawCircular:(float*)points withColor:(be_rgba_color)color
{
    glUseProgram(_program);
    glVertexAttribPointer(a_Position, 2, GL_FLOAT, false, 0, points);
    glEnableVertexAttribArray(a_Position);
    
    glVertexAttribPointer(a_TextureCoordinates, 2, GL_FLOAT, false, 0, TEXTURE_RORATION_0);
    glEnableVertexAttribArray(a_TextureCoordinates);
    
    if(_brushTex == 0)
    {
        [self generateCircularTexture];
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _brushTex);
    glUniform1i(inputImageTexture, 0);
    
    glUniform4f(_color, color.red, color.green, color.blue, color.alpha);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisable(GL_BLEND);
    glDisableVertexAttribArray(a_Position);
    glDisableVertexAttribArray(a_TextureCoordinates);
}

- (void)dealloc
{
    if(_brushTex)
    {
        glDeleteTextures(1, &_brushTex);
    }
}
    
@end

@interface BEDrawDashLineProgram () {
    @protected
    GLuint a_Position;
    GLuint inU;
    GLuint u_stippleTexture;
    GLuint u_stippleTexturePos;
    GLuint _color;
    
}

@end
    

@implementation BEDrawDashLineProgram
    
- (instancetype)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    if (self = [super initWithVertex:vertex fragment:fragment]) {
        glUseProgram(_program);
        a_Position = glGetAttribLocation(_program, "a_Position");
        inU = glGetAttribLocation(_program, "inU");
        _color = glGetUniformLocation(_program, "color");
        u_stippleTexturePos = glGetUniformLocation(_program, "u_stippleTexture");
    }
    return self;
}

- (void)drawDashLine:(be_render_helper_line)line withColor:(be_rgba_color)color withWidth:(float)width
{
    GLfloat positions[] = {
        line.x1, line.y1, line.x2, line.y2
    };
    glUseProgram(_program);
    glVertexAttribPointer(a_Position, 2, GL_FLOAT, false, 0, positions);
    glEnableVertexAttribArray(a_Position);
    
    GLfloat texpos[] = {0.0,5.0};
    glVertexAttribPointer(inU, 1, GL_FLOAT, false, 0, texpos);
    glEnableVertexAttribArray(inU);
    
    if (!u_stippleTexture){
        
        unsigned char texBuf[] = { 255, 0, 0, 255 };
        
        glGenTextures(1, &u_stippleTexture);
        glBindTexture(GL_TEXTURE_2D, u_stippleTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, 4, 1, 0,GL_ALPHA, GL_UNSIGNED_BYTE, texBuf);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, u_stippleTexture);
    glUniform1i(u_stippleTexturePos, 0);
    
    glUniform4f(_color, color.red, color.green, color.blue, color.alpha);
    
    glLineWidth(width);
    glDrawArrays(GL_LINES, 0, 2);
    
    glDisableVertexAttribArray(a_Position);
    glDisableVertexAttribArray(inU);
}

- (void)dealloc
{
}
    
@end

    
@interface  BEAlgorithmRenderHelper (){
    BEPointProgram          *_pointProgram;
    BELineProgram           *_lineProgram;
    BEColorMaskProgram      *_colorMaskProgram;
    BETextureMaskProgram    *_textureMaskProgram;
    BETextureMaskProgram    *_bgTextureMaskProgram;
    BEAffineColorMaskProgram    *_affineColorMaskProgram;
    BEDrawFaceMaskProgram       *_faceMaskProgram;
    BEDrawCircularsProgram      *_drawCircularsProgram;
    BEDrawDashLineProgram       *_drawDashlineProgram;
    
    int viewWidth;
    int viewHeight;
    
    float _ratio;
}

@end

@implementation BEAlgorithmRenderHelper

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self loadPointShader];
        [self loadLineShader];
        [self loadMaskShader];
        
        viewWidth = 720;
        viewWidth = 1080;
        _ratio = 0.0;
    }
    
    return self;
}

-(void)dealloc{
    [_pointProgram destroy];
    [_lineProgram destroy];
    [_colorMaskProgram destroy];
    [_textureMaskProgram destroy];
    [_bgTextureMaskProgram destroy];
    [_affineColorMaskProgram destroy];
}

- (void)checkGLError {
    int error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"checkGLError %d", error);
        @throw [NSException exceptionWithName:@"GLError" reason:@"error " userInfo:nil];
    }
}

- (void)setViewWidth:(int)iWidth height:(int)iHeight{
    viewWidth = iWidth;
    viewHeight = iHeight;
}

- (void)setResizeRatio:(float)ratio{
    _ratio = ratio;
}

/*
 * load point shader
 */

- (void) loadPointShader {
    glViewport(0, 0, viewWidth, viewHeight);
    _pointProgram = [[BEPointProgram alloc] initWithVertex:POINT_VERTEX fragment:POINT_FRAGMENT];
    [self checkGLError];
}

/*
 * load line shader
 */

- (void) loadLineShader {
    glViewport(0, 0, viewWidth, viewHeight);
    _lineProgram = [[BELineProgram alloc] initWithVertex:LINE_VERTEX fragment:LINE_FRAGMENT];
    [self checkGLError];
}

- (void) loadMaskShader {
    glViewport(0, 0, viewWidth, viewHeight);
    _colorMaskProgram = [[BEColorMaskProgram alloc] initWithVertex:MASK_VERTEX fragment:MASK_FRAGMENT];
    _textureMaskProgram = [[BETextureMaskProgram alloc] initWithVertex:MASK_VERTEX fragment:MASK_WITH_TEXTURE_FRAGMENT];
    _bgTextureMaskProgram = [[BETextureMaskProgram alloc] initWithVertex:MASK_VERTEX fragment:MASK_WITH_BG_TEXTURE_FRAGMENT];
    _affineColorMaskProgram = [[BEAffineColorMaskProgram alloc] initWithVertex:MASK_VERTEX fragment:MASK_AFFINE_FRAGMENT];
    
    _faceMaskProgram = [[BEDrawFaceMaskProgram alloc] initWithVertex:DRAW_FACE_MASK_VERTEX fragment:DRAW_FACE_MASK_FRAGMENT];
    _drawCircularsProgram = [[BEDrawCircularsProgram alloc]initWithVertex:DRAW_SPORT_ASSISTANT_VERTEXT fragment:DRAW_SPORT_ASSISTANT_FRAGMENT];
    _drawDashlineProgram = [[BEDrawDashLineProgram alloc]initWithVertex:DRAW_DASH_LINE_VERTEXT fragment:DRAW_DASH_LINE_FRAGMENT];
    [self checkGLError];
}

- (float) _transFormX:(int)x{
    float retX = (float)2.0 * x / _ratio / viewWidth - 1.0;
    return retX;
}

- (float) _transFormY:(int)y{
    float retX = (float)2.0 * y / _ratio / viewHeight - 1.0;
    return retX;
}
/*
 * draw a single point
 */

- (void) drawPoint:(int)x y:(int)y withColor:(be_rgba_color)color pointSize:(float)pointSize
{
    glViewport(0, 0, viewWidth, viewHeight);
    [_pointProgram drawPoint:[self _transFormX:x] y:[self _transFormY:y] color:color size:pointSize];
    [self checkGLError];
}

/*
 * draw  points
 */

- (void) drawPoints:(bef_ai_fpoint*)points count:(int)count color:(be_rgba_color)color pointSize:(float)pointSize
{
    for (int i = 0; i < count; i++) {
        points[i].x = [self _transFormX:points[i].x];
        points[i].y = [self _transFormY:points[i].y];
    }
    
    glViewport(0, 0, viewWidth, viewHeight);
    [_pointProgram drawPoints:points withCount:count withColor:color withSize:pointSize];
    [self checkGLError];
}

/*
 * Draw a line with color
 */

- (void) drawLine:(be_render_helper_line*)line withColor:(be_rgba_color)color lineWidth:(float)lineWidth{
    line->x1 = [self _transFormX:line->x1];
    line->y1 = [self _transFormY:line->y1];
    line->x2 = [self _transFormX:line->x2];
    line->y2 = [self _transFormY:line->y2];
    
    glViewport(0, 0, viewWidth, viewHeight);
    [_lineProgram drawLine:*line withColor:color withWidth:lineWidth];
    [self checkGLError];
}

/*
 * Draw lines with count and color
 */

- (void) drawLines:(bef_ai_fpoint*) lines withCount:(int)count withColor:(be_rgba_color)color lineWidth:(float)lineWidth{
    for (int i = 0; i < count; i ++){
        lines[i].x = [self _transFormX:lines[i].x];
        lines[i].y = [self _transFormY:lines[i].y];
    }
    
    glViewport(0, 0, viewWidth, viewHeight);
    [_lineProgram drawLines:lines withCount:count withColor:color withWidth:lineWidth];
    [self checkGLError];
}

/*
 * Draw lines with count and color strip
 */
- (void) drawLinesStrip:(bef_ai_fpoint*) lines withCount:(int)count withColor:(be_rgba_color)color lineWidth:(float)lineWidth{
    bef_ai_fpoint line[count];
    for (int i = 0; i < count; i ++){
        line[i].x = [self _transFormX:lines[i].x];
        line[i].y = [self _transFormY:lines[i].y];
    }
    
    glViewport(0, 0, viewWidth, viewHeight);
    [_lineProgram drawLineStrip:line withCount:count withColor:color withWidth:lineWidth];
    [self checkGLError];
}
/*
 * Draw a rect with color
 */
- (void) drawRect:(bef_ai_rect*)rect withColor:(be_rgba_color)color lineWidth:(float)lineWidth
{
    bef_ai_rectf rectf;
    rectf.left = [self _transFormX:rect->left];
    rectf.top = [self _transFormY:rect->top];
    rectf.right = [self _transFormX:rect->right];
    rectf.bottom = [self _transFormY:rect->bottom];
    
    glViewport(0, 0, viewWidth, viewHeight);
    [_lineProgram drawRect:&rectf withColor:color withWidth:lineWidth];
    [self checkGLError];
}


/*
 * Draw mask with color
 */
- (void) drawMask:(unsigned char*)mask affine:(float*)affine withColor:(be_rgba_color)color currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int*)size {
    glViewport(0, 0, viewWidth, viewHeight);
    [_affineColorMaskProgram drawMask:mask withColor:color withSize:size withAffine:affine withViportWidth:viewWidth height:viewHeight];
    [self checkGLError];
}

- (void) drawMask:(unsigned char*)mask withColor:(be_rgba_color)color currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int*)size {
    glViewport(0, 0, viewWidth, viewHeight);
    [_colorMaskProgram drawMask:mask withColor:color withSize:size];
    [self checkGLError];
    
}

- (void)drawMask:(unsigned char *)mask withTexture:(GLuint)texture currentTexture:(GLuint)currentTexture frameBuffer:(GLuint)frameBuffer size:(int *)size {
    glViewport(0, 0, viewWidth, viewHeight);
    [_textureMaskProgram drawMask:mask withTexture:texture withSize:size];
    [self checkGLError];
}

/*
 * Draw portrait mask with color
 */
- (void)drawPortraitMask:(unsigned char *)mask withBackground:(GLuint)backgroundTexture currentTexture:(GLuint)texture frameBuffer:(GLuint)frameBuffer size:(int *)size {
    glViewport(0, 0, viewWidth, viewHeight);
    [_bgTextureMaskProgram drawMask:mask withTexture:backgroundTexture withSize:size];
    [self checkGLError];
}

- (void)drawSegment:(unsigned char*)mask affine:(float*)affine withColor:(be_rgba_color)color currentTexture:(GLuint)texture  size:(int*)size
{
    glViewport(0, 0, viewWidth, viewHeight);
    [_faceMaskProgram drawSegment:mask affine:affine withColor:color currentTexture:texture size:size withViportWidth:viewWidth height:viewHeight];
    [self checkGLError];
}

- (void)drawCircular:(int)x y:(int)y withColor:(be_rgba_color)color radius:(float)radius
{
    glViewport(0, 0, viewWidth, viewHeight);
    bef_ai_rectf rectf;
    rectf.left = x - radius;
    rectf.top = y - radius;
    rectf.right = rectf.left + radius*2;
    rectf.bottom = rectf.top + radius*2;
    
    rectf.left = [self _transFormX:rectf.left];
    rectf.top = [self _transFormY:rectf.top];
    rectf.right = [self _transFormX:rectf.right];
    rectf.bottom = [self _transFormY:rectf.bottom];
    
    GLfloat positions[8];
    
    positions[0] = rectf.left;
    positions[1] = rectf.bottom;
    positions[2] = rectf.right;
    positions[3] = rectf.bottom;
    positions[4] = rectf.left;
    positions[5] = rectf.top;
    positions[6] = rectf.right;
    positions[7] = rectf.top;
    
    [_drawCircularsProgram drawCircular:positions withColor:color];
    
    [self checkGLError];
}

- (void)drawDashLine:(be_render_helper_line*)line withColor:(be_rgba_color)color lineWidth:(float)lineWidth
{
    glViewport(0, 0, viewWidth, viewHeight);
    
    line->x1 = [self _transFormX:line->x1];
    line->y1 = [self _transFormY:line->y1];
    line->x2 = [self _transFormX:line->x2];
    line->y2 = [self _transFormY:line->y2];
    
    [_drawDashlineProgram drawDashLine:*line withColor:color withWidth:lineWidth];
    [self checkGLError];
}

@end
