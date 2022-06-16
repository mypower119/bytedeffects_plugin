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


//  {zh} 基于序列的动作  {en} Sequence-based action
#define BEF_HAND_SEQ_ACTION_PUNCHING 1
#define BEF_HAND_SEQ_ACTION_CLAPPING 2

#define BEF_MAX_HAND_NUM 2
#define BEF_HAND_KEY_POINT_NUM 22
#define BEF_HAND_KEY_POINT_NUM_EXTENSION 2

//  {zh} 静态手势分类下标数组大小  {en} Static gesture classification subscript array size
#define BEF_TT_HAND_GETURES_STATIC 48

//  {zh} 动态手势类型下标数组大小  {en} Dynamic gesture type subscript array size
#define BEF_TT_HAND_GETURES_SEQ 3


typedef struct bef_ai_hand_st {
    int id;                           // {zh} /< 手的id {en} /< Hand id
    bef_ai_rect rect;                      // {zh} /< 手部矩形框 {en} /< Hand rectangle frame
    unsigned int action;              // {zh} /< 手部动作 bef_hand_types[]的index [0--20) {en} /< Hand movement bef_hand_types [] index [0--20)
    float rot_angle;                  // {zh} /< 手部旋转角度， 仅手张开是比较准确 {en} /< Hand rotation angle, only hand opening is more accurate
    float score;                      // {zh} /< 手部动作置信度 {en} /< Hand movement confidence
    float rot_angle_bothhand;  // {zh} /< 双手夹角 {en} /< Angle between hands
    //  {zh} 手部关键点, 如果没有检测到，则置为0  {en} Hand key points, set to 0 if not detected
    bef_ai_tt_key_point key_points[BEF_HAND_KEY_POINT_NUM];
    //  {zh} 手部扩展点，如果没有检测到，则置为0  {en} Hand extension point, set to 0 if not detected
    bef_ai_tt_key_point key_points_extension[BEF_HAND_KEY_POINT_NUM_EXTENSION];
    unsigned int seq_action;   //  {zh} 0 如果没有序列动作设置为0， 其他为有效值  {en} 0 If no sequence action is set to 0, the others are valid values
    unsigned char *segment;         // {zh} /< 手掌分割mask 取值范围 0～255 默认: nullptr {en} /< palm split mask value range 0~ 255 default: nullptr
    int segment_width;              // {zh} /< 手掌分割宽 默认: 0 {en} /< Palm split width, default: 0
    int segment_height;             // {zh} /< 手掌分割高 默认: 0 {en} /< Palm split high, default: 0
} bef_ai_hand, *ptr_bef_ai_hand;

// {zh} / @brief 检测结果 {en} @brief test results
typedef struct bef_ai_hand_info_st {
    bef_ai_hand p_hands[BEF_MAX_HAND_NUM];    // {zh} /< 检测到的手部信息 {en} /< Hand information detected
    int hand_count;                       // {zh} /< 检测到的手部数目，p_hands 数组中，只有hand_count个结果是有效的； {en} /< Number of hands detected, p_hands array, only hand_count results are valid;
} bef_ai_hand_info, *ptr_bef_ai_hand_info;

typedef void *bef_ai_hand_sdk_handle;

