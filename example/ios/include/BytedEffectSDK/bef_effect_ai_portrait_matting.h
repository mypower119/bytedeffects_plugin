// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#ifndef BEF_EFFECT_AI_PORTRAT_MATTING_H
#define BEF_EFFECT_AI_PORTRAT_MATTING_H

#include "bef_effect_ai_public_define.h"

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

/* {zh} 
 * @brief 推荐配置
 **/
/* {en} 
 * @brief Recommended configuration
 **/
//struct bef_ai_recommend_config {
//    int OutputMinSideLen = 128;
//    int FrashEvery = 15;
//    int EdgeMode = 1;
//};
/* {zh} 
 * @brief SDK参数
 * edge_mode:
 *    算法参数，用来设置边界的模式
 *    - 0: 不加边界
 *    - 1: 加边界
 *    - 2: 加边界, 其中, 2 和 3 策略不太一样，但效果上差别不大，可随意取一个
 * fresh_every:
 *    算法参数，设置调用多少次强制做预测，目前设置 15 即可
 * MP_OutputMinSideLen:
 *    返回短边的长度, 默认值为128, 需要为16的倍数；
 * MP_OutputWidth 不设置，只做GetParam 兼容之前的调用
 * MP_OutputHeight 不设置，只做GetParam 兼容之前的接口；
 **/
/* {en} 
 * @brief SDK parameters
 * edge_mode:
 *     algorithm parameters, the mode used to set the boundary
 *    -0: no boundary
 *    -1: add boundary
 *    -2: add boundary, where, 2 and 3 strategies are not the same, but the effect is not much different, you can take a
 * fresh_every:
 *     algorithm parameters, set how many times to call forced prediction, currently set 15 can
 * MP_OutputMinSideLen:
 *     return the length of the short side, the default value is 128, need to be a multiple of 16;
 * MP_OutputWidth not set, only do calls before GetParam compatibility
 * MP_OutputHeight not set, only do interfaces before GetParam compatibility;
 **/
typedef enum {
    BEF_MP_EdgeMode = 0,
    BEF_MP_FrashEvery = 1,
    BEF_MP_OutputMinSideLen = 2,
    BEF_MP_OutputWidth = 3,
    BEF_MP_OutputHeight = 4,
}bef_ai_matting_param_type;

/* {zh} 
 * @brief 模型类型枚举
 **/
/* {en} 
 * @brief Model type enumeration
 **/
typedef enum {
    BEF_MP_LARGE_MODEL = 0,
    BEF_MP_SMALL_MODEL = 1,
}bef_ai_matting_model_type;


/* {zh} 
 * @brief 返回结构体，alpha 空间需要调用方负责分配内存和释放，保证有效的控场大于等于widht*height
 * @note 根据输入的大小，短边固定到MP_OutputMinSideLen参数指定的大小，长边保持长宽比缩放；
 *       如果输入的image_height > image_width: 则
 *                width = MP_OutputMinSideLen,
 *                height = (int)(1.0*MP_OutputMinSideLen/image_width*image_height);
 *                //如果长度不为16的倍数，则向上取整到16的倍数
 *                   if(height %16 > 0){
 *                      height = 16*(height/16)+16;
 }
 **/
/* {en} 
 * @brief Returning to the structure, the alpha  space requires the caller to be responsible for allocating memory and releasing, ensuring that the effective control field is greater than or equal to widht * height
 * @note According to the size of the input, the short side is fixed to the size specified by the MP_OutputMinSideLen parameter, and the long side keeps the aspect ratio scaled;
 *       If the input image_height > image_width: then
 *                width = MP_OutputMinSideLen,
 *                height = (int) (1.0 * MP_OutputMinSideLen/image_width * image_height);
 *                //If the length is not a multiple of 16, then round up to a multiple of 16
 *                   if (height% 16 > 0) {
 *                      height = 16 * (height/16) + 16;
 }
 **/
