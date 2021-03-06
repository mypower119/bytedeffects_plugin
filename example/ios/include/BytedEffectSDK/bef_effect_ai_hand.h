// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#ifndef _BEF_EFFECT_HAND_DETECT_AI_H_
#define _BEF_EFFECT_HAND_DETECT_AI_H_


#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"

//bef_effect_public_hand_define
#define BEF_TT_HAND_GESTURE_HEART_A 0
#define BEF_TT_HAND_GESTURE_HEART_B 1
#define BEF_TT_HAND_GESTURE_HEART_C 2
#define BEF_TT_HAND_GESTURE_HEART_D 3
#define BEF_TT_HAND_GESTURE_OK 4
#define BEF_TT_HAND_GESTURE_HAND_OPEN 5
#define BEF_TT_HAND_GESTURE_THUMB_UP 6
#define BEF_TT_HAND_GESTURE_THUMB_DOWN 7
#define BEF_TT_HAND_GESTURE_ROCK 8
#define BEF_TT_HAND_GESTURE_NAMASTE 9
#define BEF_TT_HAND_GESTURE_PLAM_UP 10
#define BEF_TT_HAND_GESTURE_FIST 11
#define BEF_TT_HAND_GESTURE_INDEX_FINGER_UP 12
#define BEF_TT_HAND_GESTURE_DOUBLE_FINGER_UP 13
#define BEF_TT_HAND_GESTURE_VICTORY 14
#define BEF_TT_HAND_GESTURE_BIG_V 15
#define BEF_TT_HAND_GESTURE_PHONECALL 16
#define BEF_TT_HAND_GESTURE_BEG 17
#define BEF_TT_HAND_GESTURE_THANKS 18
#define BEF_TT_HAND_GESTURE_UNKNOWN 19
#define BEF_TT_HAND_GESTURE_CABBAGE 20
#define BEF_TT_HAND_GESTURE_THREE 21
#define BEF_TT_HAND_GESTURE_FOUR 22
#define BEF_TT_HAND_GESTURE_PISTOL 23
#define BEF_TT_HAND_GESTURE_ROCK2 24
#define BEF_TT_HAND_GESTURE_SWEAR 25
#define BEF_TT_HAND_GESTURE_HOLDFACE 26
#define BEF_TT_HAND_GESTURE_SALUTE 27
#define BEF_TT_HAND_GESTURE_SPREAD 28
#define BEF_TT_HAND_GESTURE_PRAY 29
#define BEF_TT_HAND_GESTURE_QIGONG 30
#define BEF_TT_HAND_GESTURE_SLIDE 31
#define BEF_TT_HAND_GESTURE_PALM_DOWN 32
#define BEF_TT_HAND_GESTURE_PISTOL2 33
#define BEF_TT_HAND_GESTURE_NARUTO1 34
#define BEF_TT_HAND_GESTURE_NARUTO2 35
#define BEF_TT_HAND_GESTURE_NARUTO3 36
#define BEF_TT_HAND_GESTURE_NARUTO4 37
#define BEF_TT_HAND_GESTURE_NARUTO5 38
#define BEF_TT_HAND_GESTURE_NARUTO7 39
#define BEF_TT_HAND_GESTURE_NARUTO8 40
#define BEF_TT_HAND_GESTURE_NARUTO9 41
#define BEF_TT_HAND_GESTURE_NARUTO10 42
#define BEF_TT_HAND_GESTURE_NARUTO11 43
#define BEF_TT_HAND_GESTURE_NARUTO12 44
#define BEF_TT_HAND_GESTURE_RAISE    47


//  {zh} ?????????????????????  {en} Sequence-based action
#define BEF_HAND_SEQ_ACTION_PUNCHING 1
#define BEF_HAND_SEQ_ACTION_CLAPPING 2

#define BEF_MAX_HAND_NUM 2
#define BEF_HAND_KEY_POINT_NUM 22
#define BEF_HAND_KEY_POINT_NUM_EXTENSION 2

//  {zh} ????????????????????????????????????  {en} Static gesture classification subscript array size
#define BEF_TT_HAND_GETURES_STATIC 48

//  {zh} ????????????????????????????????????  {en} Dynamic gesture type subscript array size
#define BEF_TT_HAND_GETURES_SEQ 3


