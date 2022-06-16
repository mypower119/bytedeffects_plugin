//
//  BEAlgorithmResourceHelper.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEAlgorithmResourceHelper.h"

static NSString *LICENSE_PATH = @"LicenseBag";
static NSString *MODEL_PATH = @"ModelResource";
static NSString *BUNDLE = @"bundle";

static NSString *FACE_MODEL = @"/ttfacemodel/tt_face_v10.0.model";
static NSString *FACE_EXTRA_MODEL = @"/ttfacemodel/tt_face_extra_v13.0.model";
static NSString *FACE_ATTR_MODEL = @"/ttfaceattrmodel/tt_face_attribute_tob_v7.0.model";
static NSString *HAND_MODEL = @"/handmodel/tt_hand_det_v11.0.model";
static NSString *HAND_BOX_MODEL = @"/handmodel/tt_hand_box_reg_v12.0.model";
static NSString *HAND_GESTURE_MODEL = @"/handmodel/tt_hand_gesture_v11.0.model";
static NSString *HAND_KEYPOINT_MODEL = @"/handmodel/tt_hand_kp_v6.0.model";
static NSString *SKELETON_MODEL = @"/skeleton_model/tt_skeleton_v7.0.model";
static NSString *PET_FACE_MODEL = @"/petfacemodel/tt_petface_v5.2.model";
static NSString *HEAD_SEG_MODEL = @"/headsegmodel/tt_headseg_v6.0.model";
static NSString *PORTRAIT_MATTING_MODEL = @"/mattingmodel/tt_matting_v14.0.model";
static NSString *HAIR_PARSER_MODEL = @"/hairparser/tt_hair_v11.0.model";
static NSString *SKY_SEG_MODEL = @"/skysegmodel/tt_skyseg_v7.0.model";
static NSString *LIGHT_CLS_MODEL = @"/lightcls/tt_lightcls_v1.0.model";
static NSString *GAZE_MODEL = @"/gazeestimation/tt_gaze_v3.0.model";
static NSString *C1_MODEL = @"/c1/tt_c1_small_v8.0.model";
static NSString *C2_MODEL = @"/c2/tt_C2Cls_v5.0.model";
static NSString *VIDEO_CLS_MODEL = @"/video_cls/tt_videoCls_v4.0.model";
static NSString *CAR_DETECT_MODEL = @"/cardamanagedetect/tt_car_damage_detect_v2.0.model";
static NSString *CAR_LANDMARK_MODEL = @"/cardamanagedetect/tt_car_landmarks_v3.0.model";
static NSString *CAR_PLATE_OCR_MODEL = @"/cardamanagedetect/tt_car_plate_ocr_v2.0.model";
static NSString *CAR_TRACK_MODEL = @"/cardamanagedetect/tt_car_track_v2.0.model";
static NSString *FACE_VERIFY_MODEL = @"/ttfaceverify/tt_faceverify_v7.0.model";
static NSString *ANIMOJI_MODEL = @"/animoji/animoji_v5.0.model";
static NSString *ACTION_RECOGNITION_MODEL = @"/action_recognition/tt_skeletonact_tob_v7.2.model";
static NSString *ACTION_RECOGNITION_TMPL_OPENCLOSE = @"/action_recognition/openclose-tmpl.dat";
static NSString *ACTION_RECOGNITION_TMPL_PLANK = @"/action_recognition/plank-tmpl.dat";
static NSString *ACTION_RECOGNITION_TMPL_PUSHUP = @"/action_recognition/pushup-tmpl.dat";
static NSString *ACTION_RECOGNITION_TMPL_SITUP = @"/action_recognition/situp-tmpl.dat";
static NSString *ACTION_RECOGNITION_TMPL_SQUAT = @"/action_recognition/squat-tmpl.dat";
static NSString *DYNAMIC_GESTURE_MODEL = @"/dynamic_gesture/";
static NSString *SKIN_SEGMENTATION_MODEL = @"/skin_segmentation/";
static NSString *BACH_SKELETON_MODEL = @"/bach_skeleton/";
static NSString *CHROMA_KEYING_MODEL = @"/chroma_keying/";
static NSString *ACTION_RECOGNITION_TMPL_HIGHRUN = @"/action_recognition/high_run.dat";
static NSString *ACTION_RECOGNITION_TMPL_HIPBRIDGE = @"/action_recognition/hip_bridge.dat";
static NSString *ACTION_RECOGNITION_TMPL_KNEELINGPUSHUP = @"/action_recognition/kneeling_pushup.dat";
static NSString *ACTION_RECOGNITION_TMPL_LUNGESQUAT = @"/action_recognition/lunge_squat.dat";
static NSString *ACTION_RECOGNITION_TMPL_LUNGE = @"/action_recognition/lunge.dat";

