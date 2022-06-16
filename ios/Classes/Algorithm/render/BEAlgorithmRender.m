//
//  BEAlgorithmRender.m
//  Algorithm
//
//  Created by qun on 2021/5/31.
//

#import "BEAlgorithmRender.h"
#import "BEAlgorithmRenderHelper.h"

#import "BEFaceAlgorithmTask.h"
#import "BEHandAlgorithmTask.h"
#import "BESkeletonAlgorithmTask.h"
#import "BEPetFaceAlgorithmTask.h"
#import "BEHeadSegmentAlgorithmTask.h"
#import "BEPortraitMattingAlgorithmTask.h"
#import "BEHairParserAlgorithmTask.h"
#import "BESkySegAlgorithmTask.h"
#import "BELightClsAlgorithmTask.h"
#import "BEHumanDistanceAlgorithmTask.h"
#import "BEConcentrationTask.h"
#import "BEGazeEstimationTask.h"
#import "BEC1AlgorithmTask.h"
#import "BEC2AlgorithmTask.h"
#import "BEVideoClsAlgorithmTask.h"
#import "BECarDetectTask.h"
#import "BEFaceVerifyAlgorithmTask.h"
#import "BEFaceClusterAlgorithmTask.h"
#import "BEAnimojiAlgorithmTask.h"
#import "BEActionRecognitionAlgorithmTask.h"
#import "BEDynamicGestureAlgorithmTask.h"
#import "BESkinSegmentationAlgorithmTask.h"
#import "BEBachSkeletonAlgorithmTask.h"
#import "BEChromaKeyingAlgorithmTask.h"


static be_rgba_color const BE_COLOR_RED = {1.0, 0.0, 0.0, 1.0};
static be_rgba_color const BE_COLOR_GREEN = {0.0, 1.0, 0.0, 1.0};
static be_rgba_color const BE_COLOR_BLUE = {0.0, 0.0, 1.0, 1.0};
static be_rgba_color const BE_COLOR_YELLOW = {1.0, 1.0, 0.0, 1.0};
static be_rgba_color const BE_COLOR_HAIR = {0.5, 0.08, 1.0, 0.3};
static be_rgba_color const BE_COLOR_PRORTRAIT = {1.0, 0.0, 0.0, 0.3};
static be_rgba_color const BE_COLOR_SKY = {0.0, 1.0, 0.0, 0.3};
static be_rgba_color const BE_COLOR_HEAD_MASK = {0.1, 0.28, 0.6, 0.3};
static be_rgba_color const BE_COLOR_SKIN_MASK = {0.5f, 0.5f, 0.8f, 0.8f};
static be_rgba_color const BE_COLOR_CHROMA_KEYING = {1.0, 0.0, 0.0, 1.0};


static float const BE_HAND_BOX_LINE_WIDTH = 2.0;
static float const BE_HAND_KEYPOINT_LINE_WIDTH = 3.0;
static float const BE_HAND_KEYPOINT_POINT_SIZE = 8.0;
static float const BE_SKELETON_LINE_WIDTH = 4.0;
static float const BE_SKELETION_LINE_POINT_SIZE = 8.0;
static float const BE_FACE_KEYPOINT_SIZE = 4.0;
static float const BE_FACE_KEYPOINT_EXTRA_SIZE = 3.0;
static float const BE_FACE_BOX_WIDTH = 2.0;

#define CHECK_RESULT_TYPE_AND_DO(RESULT, CLASS, DO)\
if ([RESULT isKindOfClass:[CLASS class]]) {\
CLASS *ret = (CLASS *)result;\
DO;\
}

@interface BEAlgorithmRender () {
    
    BEAlgorithmRenderHelper          *_renderHelper;
    GLuint                  _frameBuffer;
}

@property (nonatomic, assign) GLuint currentTexture;
@end

@implementation BEAlgorithmRender

- (instancetype)init
{
    self = [super init];
    if (self) {
        glGenFramebuffers(1, &_frameBuffer);
        NSLog(@"gen frameBuffer %d", _frameBuffer);
    }
    return self;
}

