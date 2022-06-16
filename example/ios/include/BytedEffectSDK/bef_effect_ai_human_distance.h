//
//  {zh} Created by 王柳 on 2019/6/27.  {en} Created by Wang Liu on 2019/6/27.
//

#ifndef ANDROIDDEMO_BEF_EFFECT_AI_HUMAN_DIATANCE_H
#define ANDROIDDEMO_BEF_EFFECT_AI_HUMAN_DIATANCE_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif
#include "bef_effect_ai_public_define.h"
#include "bef_effect_ai_face_detect.h"
#include "bef_effect_ai_face_attribute.h"
/* {zh} 
 *@brief 距离检测结果结构体
 *@param
 *      face_count 有效的人脸个数
**//* {en} 
 *@brief Distance detection result structure
 *@param
 *      face_count number of valid faces
**/
typedef struct bef_ai_human_distance_result_st {
    float distances[BEF_MAX_FACE_NUM];
    int face_count;                         // {zh} 有效的人脸个数，即表示attr_info中的前face_count个人脸是有效的 {en} The number of valid faces, that is, the first face_count faces in the attr_info are valid
}bef_ai_human_distance_result;

/** {zh} 
 * @brief 距离检测参数类型
 */
/** {en} 
 * @brief Distance detection parameter type
 */
typedef  enum{
    BEF_HumanDistanceEdgeMode,
    BEF_HumanDistanceCameraFov
}bef_ai_human_distance_param_type;

typedef enum {
    BEF_HumanDistanceModel1 = 1

}bef_human_distance_model_type;
/** {zh} 
 * 创建距离检测的句柄
 *@brief 初始化handle
 *@param [out] handle Created face verify handle
 *                     创建的人手检测句柄
 *@return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * Create a handle for distance detection
 *@brief  initialize handle
 *@param  [out] handle Created face verify handle
 *                      created human hand detection handle
 *@return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *          successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_human_distance_create(
        bef_effect_handle_t *handle
);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_human_distance_load_model(
        bef_effect_handle_t handle,
        bef_human_distance_model_type mode_type,
        const char *path
        );

/** {zh} 
 * 设置距离检测参数
 *@brief 初始化后的handle
 *@param [out] handle Created face verify handle
 *                     创建的人手检测句柄
 *
 *@return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * Set the distance detection parameter
 *@brief  initialized handle
 *@param  [out] handle Created face verify handle
 *                      created manual detection handle
 *
 *@return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *          successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_human_distance_setparam(
        bef_effect_handle_t handle,
        bef_ai_human_distance_param_type  param_type,
        float value

);

/** {zh} 
 * @brief 距离检测
 * @param [in] handle Created face attribute detect handle
 *                    已创建的距离检测句柄
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
 * @param [in] ptr_base_info 人脸检测结果
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_base_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
/** {en} 
 * @brief Distance detection
 * @param  [in] Handle Created face attribute detecting handle
 *                    Created distance detection handle
 * @param  [in] Image base address
 *                   Data pointer of the input image
 * @param  [in] pixel_format Pixel format of input image
 *                          Format of the input image
 * @param  [in] image_width Image width
 *                          Width of the input image in pixels
 * @param  [in] image_height Image height
 *                          Height of the input image in pixels
 * @param  [in] image_stride Image stride in each row
 *                          Step size of each row of the input image in pixels
 * @param  [in] ptr_base_info Face detection result
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_base_define h
 *         Success returns BEF_RESULT_SUC, failure returns the corresponding error code, please refer to bef_effect_base_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_human_distance_detect(
        bef_effect_handle_t handle,
        const unsigned char *src_image_data,
        bef_ai_pixel_format pixel_format,
        int width,
        int height,
        int image_stride,
        bef_ai_rotate_type orientation,
        const bef_ai_face_info *ptr_base_info,
        const bef_ai_face_attribute_result *ptr_attr_info,
        bef_ai_human_distance_result *ptr_human_distance_info
);

/** {zh} 
 * @brief 距离检测
 * @param [in] handle Created face attribute detect handle
 *                    已创建的距离检测句柄
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
 * @param [in] device_name 设备名称
 * @param [in] ptr_base_info 人脸检测结果
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_base_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
/** {en} 
 * @brief Distance detection
 * @param  [in] Handle Created face attribute detecting handle
 *                    Created distance detection handle
 * @param  [in] Image base address
 *                   Data pointer of the input image
 * @param  [in] pixel_format Pixel format of input image
 *                          Format of the input image
 * @param  [in] image_width Image width
 *                          Width of the input image in pixels
 * @param  [in] image_height Image height
 *                          Height of the input image in pixels
 * @param  [in] image_stride Image stride in each row
 *                          Step size of each row of the input image in pixels
 * @param  [in] device_name Device name
 * @param  [in] ptr_base_info Face detection result
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_base_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_base_define
 */
BEF_SDK_API
bef_effect_result_t
bef_effect_ai_human_distance_detect_V2(
        bef_effect_handle_t handle,
        const unsigned char *src_image_data,
        bef_ai_pixel_format pixel_format,
        int width,
        int height,
        int image_stride,
        const char *device_name,
        bool is_front,
        bef_ai_rotate_type orientation,
        const bef_ai_face_info *ptr_base_info,
        const bef_ai_face_attribute_result *ptr_attr_info,
        bef_ai_human_distance_result *ptr_human_distance_info
);

/** {zh} 
 * @param [in] handle Destroy the created human distance detect handle
 *                    销毁创建的距离估计检测句柄
 */
/** {en} 
 * @param Destroy the created human distance detecting handle handle Destroy the created human distance detect handle
 *                    销毁创建的距离估计检测句柄
 */
BEF_SDK_API void
bef_effect_ai_human_distance_destroy(
        bef_effect_handle_t handle
);

/** {zh} 
 * @brief 距离检测授权
 * @param [in] handle Created face attribute detect handle
 *                    已创建的距离检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Distance detection authorization
 * @param  [in] handle Created face attribute detection handle
 *                    Created distance detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         Successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_define for details.
 */
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_human_distance_check_license(JNIEnv* env,
                                                                           jobject context, bef_effect_handle_t handle, const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_human_distance_check_license(bef_effect_handle_t handle,
        const char *licensePath);
#endif
#endif


BEF_SDK_API bef_effect_result_t
bef_effect_ai_human_distance_check_online_license(bef_effect_handle_t handle,
        const char *licensePath);


#endif //ANDROIDDEMO_BEF_EFFECT_AI_HUMAN_DIATANCE_H