@interface BEAlgorithmResourceHelper () {
    
    NSString            *_licensePrefix;
}

@end

@implementation BEAlgorithmResourceHelper

- (const char *)faceModel {
    return [self modelPath:FACE_MODEL];
}

- (const char *)faceAttrModel {
    return [self modelPath:FACE_ATTR_MODEL];
}

- (const char *)faceExtraModel {
    return [self modelPath:FACE_EXTRA_MODEL];
}

- (const char *)handModel {
    return [self modelPath:HAND_MODEL];
}

- (const char *)handBoxModel {
    return [self modelPath:HAND_BOX_MODEL];
}

- (const char *)handGestureModel {
    return [self modelPath:HAND_GESTURE_MODEL];
}

- (const char *)handKeyPointModel {
    return [self modelPath:HAND_KEYPOINT_MODEL];
}

- (const char *)skeletonModel {
    return [self modelPath:SKELETON_MODEL];
}

- (const char *)petFaceModelPath {
    return [self modelPath:PET_FACE_MODEL];
}

- (const char *)headSegmentModelPath {
    return [self modelPath:HEAD_SEG_MODEL];
}

- (const char *)portraitMattingModelPath {
    return [self modelPath:PORTRAIT_MATTING_MODEL];
}

- (const char *)hairParserModelPath {
    return [self modelPath:HAIR_PARSER_MODEL];
}

- (const char *)skySegModelPath {
    return [self modelPath:SKY_SEG_MODEL];
}

- (const char *)lightClsModelPath {
    return [self modelPath:LIGHT_CLS_MODEL];
}

- (const char *)gazeModel {
    return [self modelPath:GAZE_MODEL];
}

- (const char *)c1ModelPath {
    return [self modelPath:C1_MODEL];
}

- (const char *)c2Model {
    return [self modelPath:C2_MODEL];
}

- (const char *)videoClsModelPath {
    return [self modelPath:VIDEO_CLS_MODEL];
}

- (const char *)carDetectModel {
    return [self modelPath:CAR_DETECT_MODEL];
}

- (const char *)carLandmarkModel {
    return [self modelPath:CAR_LANDMARK_MODEL];
}

- (const char *)carPlateOcrModel {
    return [self modelPath:CAR_PLATE_OCR_MODEL];
}

- (const char *)carTrackModel {
    return [self modelPath:CAR_TRACK_MODEL];
}

- (const char *)faceVerifyModelPath {
    return [self modelPath:FACE_VERIFY_MODEL];
}

- (const char *)animojiModelPath {
    return [self modelPath:ANIMOJI_MODEL];
}

- (const char *)actionRecognitionModel
{
    return [self modelPath:ACTION_RECOGNITION_MODEL];
}

- (const char *)actionRecognitionTMPL_OpenClose
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_OPENCLOSE];
}

- (const char *)actionRecognitionTMPL_PLANK
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_PLANK];
}

- (const char *)actionRecognitionTMPL_SITUP
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_SITUP];
}

- (const char *)actionRecognitionTMPL_SQUAT
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_SQUAT];
}

- (const char *)actionRecognitionTMPL_PUSHUP
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_PUSHUP];
}

- (const char *)dynamicGestureModelPath {
    return [self modelPath:DYNAMIC_GESTURE_MODEL];
}

- (const char *)skinSegmentationModelPath {
    return [self modelPath:SKIN_SEGMENTATION_MODEL];
}
- (const char *)bachSkeletonModel {
    return [self modelPath:BACH_SKELETON_MODEL];
}
- (const char *)chromaKeyingModelPath {
    return [self modelPath:CHROMA_KEYING_MODEL];
}
- (const char *)actionRecognitionTMPL_HIGHRUN
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_HIGHRUN];
}

- (const char *)actionRecognitionTMPL_HIPBRIDGE
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_HIPBRIDGE];
}

- (const char *)actionRecognitionTMPL_LUNGE
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_LUNGE];
}

- (const char *)actionRecognitionTMPL_LUNGESQUAT
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_LUNGESQUAT];
}

- (const char *)actionRecognitionTMPL_KNEELINGPUSHUP
{
    return [self modelPath:ACTION_RECOGNITION_TMPL_KNEELINGPUSHUP];
}

- (const char *)modelPath:(NSString *)model {
    return [[[self modelDirPath] stringByAppendingString:model] UTF8String];
}

- (NSString *)modelDirPath {
    return [[NSBundle mainBundle] pathForResource:MODEL_PATH ofType:BUNDLE];
}

@end
