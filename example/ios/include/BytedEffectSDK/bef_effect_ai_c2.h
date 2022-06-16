//
// Created by qun on 2020/8/14.
//

#ifndef ANDROIDDEMO_BEF_EFFECT_AI_C2_H
#define ANDROIDDEMO_BEF_EFFECT_AI_C2_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include <jni.h>
#endif

#include "bef_effect_ai_public_define.h"

typedef unsigned  long long bef_ai_c2_handle;

typedef struct {
    int id;                     // id
    float confidence;           //  {zh} 置信度  {en} Confidence
    float thres;                //  {zh} 置信阈值  {en} Confidence threshold
    bool satisfied;             //  {zh} 是否检测到  {en} Whether detected
} bef_ai_c2_category_item;

/** {zh} 
 * @brief 模型参数类型
 *
 */
/** {en} 
 * @brief Model parameter type
 *
 */
typedef enum {
    BEF_AI_C2_USE_VIDEO_MODE,   // {zh} 默认值为1，表示视频模式, 0:图像模式 {en} The default value is 1, which means video mode, 0: image mode
    BEF_AI_C2_USE_MultiLabels,  //  {zh} 1: 使用多标签，0：不使用多标签  {en} 1: Use multiple tags, 0: Do not use multiple tags
} bef_ai_c2_param_type;


/** {zh} 
 * @brief 模型枚举，有些模块可能有多个模型
 *
 */
/** {en} 
 * @brief Model enumeration, some modules may have multiple models
 *
 */
typedef enum {
    BEF_AI_kC2Model1 = 1,
} bef_ai_c2_model_type;

/** {zh} 
 * @brief 封装预测接口的返回值
 */
/** {en} 
 * @brief Encapsulates the return value of the predictive interface
 */
typedef struct {
    bef_ai_c2_category_item *items;         //  {zh} 类别信息  {en} Category information
    int n_classes;                          //  {zh} 数量  {en} Quantity
} bef_ai_c2_ret;


BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_create(bef_ai_c2_handle *handle);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_check_license(bef_ai_c2_handle handle, const char *licensePath);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_check_online_license(bef_ai_c2_handle handle, const char* licensePath);

BEF_SDK_API
bef_ai_c2_ret *bef_effect_ai_c2_init_ret(bef_ai_c2_handle handle);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_detect(bef_ai_c2_handle handle,
                                            const unsigned char *image,
                                            bef_ai_pixel_format pixelFormat,
                                            int imageWidth,
                                            int imageHeight,
                                            int imageStride,
                                            bef_ai_rotate_type rotation,
                                            bef_ai_c2_ret *result);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_set_model(bef_ai_c2_handle handle, bef_ai_c2_model_type type, const char *modelPath);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_set_paramF(bef_ai_c2_handle handle, bef_ai_c2_param_type type, float value);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_set_paramS(bef_ai_c2_handle handle, bef_ai_c2_param_type type, char *value);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_release(bef_ai_c2_handle handle);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_c2_release_ret(bef_ai_c2_handle handle, bef_ai_c2_ret *ret);

#endif //ANDROIDDEMO_BEF_EFFECT_AI_C2_H
