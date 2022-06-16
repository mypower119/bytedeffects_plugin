// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#ifndef BEF_EFFECT_AI_HAIRPARSER_H
#define BEF_EFFECT_AI_HAIRPARSER_H

#include "bef_effect_ai_public_define.h"

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif



/** {zh} 
 * @brief 创建句柄
 * @param [out] handle    Created hairparser handle
 *                        创建的骨骼句柄
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Create handle
 * @param  [out] Handle Created hairparser handle
 *                        Created skeleton handle
 * @return If succeed returns BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Success returns BEF_RESULT_SUC, failure returns the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_create(
                                bef_effect_handle_t *handle
                                );

/* {zh} 
 * @brief 从文件初始化模型参数
 **/
/* {en} 
 * @brief Initialize model parameters from a file
 **/

BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_init_model(
                                    bef_effect_handle_t handle,
                                    const char* param_path);

/* {zh} 
 * @brief 设置SDK参数
 * net_input_width 和 net_input_height
 * 表示神经网络的传入，一般情况下不同模型不太一样
 * 此处（HairParser）传入值约定为 net_input_width = 192, net_input_height = 336
 * use_tracking: 算法时的参数，目前传入 true 即可
 * use_blur: 算法时的参数, 目前传入 true 即可
 **/
/* {en} 
 * @brief Setting SDK parameters
 * net_input_width and net_input_height
 *  represents the incoming neural network, which is generally different from different models
 *  Here (HairParser) the incoming value is agreed to be net_input_width = 192, net_input_height = 336
 * use_tracking: The parameters of the algorithm are currently passed in true
 * use_blur: The parameters of the algorithm are currently passed in true
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_set_param(
                                   bef_effect_handle_t handle,
                                   int net_input_width,
                                   int net_input_height,
                                   bool use_tracking,
                                   bool use_blur);

/* {zh} 
 * * @brief 获取输出mask shape
* output_width, output_height, channel 用于得到 bef_effect_ai_hairparser_do_detect 接口输出的
* alpha 大小 如果在 bef_effect_ai_hairparser_set_param 的参数中，net_input_width，net_input_height
* 已按约定传入，即 net_input_width = 192, net_input_height = 336
* channel 始终返回 1
 */
/* {en} 
 * * @brief Gets the output mask shape
* output_width, output_height, channel is used to obtain the
* alpha size of the output of the bef_effect_ai_hairparser_do_detect interface. If in the bef_effect_ai_hairparser_set_param parameters, net_input_width, net_input_height
*  has been passed in as agreed, that is, net_input_width = 192, net_input_height = 336
* channel always returns 1
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_get_output_shape(bef_effect_handle_t handle,
                      int* output_width,
                      int* output_height,
                      int* channel);


/* {zh} 
 * @brief 进行抠图操作
 * @note  注意dst_alpha_data 空间需要外部分配
 * src_image_data 为传入图片的大小，图片大小任意
 * pixel_format， width, height, image_stride 为传入图片的信息
 **/
/* {en} 
 * @brief Perform matting operation
 * @note   note dst_alpha_data  space needs external allocation
 * src_image_data is the size of the incoming picture, the size of the picture is arbitrary
 * pixel_format, width, height, image_stride is the information of the incoming picture
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_do_detect(
                                   bef_effect_handle_t handle,
                                   const unsigned char* src_image_data,
                                   bef_ai_pixel_format pixel_format,
                                   int width,
                                   int height,
                                   int image_stride,
                                   bef_ai_rotate_type orient,
                                   unsigned char* dst_alpha_data,
                                   bool need_flip_alpha);


/* {zh} 
 * @brief 释放句柄
 **/
/* {en} 
 * @brief Release handle
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_destroy(bef_effect_handle_t handle);


/** {zh} 
 * @brief 头发分割授权
 * @param [in] handle Created hairparser  handle
 *                    已创建的骨骼检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Hair split authorization
 * @param  [in] handle Created hairparser handle
 *                    Created bone detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         Successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_define for details.
 */

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_hairparser_check_license(JNIEnv* env, jobject context, bef_effect_handle_t handle, const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_hairparser_check_license(bef_effect_handle_t handle, const char *licensePath);
#endif
#endif

BEF_SDK_API bef_effect_result_t
bef_effect_ai_hairparser_check_online_license(bef_effect_handle_t handle, const char *licensePath);
#endif // BEF_EFFECT_AI_HAIRPARSER_H