- (void)destroy {
    //  {zh} 为了避免 _frameBuffer 未绑定过的情况，  {en} To avoid _frameBuffer unbound,
    //  {zh} 在释放之前先进行一次绑定测试  {en} Do a binding test before releasing
    if (!glIsFramebuffer(_frameBuffer)) {
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        GLenum error = glGetError();
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        if (error != GL_NO_ERROR) {
            return;
        }
    }
    if (glIsFramebuffer(_frameBuffer)) {
        NSLog(@"delete frameBuffer %d", _frameBuffer);
        glDeleteFramebuffers(1, &_frameBuffer);
    }
}

- (void)setRenderTargetTexture:(GLuint)texture width:(int)width height:(int)height resizeRatio:(float)ratio {
    _currentTexture = texture;
    [self.renderHelper setViewWidth:width height:height];
    [self.renderHelper setResizeRatio:ratio];
}

- (void)drawAlgorithmResult:(id)result {
    CHECK_RESULT_TYPE_AND_DO(result, BEFaceAlgorithmResult, {
        if (ret.faceInfo != nil) {
            [self drawFace:ret.faceInfo withExtra:YES];
        }
        if (ret.faceMask != nil) {
            for (int i = 0; i < ret.faceMask->face_count; i++) {
                bef_ai_face_mask_base mask_base = ret.faceMask->face_mask[i];
                [self drawPartialSegment:mask_base.mask  wrapMat:mask_base.warp_mat type:BEF_FACE_DETECT_FACE_MASK width:BEF_FACE_MASK_WIDTH height:BEF_FACE_MASK_WIDTH];
            }
        }
        if (ret.mouthMask != nil) {
            for (int i = 0; i < ret.mouthMask->face_count; i++) {
                bef_ai_face_mask_base mask_base = ret.mouthMask->mouth_mask[i];
                [self drawPartialSegment:mask_base.mask  wrapMat:mask_base.warp_mat type:BEF_FACE_DETECT_MOUTH_MASK width:BEF_MOUTH_MASK_WIDTH height:BEF_MOUTH_MASK_WIDTH];
            }
        }
        if (ret.teethMask != nil) {
            for (int i = 0; i < ret.teethMask->face_count; i++) {
                bef_ai_face_mask_base mask_base = ret.teethMask->teeth_mask[i];
                [self drawPartialSegment:mask_base.mask  wrapMat:mask_base.warp_mat type:BEF_FACE_DETECT_TEETH_MASK width:BEF_TEETH_MASK_WIDTH height:BEF_TEETH_MASK_WIDTH];
            }
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEHandAlgorithmResult, {
        if (ret.handInfo != nil) {
            [self drawHands:ret.handInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BESkeletonAlgorithmResult, {
        if (ret.skeletonInfo != nil) {
            [self drawSkeleton:ret.skeletonInfo withCount:ret.count];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEPetFaceAlgorithmResult, {
        if (ret.petFaceInfo != nil) {
            [self drawPetFace:ret.petFaceInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEHeadSegmentAlgorithmResult, {
        if (ret.headSegInfo != nil) {
            for (int i = 0; i < ret.headSegInfo->face_count; i++) {
                float m[6];
                for (int j = 0; j < 6; j++) {
                    m[j] = (float)(ret.headSegInfo->face_result[i].matrix[j]);
                }
                int size[2];
                size[0] = ret.headSegInfo->face_result[i].width;
                size[1] = ret.headSegInfo->face_result[i].height;
                [self drawMask:ret.headSegInfo->face_result[i].alpha withAffine:m size:size color:BE_COLOR_HEAD_MASK];
            }
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEPortraitMattingAlgorithmResult, {
        if (ret.mask != nil) {
            [self drawPrortrait:ret.mask size:ret.size];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEHairParserAlgorithmResult, {
        if (ret.mask != nil) {
            [self drawHairParse:ret.mask size:ret.size];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BESkySegAlgorithmResult, {
        if (ret.mask != nil && ret.hasSky) {
            [self drawSkySeg:ret.mask size:ret.size];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEHumanDistanceAlgorithmResult, {
        if (ret.faceInfo != nil) {
            [self drawFaceRect:ret.faceInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEGazeEstimationAlgorithmResult, {
        if (ret.gazeInfo != nil) {
            [self drawGaze:ret.gazeInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BECarAlgorithmResult, {
        if (ret.carInfo != nil) {
            [self drawCar:ret.carInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BEActionRecognitionAlgorithmResult, {
        if (ret.actionRecognitionInfo != nil) {
            [self drawActionRecognition:ret.actionRecognitionInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result, BESkinSegmentationAlgorithmResult, {
        if (ret.skinSegInfo != nil) {
            [self drawSkinSegmentaion:ret.skinSegInfo];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result,
        BEBachSkeletonAlgorithmResult, {
        if (ret.skeletonInfo != nil) {
            [self drawBachSkeleton:ret.skeletonInfo withCount:ret.count];
        }
    }) else CHECK_RESULT_TYPE_AND_DO(result,
        BEChromaKeyingAlgorithmResult, {
        if (ret.chromaKeyingInfo != nil) {
            [self drawChromaKeying:ret.chromaKeyingInfo];
        }
        
    })
}

//draw faces
- (void) drawFace:(bef_ai_face_info *)faceDetectResult withExtra:(BOOL)extra{
    //draw face 106
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw face" reason:@"error" userInfo:nil];
    }
    
    for (int i = 0; i < faceDetectResult->face_count; i ++){
        //draw basic 106 rect
        bef_ai_rect* rect = &faceDetectResult->base_infos[i].rect;
        [self.renderHelper drawRect:rect withColor:BE_COLOR_RED lineWidth:BE_FACE_BOX_WIDTH];
        
        //draw basic 106 points
        bef_ai_fpoint* points = faceDetectResult->base_infos[i].points_array;
        [self.renderHelper drawPoints:points count:106 color:BE_COLOR_RED pointSize:BE_FACE_KEYPOINT_SIZE];
        
        if (extra){ //draw th extra face info
            bef_ai_face_ext_info* extendInfo = faceDetectResult->extra_infos + i;
            
            if (extendInfo->eye_count > 0){
                //left eye
                be_rgba_color color = BE_COLOR_RED;
                bef_ai_fpoint* left_eye = extendInfo->eye_left;
                
                [self.renderHelper drawPoints:left_eye count:22 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
                
                //right eye
                bef_ai_fpoint* right_eye = extendInfo->eye_right;
                [self.renderHelper drawPoints:right_eye count:22 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
            }
            
            if (extendInfo->eyebrow_count > 0){
                //left eyebrow
                bef_ai_fpoint* left_eyebrow = extendInfo->eyebrow_left;
                be_rgba_color color = BE_COLOR_RED;
                
                [self.renderHelper drawPoints:left_eyebrow count:13 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
                
                //right eyebrow
                bef_ai_fpoint* right_eyebrow = extendInfo->eyebrow_right;
                [self.renderHelper drawPoints:right_eyebrow count:13 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
                
            }
            
            if (extendInfo->iris_count > 0){
                //left iris
                bef_ai_fpoint* left_iris = extendInfo->left_iris;
                be_rgba_color color = BE_COLOR_YELLOW;
                
                [self.renderHelper drawPoints:left_iris count:20 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
                [self.renderHelper drawPoint:left_iris->x y:left_iris->y withColor:BE_COLOR_GREEN pointSize:BE_FACE_KEYPOINT_SIZE];
                
                //right iris
                bef_ai_fpoint* right_iris = extendInfo->right_iris;
                
                [self.renderHelper drawPoints:right_iris count:20 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
                
                [self.renderHelper drawPoint:right_iris->x y:right_iris->y withColor:BE_COLOR_GREEN pointSize:BE_FACE_KEYPOINT_SIZE];
            }
            
            if (extendInfo->lips_count > 0){
                //lips
                bef_ai_fpoint* lips = extendInfo->lips;
                be_rgba_color color = BE_COLOR_RED;
                
                [self.renderHelper drawPoints:lips count:60 color:color pointSize:BE_FACE_KEYPOINT_EXTRA_SIZE];
            }
        }
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    
    [self checkGLError];
}


// draw face rect
- (void) drawFaceRect:(bef_ai_face_info *)faceDetectResult{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw face" reason:@"error" userInfo:nil];
    }
    
    for (int i = 0; i < faceDetectResult->face_count; i ++){
        //draw basic 106 rect
        bef_ai_rect* rect = &faceDetectResult->base_infos[i].rect;
        [self.renderHelper drawRect:rect withColor:BE_COLOR_RED lineWidth:BE_FACE_BOX_WIDTH];
        
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    [self checkGLError];
    
}
//draw hands info
- (void) drawHands:(bef_ai_hand_info* )handDetectResult{
    int handsCount = handDetectResult->hand_count;
    if (handsCount <= 0) return;
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw hands" reason:@"error" userInfo:nil];
    }
    
    for (int i = 0; i < handsCount; i ++){
        bef_ai_hand* handInfo = &handDetectResult->p_hands[i];
        
        //draw hand rect
        bef_ai_rect* handRect = &handInfo->rect;
        [self.renderHelper drawRect:handRect withColor:BE_COLOR_RED lineWidth:BE_HAND_BOX_LINE_WIDTH];
        
        //draw hand basic key points
        bef_ai_tt_key_point *baiscHandKeyPoints = handInfo->key_points;
        for (int j = 0; j < BEF_HAND_KEY_POINT_NUM; j ++){
            bef_ai_tt_key_point *point = baiscHandKeyPoints + j;
            
            if (point->is_detect){
                [self.renderHelper drawPoint:point->x y:point->y withColor:BE_COLOR_RED pointSize:BE_HAND_KEYPOINT_POINT_SIZE];
            }
        }
        
        //draw hand extend key points
        bef_ai_tt_key_point *extendHandKeyPoins = handInfo->key_points_extension;
        for (int j = 0; j < BEF_HAND_KEY_POINT_NUM_EXTENSION; j ++){
            bef_ai_tt_key_point *point = extendHandKeyPoins + j;
            
            if (point->is_detect){
                [self.renderHelper drawPoint:point->x y:point->y withColor:BE_COLOR_RED pointSize:BE_HAND_KEYPOINT_POINT_SIZE];
            }
        }
        
        bef_ai_fpoint points[5];
        points[0].x = handInfo->key_points[0].x;
        points[0].y = handInfo->key_points[0].y;
        
        //draw hand line
        for (int n = 0; n < 5; n ++){
            int index = 4 * n + 1;
            for (int k = 1; k < 5; k++){
                points[k].x = handInfo->key_points[index].x;
                points[k].y = handInfo->key_points[index++].y;
            }
            [self.renderHelper drawLinesStrip:points withCount:5 withColor:BE_COLOR_RED lineWidth:BE_HAND_KEYPOINT_LINE_WIDTH];
        }
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    
    [self checkGLError];
}

/*
 *Draw skeletons
 */
- (void)drawSkeleton:(bef_ai_skeleton_info*) skeletonDetectResult withCount:(int)validCount{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw skeleton" reason:@"error" userInfo:nil];
    }
    
    for (int j = 0; j < validCount; j ++){
        bef_ai_skeleton_info* skeletonInfo = skeletonDetectResult + j;
        
        //draw huaman rect
        bef_ai_rect rect = skeletonInfo->skeletonRect;
        [self.renderHelper drawRect:&rect withColor:BE_COLOR_RED lineWidth:BE_HAND_KEYPOINT_LINE_WIDTH];
        
        //draw points
        for (int i = 0; i < BEF_AI_MAX_SKELETON_POINT_NUM; i ++){
            bef_ai_skeleton_point_info *point = skeletonInfo->keyPointInfos + i;
            
            if (point->is_detect)
                [self.renderHelper drawPoint:point->x y:point->y withColor:BE_COLOR_BLUE pointSize:BE_SKELETION_LINE_POINT_SIZE];
        }
        
        //draw line
        int pairs[36] = {4, 3, 3, 2, 2, 1, 1, 5, 5, 6, 6, 7,
            16, 14, 14, 0, 17, 15, 15, 0,
            1, 8, 8, 11, 11, 1, 1, 0,
            8, 9, 9, 10, 11, 12, 12, 13};
        
        for (int i = 0; i <= 34; i +=2){
            bef_ai_skeleton_point_info *left = skeletonInfo->keyPointInfos + pairs[i];
            bef_ai_skeleton_point_info *right = skeletonInfo->keyPointInfos + pairs[i + 1];
            struct be_render_helper_line line = {0.0, 0.0, 0.0, 0.0};
            
            if(left->is_detect && right->is_detect){
                line.x1 = left->x;
                line.y1 = left->y;
                line.x2 = right->x;
                line.y2 = right->y;
                [self.renderHelper drawLine:&line withColor:BE_COLOR_BLUE lineWidth:BE_SKELETON_LINE_WIDTH];
            }
        }
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    [self checkGLError];
}


/*
 *Draw hair parse result
 */
- (void) drawHairParse:(unsigned char*)mask size:(int*)size{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw hair" reason:@"error" userInfo:nil];
    }
    
    [self.renderHelper drawMask:mask  withColor:BE_COLOR_HAIR currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
}

- (void)drawSkySeg:(unsigned char *)mask size:(int *)size {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw hair" reason:@"error" userInfo:nil];
    }
    
    [self.renderHelper drawMask:mask withColor:BE_COLOR_SKY currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
}

/*
 *Draw prortrait detect result
 */
- (void) drawPrortrait:(unsigned char*)mask size:(int*)size{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw protrait" reason:@"error" userInfo:nil];
    }
    
    [self.renderHelper drawMask:mask withColor:BE_COLOR_PRORTRAIT currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    //    [self.renderHelper drawPortraitMask:mask withBackground:backgroundTexture currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
}
- (void)drawMask:(unsigned char*)mask withAffine:(float*)affine size:(int*)size color:(be_rgba_color)color{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw mask withAffine" reason:@"error" userInfo:nil];
    }
    
    [self.renderHelper drawMask:mask affine:affine withColor:color currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
}



//- (void) drawHeadsegment:(unsigned char*)mask affine:(double*)affine size:(int*)size{
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
//
//    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
//    if (status != GL_FRAMEBUFFER_COMPLETE ){
//        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw protrait" reason:@"error" userInfo:nil];
//    }
//    GLuint backgroundTexture = [self portraitBackgroundTexture];
//
//    [self.renderHelper drawMask:mask affine:affine withBackground:backgroundTexture currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
//
//    glBindFramebuffer(GL_FRAMEBUFFER, 0);
//}

- (void)drawPetFace:(bef_ai_pet_face_result *)petFaceResult {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        @throw [NSException exceptionWithName:@"glCheckFramebufferSattus when draw pet face" reason:@"error" userInfo:nil];
    }
    
    for (int i = 0; i < petFaceResult->face_count; i++) {
        bef_ai_pet_face_info info = petFaceResult->p_faces[i];
        
        // draw rect
        bef_ai_rect *rect = &info.rect;
        [self.renderHelper drawRect:rect withColor:BE_COLOR_RED lineWidth:BE_SKELETON_LINE_WIDTH];
        
        // draw points
        bef_ai_fpoint *points = info.points_array;
        int count = info.type == BEF_CAT ? AI_CAT_POINT_NUM : AI_DOG_POINT_NUM;
        [self.renderHelper drawPoints:points count:count color:BE_COLOR_RED pointSize:BE_FACE_KEYPOINT_SIZE];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    
    [self checkGLError];
}

//- (void)drawGeneralObject:(bef_ai_general_object_detection_result *)generalObjectResult {
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
//
//    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
//    if (status != GL_FRAMEBUFFER_COMPLETE) {
//        @throw [NSException exceptionWithName:@"glCheckFramebufferSattus when draw pet face" reason:@"error" userInfo:nil];
//    }
//
//    for (int i = 0; i < generalObjectResult->obj_num; i++) {
//        bef_ai_object_info info = generalObjectResult->obj_infos[i];
//        // draw rect
//        bef_ai_rect *rect = &info.bbox;
//        [self.renderHelper drawRect:rect withColor:BE_COLOR_RED lineWidth:BE_SKELETON_LINE_WIDTH];
//    }
//
//    glBindFramebuffer(GL_FRAMEBUFFER, 0);
//
//    [self checkGLError];
//}

- (void)drawGaze:(bef_ai_gaze_estimation_info *)gazeInfo {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw skeleton" reason:@"error" userInfo:nil];
    }
    
    for (int i = 0; i < gazeInfo->face_count; i++) {
        bef_ai_gaze_info_base item = gazeInfo->eye_infos[i];
        if (!item.valid) continue;
        be_render_helper_line lline, rline;
        lline.x1 = item.leye_pos2d[0];
        lline.y1 = item.leye_pos2d[1];
        lline.x2 = item.leye_gaze2d[0];
        lline.y2 = item.leye_gaze2d[1];
        rline.x1 = item.reye_pos2d[0];
        rline.y1 = item.reye_pos2d[1];
        rline.x2 = item.reye_gaze2d[0];
        rline.y2 = item.reye_gaze2d[1];
        [self.renderHelper drawLine:&lline withColor:BE_COLOR_RED lineWidth:5];
        [self.renderHelper drawLine:&rline withColor:BE_COLOR_RED lineWidth:5];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    
    [self checkGLError];
}

- (void)drawCar:(bef_ai_car_ret *)carInfo {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw skeleton" reason:@"error" userInfo:nil];
    }
    
    for (int i = 0; i < carInfo->car_count; ++i) {
        bef_ai_car_bounding_box info = carInfo->car_boxes[i];
        bef_ai_rect rect;
        rect.left = info.x0;
        rect.top = info.y0;
        rect.right = info.x1;
        rect.bottom = info.y1;
        [self.renderHelper drawRect:&rect withColor:BE_COLOR_RED lineWidth:BE_HAND_BOX_LINE_WIDTH];
    }
    
    for (int i = 0; i < carInfo->brand_count; ++i) {
        bef_ai_car_brand_info info = carInfo->base_infos[i];
        bef_ai_rect rect;
        rect.left = info.points_array[1].x;
        rect.top = info.points_array[1].y;
        rect.right = info.points_array[3].x;
        rect.bottom = info.points_array[3].y;
        [self.renderHelper drawRect:&rect withColor:BE_COLOR_RED lineWidth:BE_HAND_BOX_LINE_WIDTH];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    
    [self checkGLError];
}

- (void) drawPartialSegment:(unsigned char*)mask wrapMat:(float*)wrapMat type:(int)maskType width:(int)width height:(int)height
{
    GLint mPreFBO;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &mPreFBO);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw protrait" reason:@"error" userInfo:nil];
    }
    
    int mSize[2] = {width, height};
    be_rgba_color mColor;
    switch (maskType) {
        case BEF_FACE_DETECT_MOUTH_MASK:
            mColor = BE_COLOR_RED;
            break;
        case BEF_FACE_DETECT_TEETH_MASK:
            mColor = BE_COLOR_GREEN;
            break;
        case BEF_FACE_DETECT_FACE_MASK:
            mColor = BE_COLOR_BLUE;
            break;
        default:
            mColor = BE_COLOR_RED;
            break;
    }
    
    [self.renderHelper drawSegment:mask affine:wrapMat withColor:mColor currentTexture:_currentTexture size:mSize];
    
    glBindFramebuffer(GL_FRAMEBUFFER, mPreFBO);
    glFlush();
    
}

/*
 *Draw actionRecognition
 */
- (void)drawActionRecognition:(bef_ai_action_recognition_result*) arResult{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        
        int error = glGetError();
        if (error != GL_NO_ERROR) {
            NSLog(@"%d", error);
        }
        NSString* errStr = [NSString stringWithFormat:@"status:%d  error:%d",status,error];
        
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw action_recognition" reason:errStr userInfo:nil];
    }
    
    //draw line
    int pairs[36] = {4, 3, 3, 2, 2, 1, 1, 5, 5, 6, 6, 7,
        16, 14, 14, 0, 17, 15, 15, 0,
        1, 8, 8, 11, 11, 1, 1, 0,
        8, 9, 9, 10, 11, 12, 12, 13};

    be_rgba_color rightLineColor = {.55, 0.55, 0.55, 1.0};
    for (int i = 0; i <= 34; i +=2){
        bef_ai_tt_key_point *left = arResult->keypoints + pairs[i];
        bef_ai_tt_key_point *right = arResult->keypoints + pairs[i + 1];
        struct be_render_helper_line line = {0.0, 0.0, 0.0, 0.0};

        if(left->is_detect && right->is_detect){
            line.x1 = left->x;
            line.y1 = left->y;
            line.x2 = right->x;
            line.y2 = right->y;
            [self.renderHelper drawDashLine:&line withColor:rightLineColor lineWidth:BE_SKELETON_LINE_WIDTH];
        }
    }
    
    if(arResult->is_feedback_valid)
    {
        be_rgba_color wrongColor = {0.98, 0.59, 0.0, 1.0};
        //draw  feedback line
        for (int i = 0; i <= arResult->feedback_kp_count; i +=2){
            bef_ai_tt_key_point *left = arResult->feedback_keypoints + i;
            bef_ai_tt_key_point *right = arResult->feedback_keypoints + i + 1;
            struct be_render_helper_line line = {0.0, 0.0, 0.0, 0.0};
            
            if(left->is_detect && right->is_detect){
                line.x1 = left->x;
                line.y1 = left->y;
                line.x2 = right->x;
                line.y2 = right->y;
                [self.renderHelper drawDashLine:&line withColor:wrongColor lineWidth:BE_SKELETON_LINE_WIDTH];
            }
        }
    }
    
    //draw points
    be_rgba_color rightBgColor = {1.0, 1.0, 1.0, 1.0};
    be_rgba_color rightColor = {0.086, 0.39, 1.0, 1.0};
    be_rgba_color wrongColor = {0.98, 0.59, 0.0, 1.0};
    for (int i = 0; i < BEF_AI_ACTION_RECOGNITION_MAX_POINT_NUM; i ++){
        bef_ai_tt_key_point *point = arResult->keypoints + i;
        
        if (point->is_detect)
        {
            [self.renderHelper drawCircular:point->x y:point->y withColor:rightBgColor radius:6*3];
            [self.renderHelper drawCircular:point->x y:point->y withColor:rightColor radius:4.5*3];
        }
    }
    
    if(arResult->is_feedback_valid)
    {
        //draw feedback points
        for (int i = 0; i < arResult->feedback_kp_count; i ++){
            bef_ai_tt_key_point *point = arResult->feedback_keypoints + i;
            
            if (point->is_detect)
            {
                [self.renderHelper drawCircular:point->x y:point->y withColor:rightBgColor radius:6*3];
                [self.renderHelper drawCircular:point->x y:point->y withColor:wrongColor radius:4.5*3];
            }
        }
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    [self checkGLError];
}

/*
 * Draw skin segmentation
 */
- (void)drawSkinSegmentaion:(bef_ai_skin_segmentation_ret *) skin_seg_info {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw hair" reason:@"error" userInfo:nil];
    }
    
    int size[] = {skin_seg_info->width, skin_seg_info->height};
    
    [self.renderHelper drawMask:skin_seg_info->mask withColor:BE_COLOR_SKIN_MASK currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
}

/*
 * Draw bach skeletons
 */
- (void)drawBachSkeleton:(bef_ai_bach_skeleton_info*) skeletonDetectResult withCount:(int)validCount{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw skeleton" reason:@"error" userInfo:nil];
    }
    
    for (int j = 0; j < validCount; j ++){
        bef_ai_bach_skeleton_info* skeletonInfo = skeletonDetectResult + j;
        
        //draw huaman rect
        bef_ai_rect rect = skeletonInfo->skeletonRect;
        [self.renderHelper drawRect:&rect withColor:BE_COLOR_RED lineWidth:BE_HAND_KEYPOINT_LINE_WIDTH];
        
        //draw points
        for (int i = 0; i < BEF_AI_MAX_BACH_SKELETON_POINT_NUM; i ++){
            bef_ai_bach_skeleton_point_info *point = skeletonInfo->keyPointInfos + i;
            
            if (point->is_detect)
                [self.renderHelper drawPoint:point->x y:point->y withColor:BE_COLOR_BLUE pointSize:BE_SKELETION_LINE_POINT_SIZE];
        }
        
        //draw line
        int pairs[63 * 2] = {0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24, 23, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 33, 33, 35, 35, 34, 35, 36, 36, 37, 37, 38, 38, 39, 39, 40, 40, 41, 41, 42, 42, 43, 43, 44, 44, 45, 45, 46, 46, 47, 47, 48, 48, 49, 49, 50, 50, 51, 51, 52, 52, 53, 53, 54, 54, 55, 55, 56, 56, 57, 57, 58, 58, 59, 59, 60, 60, 61, 61, 62, 62, 0};
        
        // draw line color
        int contour_colors[63 * 3] = {255, 128,   0, 255, 128,   0, 255, 128,   0, 255, 128,   0, 255, 128,   0, 255, 128,   0, 255, 128,   0, 255,  51, 255, 255,  51, 255, 255,  51, 255, 255,  51, 255, 255,  51, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255, 51, 153, 255,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,   0, 255,   0,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255,  51, 153, 255, 255,  51, 255, 255,  51, 255, 255,  51, 255, 255,  51, 255, 255,  51, 255, 255, 128,   0, 255, 128,   0, 255, 128, 0, 255, 128,   0, 255, 128,   0, 255, 128,   0, 255, 128,   0, 230, 230,   0, 230, 230,   0, 230, 230,   0, 230, 230,   0, 230, 230,   0};
        
        for (int i = 0; i < 63; ++i) {
            bef_ai_bach_skeleton_point_info *left  = skeletonInfo->keyPointInfos + pairs[i * 2    ];
            bef_ai_bach_skeleton_point_info *right = skeletonInfo->keyPointInfos + pairs[i * 2 + 1];
            
            float c1 = (float)contour_colors[i * 3    ] / 255.0f;
            float c2 = (float)contour_colors[i * 3 + 1] / 255.0f;
            float c3 = (float)contour_colors[i * 3 + 2] / 255.0f;
            
            struct be_render_helper_line line = {0.0, 0.0, 0.0, 0.0};
            struct be_rgba_color color = {c1, c2, c3, 1.0f};
            
            if(left->is_detect && right->is_detect){
                line.x1 = left->x;
                line.y1 = left->y;
                line.x2 = right->x;
                line.y2 = right->y;
                [self.renderHelper drawLine:&line withColor:color lineWidth:BE_SKELETON_LINE_WIDTH];
            }
        }
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
    [self checkGLError];
}

/*
 * Draw chroma keying
 */
- (void)drawChromaKeying:(bef_ai_chroma_keying_ret *) chroma_keying_info {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _currentTexture, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE ){
        @throw [NSException exceptionWithName:@"glCheckFramebufferStatus when draw hair" reason:@"error" userInfo:nil];
    }
    
    int size[] = {chroma_keying_info->width, chroma_keying_info->height};
    
    unsigned char *mask = malloc(size[0] * size[1]);
    
    for (int i = 0; i < size[0] * size[1]; ++i) {
        mask[i] = (unsigned char)255 - chroma_keying_info->mask[i];
    }
    
    [self.renderHelper drawMask:mask withColor:BE_COLOR_CHROMA_KEYING currentTexture:_currentTexture frameBuffer:_frameBuffer size:size];
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glFlush();
}


#pragma mark - private

- (void)checkGLError {
    int error = glGetError();
    if (error != GL_NO_ERROR) {
        NSLog(@"%d", error);
        @throw [NSException exceptionWithName:@"GLError" reason:@"error " userInfo:nil];
    }
}

- (BEAlgorithmRenderHelper*)renderHelper {
    if (!_renderHelper){
        _renderHelper = [[BEAlgorithmRenderHelper alloc] init];
    }
    return _renderHelper;
}

@end
