//
// Created by QunZhang on 2020/5/19.
//

#ifndef ANDROIDDEMO_BEF_EFFECT_AI_DYNAMIC_ACTION_H
#define ANDROIDDEMO_BEF_EFFECT_AI_DYNAMIC_ACTION_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include <jni.h>
#endif

#include "bef_effect_ai_public_define.h"

#define BEF_AI_DYNAMIC_ACTION_MAX_PERSON_NUM_ALLOWED 20
#define BEF_AI_DYNAMIC_ACTION_PERSON_KEY_POINT_NUM 18 // skeleton

//  {zh} 人检测的返回结构体  {en} Return structure of human detection
//  {zh} 结构体有默认值 调用方需要根据返回值是否是默认值 判断是否有相应的检测结果  {en} The structure has a default value, and the caller needs to judge whether there is a corresponding detection result according to whether the return value is the default value
typedef struct bef_ai_dynamic_action_info_st {
    int id;                       // {zh} /< 人的id，track_id {en} /< Human id, track_id
    int person_id;                // {zh} /< 人的id，来自于skeleton {en} /< Human id comes from skeleton
    bef_ai_rect rect;                  // {zh} /< 人矩形框 默认: 0 {en} /< Person rectangle box, default: 0
    bef_ai_rect rect_stl;              // {zh} /< 人矩形框 默认: 0 {en} /< Person rectangle box, default: 0
    unsigned int action;          // {zh} /< 动态类别, 默认: 0 {en} /< Dynamic category, default: 0
    unsigned int action_duration; // {zh} /< 动态类别的中间停留帧数, 默认: 0 {en} /< The number of frames in the middle of the dynamic category, default: 0
    float action_score;           // {zh} /< 动态类别置信度 默认: 0 {en} /< Dynamic category confidence, default: 0
} bef_ai_dynamic_action_info, *p_bef_ai_dynamic_action_info;


typedef struct bef_ai_dynamic_action_sk_info_st {
    int id;                                                                     //  {zh} 人的 id  {en} Human id
    bef_ai_rect rect;                                                           //  {zh} 人体框  {en} Body frame
    bef_ai_tt_key_point key_points[BEF_AI_DYNAMIC_ACTION_PERSON_KEY_POINT_NUM]; //  {zh} 人体关键点  {en} Human body key points
} bef_ai_dynamic_action_sk_info;

// dynamic action from skeleton
#define BEF_AI_DYNAMIC_ACTION_NO_ACTION 0            //  {zh} NoAction: 无动作  {en} NoAction: No Action
#define BEF_AI_DYNAMIC_ACTION_PUSH_UP 1              //  {zh} PushUp: 俯卧撑  {en} PushUp: Push-ups
#define BEF_AI_DYNAMIC_ACTION_SIT_UP 2               //  {zh} SitUp: 仰卧起坐  {en} SitUp: Sit-ups
#define BEF_AI_DYNAMIC_ACTION_ROW_FAST 3             //  {zh} RowFast: 半身快速划船  {en} RowFast: Half-body fast rowing
#define BEF_AI_DYNAMIC_ACTION_ROW_SLOW 4             //  {zh} RowSlow: 半身慢速划船  {en} RowSlow Rowing
#define BEF_AI_DYNAMIC_ACTION_SQUAT_FRONT 5          //  {zh} SquatFront: 正面下蹲  {en} SquatFront: Front Squat
#define BEF_AI_DYNAMIC_ACTION_ROW_SLOW_FULL 6        //  {zh} RowSlowFull: 全身慢速划船  {en} RowSlowFull: Full body slow rowing
#define BEF_AI_DYNAMIC_ACTION_ROW_FAST_FULL 7        //  {zh} RowFastFull: 全身快速划船  {en} RowFastFull: Full-body fast rowing
#define BEF_AI_DYNAMIC_ACTION_JUMP_JACK 8            //  {zh} JumpJack: 开合跳  {en} JumpJack: Open and close jump
#define BEF_AI_DYNAMIC_ACTION_SQUAT_PROFILE 9        //  {zh} SquatProfile: 侧面下蹲  {en} SquatProfile: Side Squat