typedef struct {
    unsigned char* alpha;  //  {zh} alpha[i, j] 表示第 (i, j) 点的 mask 预测值，值位于[0, 255] 之间  {en} Alpha [i, j] represents the mask predicted value at point (i, j), and the value is between [0,255]
    int width;             //  {zh} alpha 的宽度  {en} Alpha width
    int height;            //  {zh} alpha 的高度  {en} Alpha height
}bef_ai_matting_ret;

/** {zh} 
 * @brief 创建骨骼的句柄
 * @param [out] handle    Created portrait_matting handle
 *                        创建的骨骼句柄
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Handle to create a skeleton
 * @param  [out] Handle Created portrait_matting handle
 *                        Handle to create a skeleton
 * @return If succeed returns BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Success returns BEF_RESULT_SUC, failure returns the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_matting_create(
                             bef_effect_handle_t *handle
                             );

/* {zh} 
 * @brief 从文件初始化模型参数
 **/
/* {en} 
 * @brief Initialize model parameters from a file
 **/

BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_matting_init_model(
                                      bef_effect_handle_t handle,
                                      bef_ai_matting_model_type type,
                                      const char* param_path);

/* {zh} 
 * @brief 设置SDK参数
 **/
/* {en} 
 * @brief Set SDK parameters
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_matting_set_param(
                                        bef_effect_handle_t handle,
                                        bef_ai_matting_param_type type,
                                        int value);

/* {zh} 
 * @brief 获取SDK参数
 **/
/* {en} 
 * @brief Get SDK parameters
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_matting_get_param(
                                         bef_effect_handle_t handle,
                                         bef_ai_matting_param_type type,
                                         int *value);
/** {zh} 
 *  @brief 获取输出mask的尺寸
 *  @param handle 人体分割句柄
 *  @param width 输入图的宽度
 *  @param height 输入图的高度
 *  @param output_width[out] 输出mask的宽度
 *  @param output_height[out] 输出mask的高度
 *
 */
/** {en} 
 *  @brief Get the size of the output mask
 *  @param handle human body division handle
 *  @param width width of the input graph
 *  @param height height of the input graph
 *  @param output_width [out] width of the output mask
 *  @param output_height [out] height of the output mask
 *
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_get_output_shape(bef_effect_handle_t handle,
                                        int width,
                                        int height,
                                        int *output_width,
                                        int *output_height);
/* {zh} 
 * @brief 进行抠图操作
 * @note ret 结构图空间需要外部分配
 **/
/* {en} 
 * @brief Perform a matting operation
 * @note ret Structure diagram space needs external allocation
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_matting_do_detect(
                                         bef_effect_handle_t handle,
                                         const unsigned char *src_image_data,
                                         bef_ai_pixel_format pixel_format,
                                         int width,
                                         int height,
                                         int image_stride,
                                         bef_ai_rotate_type orient,
                                         bool need_flip_alpha,
                                         bef_ai_matting_ret *ret);


/* {zh} 
 * @brief 释放句柄
 **/
/* {en} 
 * @brief Release handle
 **/
BEF_SDK_API bef_effect_result_t
bef_effect_ai_portrait_matting_destroy(bef_effect_handle_t handle);


/** {zh} 
 * @brief 人像分割授权
 * @param [in] handle Created portrait_matting  handle
 *                    已创建的骨骼检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Portrait segmentation authorization
 * @param  [in] handle Created portrait_matting handle
 *                    Created bone detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed returns BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         Successfully returns BEF_RESULT_SUC, authorization code illegally returns BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_define for details.
 */

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_matting_check_license(JNIEnv* env, jobject context, bef_effect_handle_t handle, const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_matting_check_license(bef_effect_handle_t handle, const char *licensePath);
#endif
#endif

BEF_SDK_API bef_effect_result_t
bef_effect_ai_matting_check_online_license(bef_effect_handle_t handle, const char *licensePath);

#endif // BEF_EFFECT_AI_SKELETON_H

