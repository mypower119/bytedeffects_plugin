//
// Created by qun on 2020/8/14.
//

#ifndef ANDROIDDEMO_BEF_EFFECT_AI_VIDEO_CLS_H
#define ANDROIDDEMO_BEF_EFFECT_AI_VIDEO_CLS_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include <jni.h>
#endif

#include "bef_effect_ai_public_define.h"

typedef unsigned long long bef_ai_video_cls_handle;

/** {zh} 
 * @brief 模型参数类型
 *
 */
/** {en} 
 * @brief Model parameter type
 *
 */
typedef enum {
    BEF_AI_kVideoClsEdgeMode = 1,        // {zh} /< TODO: 根据实际情况修改 {en} /< TODO: Modify according to the actual situation
} bef_ai_video_cls_param_type;


/** {zh} 
 * @brief 模型枚举，有些模块可能有多个模型
 *
 */
/** {en} 
 * @brief Model enumeration, some modules may have multiple models
 *
 */
typedef enum {
    BEF_AI_kVideoClsModel1 = 1,          // {zh} /< TODO: 根据实际情况更改 {en} /< TODO: Change according to actual situation
} bef_ai_video_cls_model_type;


/** {zh} 
 * @brief 封装预测接口的输入数据
 *
 * @note 不同的算法，可以在这里添加自己的数据
 */
/** {en} 
 * @brief Encapsulates the input data of the prediction interface
 *
 * @note Different algorithms, you can add your own data here
 */
typedef struct {
    bef_ai_base_args *bases;           // {zh} /< 对视频帧数据做了基本的封装 {en} /< Basic encapsulation of video frame data
    int is_last; // {zh} 是否为最后一帧 {en} Is it the last frame
} bef_ai_video_cls_args;


typedef struct {
    int id; // {zh} 类别id {en} Category id
    float confidence; // {zh} 类别的置信度 {en} Category confidence
    float thres; // {zh} 类别的默认阈值 {en} Default threshold for categories
} bef_ai_video_cls_type;


/** {zh} 
 * @brief 封装预测接口的返回值
 *
 * @note 不同的算法，可以在这里添加自己的自定义数据
 */
/** {en} 
 * @brief Encapsulates the return value of the prediction interface
 *
 * @note  different algorithms, you can add your own custom data here
 */
typedef struct {
    //  {zh} 下面只做举例，不同的算法需要单独设置  {en} The following is only an example, different algorithms need to be set separately
    bef_ai_video_cls_type* classes;// {zh} 内存由sdk分配，由sdk释放 {en} Memory allocated by sdk, freed by sdk
    int n_classes;
} bef_ai_video_cls_ret;

/** {zh} 
 * @brief 封装预测接口的返回值
 *
 * @note 不同的算法，可以在这里添加自己的自定义数据
 */
/** {en} 
 * @brief Encapsulates the return value of the prediction interface
 *
 * @note  different algorithms, you can add your own custom data here
 */
typedef struct {
    float* feat;// {zh} 内存由sdk分配，由sdk释放 {en} Memory allocated by sdk, freed by sdk
    int len_feat;
} bef_ai_video_cls_feat;

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_create(bef_ai_video_cls_handle *handle);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_check_license(bef_ai_video_cls_handle handle, const char *licensePath);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_check_online_license(bef_ai_video_cls_handle handle, const char *licensePath);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_detect(bef_ai_video_cls_handle handle,
                                                    bef_ai_video_cls_args *args,
                                                    bef_ai_video_cls_ret *result);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_set_model(bef_ai_video_cls_handle handle, bef_ai_video_cls_model_type type, const char *modelPath);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_set_paramF(bef_ai_video_cls_handle handle, bef_ai_video_cls_param_type type, float value);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_set_paramS(bef_ai_video_cls_handle handle, bef_ai_video_cls_param_type type, char *value);

BEF_SDK_API
bef_effect_result_t bef_effect_ai_video_cls_release(bef_ai_video_cls_handle handle);

#endif //ANDROIDDEMO_BEF_EFFECT_AI_VIDEO_CLS_H