// {zh} / @brief 检测结果 {en} @brief test results
typedef struct bef_ai_dynamic_action_result_st {
    //  {zh} 检测到的人信息  {en} Detected person information
    bef_ai_dynamic_action_info p_persons[BEF_AI_DYNAMIC_ACTION_MAX_PERSON_NUM_ALLOWED];
    //  {zh} 检测到的人数目，p_persons 数组中，只有前person_count个结果是有效的，后面的是无效  {en} Number of people detected, p_persons array, only the first person_count results are valid, the latter are invalid
    int person_count;

} bef_ai_dynamic_action_result, *p_bef_ai_dynamic_action_result;

typedef struct bef_ai_dynamic_action_sk_st {
    bef_ai_dynamic_action_sk_info sk_infos[BEF_AI_DYNAMIC_ACTION_MAX_PERSON_NUM_ALLOWED];
    int person_count;
} bef_ai_dynamic_action_sk;

typedef enum {
    BEF_AI_DYNAMIC_ACTION_REFRESH_FRAME_INTERVAL = 1,      //  {zh} 设置检测刷新帧数, 暂不支持  {en} Set the number of detection refresh frames, temporarily not supported
    BEF_AI_DYNAMIC_ACTION_MAX_PERSON_NUM = 2,              //  {zh} 设置最多人的个数，默认为1，目前最多设置为20；  {en} Set the maximum number of people, the default is 1, the current maximum set to 20;
} bef_ai_dynamic_action_param_type;

typedef enum {
    BEF_AI_DYNAMIC_ACTION_MODEL_SK = 0x0001,               //  {zh} 人体skeleton模型  {en} Human skeleton model
    BEF_AI_DYNAMIC_ACTION_MODEL_DETECT = 0x0002,           //  {zh} 人体detection模型 (TODO)  {en} Human detection model (TODO)
    BEF_AI_DYNAMIC_ACTION_MODEL_DYNAMIC_ACTION = 0x0004,   //  {zh} 动态姿态模型 (TODO)  {en} Dynamic Attitude Model (TODO)
} bef_ai_dynamic_action_model_type;                        //  {zh} TODO: 其实这里以需要加载的能力为划分更好  {en} TODO: In fact, it is better to divide the ability to load here

BEF_SDK_API bef_effect_result_t
bef_effect_ai_dynamic_action_create(
        bef_effect_handle_t *handle,
        unsigned int config
);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_dynamic_action_set_param(
        bef_effect_handle_t handle,
        bef_ai_dynamic_action_param_type type,
        float value
);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_dynamic_action_load_model(
        bef_effect_handle_t handle,
        bef_ai_dynamic_action_model_type type,
        const char *model_path
);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_dynamic_action_detect(
        bef_effect_handle_t handle,
        const unsigned char *image,
        bef_ai_pixel_format pixel_format,
        int image_width,
        int image_height,
        int image_stride,
        bef_ai_rotate_type orientation,
        unsigned long long detect_config,
        int delay_framecount,
        bef_ai_dynamic_action_result *result,
        bef_ai_dynamic_action_sk *sk_result
);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_dynamic_action_release(
        bef_effect_handle_t handle
);

/** {zh} 
 * @brief 通用物体检测授权
 * @param [in] handle Created hand detect handle
 *                    已创建的人手检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_public_define.h
 */
/** {en} 
 * @brief General object detection authorization
 * @param  [in] handle Created hand detection handle
 *                    created hand detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_public_define h
 *         successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_public_define for details.
 */

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_dynamic_action_check_license(JNIEnv* env, jobject context,
        bef_effect_handle_t handle, const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_dynamic_action_check_license(bef_effect_handle_t handle,
        const char *licensePath);
#endif
#endif

#endif //ANDROIDDEMO_BEF_EFFECT_AI_DYNAMIC_ACTION_H