typedef struct bef_ai_hand_st {
    int id;                           // {zh} /< ??????id {en} /< Hand id
    bef_ai_rect rect;                      // {zh} /< ??????????????? {en} /< Hand rectangle frame
    unsigned int action;              // {zh} /< ???????????? bef_hand_types[]???index [0--20) {en} /< Hand movement bef_hand_types [] index [0--20)
    float rot_angle;                  // {zh} /< ????????????????????? ??????????????????????????? {en} /< Hand rotation angle, only hand opening is more accurate
    float score;                      // {zh} /< ????????????????????? {en} /< Hand movement confidence
    float rot_angle_bothhand;  // {zh} /< ???????????? {en} /< Angle between hands
    //  {zh} ???????????????, ?????????????????????????????????0  {en} Hand key points, set to 0 if not detected
    bef_ai_tt_key_point key_points[BEF_HAND_KEY_POINT_NUM];
    //  {zh} ???????????????????????????????????????????????????0  {en} Hand extension point, set to 0 if not detected
    bef_ai_tt_key_point key_points_extension[BEF_HAND_KEY_POINT_NUM_EXTENSION];
    unsigned int seq_action;   //  {zh} 0 ?????????????????????????????????0??? ??????????????????  {en} 0 If no sequence action is set to 0, the others are valid values
    unsigned char *segment;         // {zh} /< ????????????mask ???????????? 0???255 ??????: nullptr {en} /< palm split mask value range 0~ 255 default: nullptr
    int segment_width;              // {zh} /< ??????????????? ??????: 0 {en} /< Palm split width, default: 0
    int segment_height;             // {zh} /< ??????????????? ??????: 0 {en} /< Palm split high, default: 0
} bef_ai_hand, *ptr_bef_ai_hand;

// {zh} / @brief ???????????? {en} @brief test results
typedef struct bef_ai_hand_info_st {
    bef_ai_hand p_hands[BEF_MAX_HAND_NUM];    // {zh} /< ???????????????????????? {en} /< Hand information detected
    int hand_count;                       // {zh} /< ???????????????????????????p_hands ??????????????????hand_count???????????????????????? {en} /< Number of hands detected, p_hands array, only hand_count results are valid;
} bef_ai_hand_info, *ptr_bef_ai_hand_info;

typedef void *bef_ai_hand_sdk_handle;

typedef enum {
    BEF_HAND_REFRESH_FRAME_INTERVAL = 1,      //  {zh} ????????????????????????, ????????????  {en} Set the number of detection refresh frames, temporarily not supported
    BEF_HAND_MAX_HAND_NUM = 2,                //  {zh} ???????????????????????????????????????1????????????????????????2???  {en} Set the maximum number of hands, the default is 1, the current maximum set to 2;
    BEF_HAND_DETECT_MIN_SIDE = 3,             //  {zh} ??????????????????????????????, ??????192  {en} Set the shortest edge length detected, default 192
    BEF_HAND_CLS_SMOOTH_FACTOR = 4,           //  {zh} ?????????????????????????????????0.7??? ???????????????????????????  {en} Set the classification smoothing parameter, the default is 0.7, the larger the value, the more stable the classification
    BEF_HAND_USE_ACTION_SMOOTH = 5,           //  {zh} ???????????????????????????????????????1???????????????????????????????????????????????????0  {en} Set whether to use category smoothing, default 1, use category smoothing; do not use smoothing, set to 0
    BEF_HAND_ALGO_LOW_POWER_MODE = 6,         //  {zh} ????????????????????????????????????????????????  {en} Degradation mode, default to advanced version. If
    BEF_HAND_ALGO_AUTO_MODE = 7,              //  {zh} ????????????????????????????????????????????????  {en} Degradation mode, default to advanced version. If
    //  {zh} ??????????????? HAND_ALGO_AUTO_MODE ????????????????????????????????????????????????????????????  {en} If set to HAND_ALGO_AUTO_MODE mode, the following parameters can be used to set the threshold for algorithm degradation
    BEF_HAND_ALGO_TIME_ELAPSED_THRESHOLD = 8, //  {zh} ?????????????????????????????? 20ms  {en} Algorithm time consumption threshold, default is 20ms
    BEF_HAND_ALGO_MAX_TEST_FRAME = 9,         //  {zh} ?????????????????????????????????????????????, ????????? 150 ???  {en} Set the number of runtime test algorithm execution times, the default is 150 times
    BEF_HAND_IS_USE_DOUBLE_GESTURE = 10,      //  {zh} ????????????????????????????????? ?????????true  {en} Set whether to use two-handed gestures, the default is true
    BEF_HNAD_ENLARGE_FACTOR_REG = 11,         //  {zh} ???????????????????????????????????????????????????  {en} Set the magnification ratio column of the input initial box of the regression model
    BEF_HAND_NARUTO_GESTURE = 12,             //  {zh} ??????????????????????????????????????????false????????????????????????????????????????????????45???????????????  {en} Set to support Naruto gestures, the default is false, if turned on, it supports 45 types of gesture recognition including Naruto
} bef_ai_hand_param_type;

typedef enum {
    BEF_AI_HAND_MODEL_DETECT = 0x0001,       //  {zh} ????????????????????????  {en} Detect hand, must load
    BEF_AI_HAND_MODEL_BOX_REG = 0x0002,      //  {zh} ???????????????????????????  {en} Detect handframe, must be loaded
    BEF_AI_HAND_MODEL_GESTURE_CLS = 0x0004,  //  {zh} ?????????????????????  {en} Gesture classification, optional
    BEF_AI_HAND_MODEL_KEY_POINT = 0x0008,    //  {zh} ?????????????????????  {en} Hand key points, optional
    BEF_AI_HAND_MODEL_SEGMENT = 0x0010,    //  {zh} ?????????????????????  {en} Visibility point, optional
    BEF_AI_HAND_MODEL_KEY_POINT_3D = 0x0020, //  {zh} 3D??????????????????  {en} 3D key points, optional
    BEF_AI_HAND_MODEL_LEFTRIGHT = 0x0040,    //  {zh} ????????????????????????  {en} Left and right hand classification, optional
    BEF_AI_HAND_MODEL_RING = 0x0080,  //  {zh} ???????????????????????????  {en} Gesture fusion model, optional
} bef_ai_hand_model_type;