typedef enum {
    BEF_HAND_REFRESH_FRAME_INTERVAL = 1,      //  {zh} 设置检测刷新帧数, 暂不支持  {en} Set the number of detection refresh frames, temporarily not supported
    BEF_HAND_MAX_HAND_NUM = 2,                //  {zh} 设置最多的手的个数，默认为1，目前最多设置为2；  {en} Set the maximum number of hands, the default is 1, the current maximum set to 2;
    BEF_HAND_DETECT_MIN_SIDE = 3,             //  {zh} 设置检测的最短边长度, 默认192  {en} Set the shortest edge length detected, default 192
    BEF_HAND_CLS_SMOOTH_FACTOR = 4,           //  {zh} 设置分类平滑参数，默认0.7， 数值越大分类越稳定  {en} Set the classification smoothing parameter, the default is 0.7, the larger the value, the more stable the classification
    BEF_HAND_USE_ACTION_SMOOTH = 5,           //  {zh} 设置是否使用类别平滑，默认1，使用类别平滑；不使用平滑，设置为0  {en} Set whether to use category smoothing, default 1, use category smoothing; do not use smoothing, set to 0
    BEF_HAND_ALGO_LOW_POWER_MODE = 6,         //  {zh} 降级模式，默认走高级的版本。如果  {en} Degradation mode, default to advanced version. If
    BEF_HAND_ALGO_AUTO_MODE = 7,              //  {zh} 降级模式，默认走高级的版本。如果  {en} Degradation mode, default to advanced version. If
    //  {zh} 如果设置为 HAND_ALGO_AUTO_MODE 模式，则可以以下参数来设置算法降级的阈值  {en} If set to HAND_ALGO_AUTO_MODE mode, the following parameters can be used to set the threshold for algorithm degradation
    BEF_HAND_ALGO_TIME_ELAPSED_THRESHOLD = 8, //  {zh} 算法耗时阈值，默认为 20ms  {en} Algorithm time consumption threshold, default is 20ms
    BEF_HAND_ALGO_MAX_TEST_FRAME = 9,         //  {zh} 设置运行时测试算法的执行的次数, 默认是 150 次  {en} Set the number of runtime test algorithm execution times, the default is 150 times
    BEF_HAND_IS_USE_DOUBLE_GESTURE = 10,      //  {zh} 设置是否使用双手手势， 默认为true  {en} Set whether to use two-handed gestures, the default is true
    BEF_HNAD_ENLARGE_FACTOR_REG = 11,         //  {zh} 设置回归模型的输入初始框的放大比列  {en} Set the magnification ratio column of the input initial box of the regression model
    BEF_HAND_NARUTO_GESTURE = 12,             //  {zh} 设置支持火影忍者手势，默认为false，如果开启，则支持包括火影在内的45类手势识别  {en} Set to support Naruto gestures, the default is false, if turned on, it supports 45 types of gesture recognition including Naruto
} bef_ai_hand_param_type;

typedef enum {
    BEF_AI_HAND_MODEL_DETECT = 0x0001,       //  {zh} 检测手，必须加载  {en} Detect hand, must load
    BEF_AI_HAND_MODEL_BOX_REG = 0x0002,      //  {zh} 检测手框，必须加载  {en} Detect handframe, must be loaded
    BEF_AI_HAND_MODEL_GESTURE_CLS = 0x0004,  //  {zh} 手势分类，可选  {en} Gesture classification, optional
    BEF_AI_HAND_MODEL_KEY_POINT = 0x0008,    //  {zh} 手关键点，可选  {en} Hand key points, optional
    BEF_AI_HAND_MODEL_SEGMENT = 0x0010,    //  {zh} 可见性点，可选  {en} Visibility point, optional
    BEF_AI_HAND_MODEL_KEY_POINT_3D = 0x0020, //  {zh} 3D关键点，可选  {en} 3D key points, optional
    BEF_AI_HAND_MODEL_LEFTRIGHT = 0x0040,    //  {zh} 左右手分类，可选  {en} Left and right hand classification, optional
    BEF_AI_HAND_MODEL_RING = 0x0080,  //  {zh} 手势融合模型，可选  {en} Gesture fusion model, optional
} bef_ai_hand_model_type;


/** {zh} 
 * @brief 创建人脸检测的名柄
 * @param [out] handle Created hand detect handle
 *                     创建的人手检测句柄
 * @param [unsigned int] 目前无效
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_public_define.h
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
 * @brief 传入检测图片
 * @param [in] handle Created hand detect handle
 *                    已创建的人手检测句柄
 * @param [in] image Image base address
 *                   输入图片的数据指针
 * @param [in] pixel_format Pixel format of input image
 *                          输入图片的格式
 * @param [in] image_width  Image width
 *                          输入图像的宽度 (以像素为单位)
 * @param [in] image_height Image height
 *                          输入图像的高度 (以像素为单位)
 * @param [in] image_stride Image stride in each row
 *                          输入图像每一行的步长 (以像素为单位)
 * @param [in] orientation Image orientation
 *                         输入图像的转向，具体请参考 bef_effect_ai_public_public_define.h 中的 bef_ai_rotate_type
 * @param [in] detection_config 请求检测的模块，为 hand_model_type 的按位与操作，目前只有HAND_MODEL_GESTURE_CLS 和 HAND_MODEL_KEY_POINT 是可选的
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_public_define.h
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
 *                    销毁创建的人手检测句柄
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
 * @brief 人手检测授权
 * @param [in] handle Created hand detect handle
 *                    已创建的人手检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_public_define.h
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
