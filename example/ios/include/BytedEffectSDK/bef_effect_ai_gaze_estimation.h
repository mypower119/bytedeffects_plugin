// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#ifndef BEF_EFFECT_AI_GAZE_ESTIMATION_H
#define BEF_EFFECT_AI_GAZE_ESTIMATION_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include <jni.h>
#endif

#include "bef_effect_ai_public_define.h"
#include "bef_effect_ai_face_detect.h"

typedef unsigned long long bef_ai_gaze_handle;

typedef struct bef_ai_gaze_info_base
{
    unsigned long face_id;
    bool valid;
    float head_r[3], head_t[3];
    float leye_pos[3], reye_pos[3];
    float leye_gaze[3], reye_gaze[3], mid_gaze[3];
    float leye_pos2d[2], reye_pos2d[2];
    float leye_gaze2d[2], reye_gaze2d[2]; // 2d point on screen of gaze end point
} bef_ai_gaze_info_base;

/** {zh} 
 * @brief 模型参数类型
 * BEF_GAZE_ESTIMATION_CAMERA_FOV          : 相机Field of View，默认60度
 * BEF_GAZE_ESTIMATION_DIVERGENCE           : 双眼视线发散度，设置范围  [-inf, inf]，默认0
 *                                0表示双眼3D视线汇聚一点，由于空间近大远小的关系，此时投影至2D空间中时视线是平行的
 *                                1表示双眼3D视线平行，此时投影至2D空间中时视线是发散的。
 */
/** {en} 
 * @brief Model parameter type
 * BEF_GAZE_ESTIMATION_CAMERA_FOV: Camera Field of View, default 60 degrees
 * BEF_GAZE_ESTIMATION_DIVERGENCE: binocular line of sight divergence, set range [-inf, inf], default 0
 *                                0 indicates that the binocular 3D line of sight converges a little, due to the space near the large far small relationship, At this time, when projected into 2D space, the line of sight is parallel
 *                                1 indicates that the binocular 3D line of sight is parallel, when projected into 2D space, the line of sight is divergent.
 */
typedef enum
{
    BEF_GAZE_ESTIMATION_EDGE_MODE = 1,
    BEF_GAZE_ESTIMATION_CAMERA_FOV,
    BEF_GAZE_ESTIMATION_DIVERGENCE,
} bef_ai_gaze_estimation_param_type;

/** {zh} 
 * @brief 模型枚举，有些模块可能有多个模型
 *
 */
/** {en} 
 * @brief Model enumeration, some modules may have multiple models
 *
 */
typedef enum
{
    BEF_GAZE_ESTIMATION_MODEL1 = 1,
} bef_gaze_estimation_model_type;


/** {zh} 
 * @brief 预测接口的返回值
 */
/** {en} 
 * @brief Predict the return value of the interface
 */
typedef struct
{
    bef_ai_gaze_info_base* eye_infos; // eye information, includes eye positions, gaze
    int face_count;
} bef_ai_gaze_estimation_info;

BEF_SDK_API bef_effect_result_t
bef_effect_ai_gaze_estimation_create_handle(bef_ai_gaze_handle* handle);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_gaze_estimation_init_model(bef_ai_gaze_handle handle,
                                         bef_gaze_estimation_model_type modelType,
                                         const char* modelPath);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_gaze_estimation_set_paramf(bef_ai_gaze_handle handle,
                                         bef_ai_gaze_estimation_param_type type,
                                         float value);

/** {zh} 
 * @brief 封装预测接口的输入数据
 * bef_ai_face_info *faceInfo     : 人脸检测结果
 * float LineLen                 : 视线长度，0为无限长
 */
/** {en} 
 * @brief Encapsulates the input data of the prediction interface
 * bef_ai_face_info * faceInfo: face detection result
 * float LineLen: line of sight length, 0 is infinite length
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_gaze_estimation_detect(bef_ai_gaze_handle handle,
                                     const unsigned char* image,
                                     bef_ai_pixel_format pixel_format,
                                     int image_width,
                                     int image_height,
                                     int image_stride,
                                     bef_ai_rotate_type orientation,
                                     const bef_ai_face_info* faceInfo,
                                     float lineLen,
                                     bef_ai_gaze_estimation_info* gaze_info);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_gaze_estimation_destroy(bef_ai_gaze_handle handle);

BEF_SDK_API bef_effect_result_t bef_effect_ai_gaze_estimation_check_license(bef_ai_gaze_handle handle, const char* licensePath);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_gaze_estimation_check_online_license(bef_ai_gaze_handle handle, const char* licensePath);
#endif //BEF_EFFECT_AI_GAZE_ESTIMATION_H
