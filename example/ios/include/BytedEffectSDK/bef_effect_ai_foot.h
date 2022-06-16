// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#ifndef _BEF_EFFECT_FOOT_DETECT_AI_H_
#define _BEF_EFFECT_FOOT_DETECT_AI_H_


#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"

#define BEF_MAX_FEET_NUM 2
#define BEF_FEET_KEY_POINT_NUM 66


typedef struct bef_ai_foot_st {
  int id; // id
  bef_ai_rect box; //  {zh} 脚框  {en} Foot frame
  float left_prob; //  {zh} 脚是左脚的概率  {en} The probability that the foot is the left foot
  float foot_prob; //  {zh} 是脚的概率  {en} Is the probability of feet
  bef_ai_tt_key_point joints2d[BEF_FEET_KEY_POINT_NUM]; //  {zh} 脚的2d关键点，66x2  {en} 2D key point of the foot, 66x2
  unsigned char* segment; //  {zh} 腿部的分割  {en} Leg segmentation
  bef_ai_rect segment_box; //  {zh} 腿部分割的框  {en} Frame for leg segmentation
  float trans[12]; //  {zh} 脚的3d姿态的旋转矩阵，3x4  {en} Rotation matrix of foot 3d posture, 3x4
} bef_ai_foot, *ptr_bef_ai_foot;


typedef struct bef_ai_foot_ret_st {
  bef_ai_foot p_feet[BEF_MAX_FEET_NUM]; //  {zh} foot 信息  {en} Foot information
  int feet_count; //  {zh} 检出的feet总数  {en} Total number of detected feet
} bef_ai_foot_ret, *ptr_bef_ai_foot_ret;


typedef void *bef_ai_foot_sdk_handle;


/** {zh} 
 * @brief 模型参数类型
 *
 */
/** {en} 
 * @brief Model parameter type
 *
 */
typedef enum {
  BEF_kFootEdgeMode = 1,
}bef_ai_foot_param_type;


/** {zh} 
 * @brief 模型枚举，有些模块可能有多个模型
 *
 */
/** {en} 
 * @brief Model enumeration, some modules may have multiple models
 *
 */
typedef enum  {
  BEF_FootJoints2dModel = 1,
  BEF_FootJoints3dModel = 2,  // {zh} /< 暂时无用 {en} /< Temporarily useless
  BEF_FootDetectionModel = 3,
  BEF_FootFilterModel = 4,
  BEF_FootLeftRightModel = 5,
  BEF_LegSegModel = 6,
}bef_ai_foot_model_type;


BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_detect_create(bef_ai_foot_sdk_handle *handle);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_detect(
                       bef_ai_foot_sdk_handle handle,
                       const unsigned char *image,
                       bef_ai_pixel_format pixel_format,
                       int image_width,
                       int image_height,
                       int image_stride,
                       bef_ai_rotate_type orientation,
                       bef_ai_foot_ret *p_foot_result);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_detect_setmodel(bef_ai_foot_sdk_handle handle,
                                   bef_ai_foot_model_type type,
                                   const char * strModelPath);


BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_detect_setparam(bef_ai_foot_sdk_handle handle,
                                   bef_ai_foot_param_type type,
                                   float value);



BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_render_resolution(bef_ai_foot_sdk_handle handle,
                                     int width,
                                     int height);

BEF_SDK_API bef_ai_foot_ret*
bef_effect_ai_foot_assign_memory(bef_ai_foot_sdk_handle handle);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_release_memory(bef_ai_foot_ret* result);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_foot_detect_destroy(bef_ai_foot_sdk_handle handle);


 /** {zh} 
  * @brief 足部检测授权
  * @param [in] handle Created hand detect handle
  *                    已创建的足部检测句柄
  * @param [in] license 授权文件字符串
  * @param [in] length  授权文件字符串长度
  * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_public_define.h
  *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_public_define.h
  */
 /** {en} 
  * @brief Foot detection authorization
  * @param  [in] handle Created hand detection handle
  *                    Created foot detection handle
  * @param  [in] license authorization file character string
  * @param  [in] length authorization file character string length
  * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_public_define h
  *         Successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_public_define for details.
  */

 #if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
 BEF_SDK_API bef_effect_result_t bef_effect_ai_foot_check_license(JNIEnv* env, jobject context,
         bef_effect_handle_t handle, const char *licensePath);
 #else
 #ifdef __APPLE__
 BEF_SDK_API bef_effect_result_t bef_effect_ai_foot_check_license(bef_effect_handle_t handle,
         const char *licensePath);
 #else
 BEF_SDK_API bef_effect_result_t bef_effect_ai_foot_check_license(bef_effect_handle_t handle,
 const char *licensePath);
 #endif
 #endif


#endif // _BEF_EFFECT_FOOT_DETECT_AI_H_