/** {zh} 
 * @brief ???????????????????????????
 * @param [out] handle Created hand detect handle
 *                     ???????????????????????????
 * @param [unsigned int] ????????????
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         ???????????? BEF_RESULT_SUC, ???????????????????????????, ??????????????? bef_effect_ai_public_public_define.h
 */
/** {en} 
 * @brief Create the handle of face detection
 * @param  [out] handle Created hand detection handle
 *                      created hand detection handle
 * @param  [unsigned int] currently invalid
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *          successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hand_detect_create(
                              bef_ai_hand_sdk_handle *handle,
                              unsigned int config
                              );

/** {zh} 
 * @brief ??????????????????
 * @param [in] handle Created hand detect handle
 *                    ??????????????????????????????
 * @param [in] image Image base address
 *                   ???????????????????????????
 * @param [in] pixel_format Pixel format of input image
 *                          ?????????????????????
 * @param [in] image_width  Image width
 *                          ????????????????????? (??????????????????)
 * @param [in] image_height Image height
 *                          ????????????????????? (??????????????????)
 * @param [in] image_stride Image stride in each row
 *                          ?????????????????????????????? (??????????????????)
 * @param [in] orientation Image orientation
 *                         ??????????????????????????????????????? bef_effect_ai_public_public_define.h ?????? bef_ai_rotate_type
 * @param [in] detection_config ??????????????????????????? hand_model_type ?????????????????????????????????HAND_MODEL_GESTURE_CLS ??? HAND_MODEL_KEY_POINT ????????????
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_public_define.h
 *         ???????????? BEF_RESULT_SUC, ???????????????????????????, ??????????????? bef_effect_ai_public_public_define.h
 */
/** {en} 
 * @brief Input detection picture
 * @param  [in] Handle Created hand detection handle
 *                    Created hand detection handle
 * @param  [in] Image base address
 *                   Data pointer of the input picture
 * @param  [in] pixel_format Pixel format of input image
 *                          Format of the input picture
 * @param  [in] image_width Image width
 *                          Width of the input image in pixels
 * @param  [in] image_height Image height
 *                          Height of the input image in pixels
 * @param  [in] image_stride Image stride in each row
 *                          Step size of each row of the input image in pixels
 * @param  [in] orientation Image orientation
 *                         Steering of the input image, please refer to the bef_ai_rotate_type in bef_effect_ai_public_public_define h
 * @param  [in] detection_config Request detection module, for hand_model_type bitwise and operation, only HAND_MODEL_GESTURE_CLS and HAND_MODEL_KEY_POINT are currently optional
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_public_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hand_detect(
                       bef_ai_hand_sdk_handle handle,
                       const unsigned char *image,
                       bef_ai_pixel_format pixel_format,
                       int image_width,
                       int image_height,
                       int image_stride,
                       bef_ai_rotate_type orientation,
                       unsigned long long detection_config,
                       bef_ai_hand_info *p_hand_info,
                       int delayframecount
                       );

BEF_SDK_API bef_effect_result_t
bef_effect_ai_hand_detect_setmodel(bef_effect_handle_t handle,
                                   bef_ai_hand_model_type type,
                                   const char * strModelPath);


BEF_SDK_API bef_effect_result_t
bef_effect_ai_hand_detect_setparam(bef_effect_handle_t handle,
                                   bef_ai_hand_param_type type,
                                   float value);


/** {zh} 
 * @param [in] handle Destroy the created hand detect handle
 *                    ?????????????????????????????????
 */
/** {en} 
 * @param [In] Handle Destroy the created hand detection handle
 *                    Destroy the created hand detection handle
 */
BEF_SDK_API void
bef_effect_ai_hand_detect_destroy(
                            bef_ai_hand_sdk_handle handle
                               );


/** {zh} 
 * @brief ??????????????????
 * @param [in] handle Created hand detect handle
 *                    ??????????????????????????????
 * @param [in] license ?????????????????????
 * @param [in] length  ???????????????????????????
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_public_define.h
 *         ???????????? BEF_RESULT_SUC, ????????????????????? BEF_RESULT_INVALID_LICENSE ????????????????????????????????????, ??????????????? bef_effect_ai_public_public_define.h
 */
/** {en} 
 * @brief Hand detection authorization
 * @param  [in] handle Created hand detection handle
 *                    Created hand detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_public_define h
 *         Successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_public_define for details.
 */

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_hand_check_license(JNIEnv* env, jobject context,
        bef_effect_handle_t handle, const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_hand_check_license(bef_effect_handle_t handle,
        const char *licensePath);
#endif
#endif

BEF_SDK_API bef_effect_result_t
bef_effect_ai_hand_check_online_license(bef_effect_handle_t handle,
                                        const char *licensePath);


#endif // _BEF_EFFECT_FACE_DETECT_H_
