// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#ifndef _BEF_EFFECT_FACE_ATTRIBUTE_H_
#define _BEF_EFFECT_FACE_ATTRIBUTE_H_

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"
#include "bef_effect_ai_face_detect.h"

typedef enum {
  BEF_FACE_ATTRIBUTE_AGE          = 0x00000001,     // {zh} 年龄 {en} Age
  BEF_FACE_ATTRIBUTE_GENDER       = 0x00000002,     // {zh} 性别 {en} Gender
  BEF_FACE_ATTRIBUTE_EXPRESSION   = 0x00000004,     // {zh} 表情 {en} Expression
  BEF_FACE_ATTRIBUTE_ATTRACTIVE   = 0x00000008,     // {zh} 颜值 {en} Face value
  BEF_FACE_ATTRIBUTE_HAPPINESS    = 0x00000010,     // {zh} 开心程度 {en} Happy degree
  BEF_FACE_ATTRIBUTE_CONFUSE      = 0x00000400,     // {zh} 疑惑 {en} Doubt
} bef_ai_face_attribute_types;

typedef enum {
  BEF_FACE_ATTRIBUTE_ForceDetect = 0x10000000,     // {zh} 未加平滑的裸数据，重置缓存，在切换摄像头时等上下帧剧烈变化时使用 {en} Unsmoothed bare data, reset cache, use when switching cameras and other up and down frames change dramatically
                                // {zh} 用于处理切换摄像头，跟踪的人脸ID 混淆的问题 {en} Used to handle the problem of face ID confusion when switching cameras and tracking
} bef_ai_face_attribut_config;

/* {zh} 
 *@brief 表情类别枚举
**//* {en} 
 *@brief Enumeration of expression categories
**/
typedef enum {
  BEF_FACE_ATTRIBUTE_ANGRY = 0,                   // {zh} 生气 {en} Angry
  BEF_FACE_ATTRIBUTE_DISGUST = 1,                 // {zh} 厌恶 {en} Disgust
  BEF_FACE_ATTRIBUTE_FEAR = 2,                    // {zh} 害怕 {en} Scared
  BEF_FACE_ATTRIBUTE_HAPPY = 3,                   // {zh} 高兴 {en} Happy
  BEF_FACE_ATTRIBUTE_SAD = 4,                     // {zh} 伤心 {en} Sad
  BEF_FACE_ATTRIBUTE_SURPRISE = 5,                // {zh} 吃惊 {en} Surprised
  BEF_FACE_ATTRIBUTE_NEUTRAL = 6,                 // {zh} 平静 {en} Calm
  BEF_FACE_ATTRIBUTE_NUM_EXPRESSION = 7           // {zh} 支持的表情个数 {en} Number of expressions supported
}bef_ai_face_attribute_expression_type;

/* {zh} 
 *@breif 单个人脸属性结构体
**//* {en} 
 *@breif Single face attribute structure
**/
typedef struct bef_ai_face_attribute_info {
  float age;                          //  {zh} 预测的年龄值， 值范围【0，100】之间  {en} Predicted age value, value range [0, 100] between
  float boy_prob;                     //  {zh} 预测为男性的概率值，值范围【0.0，1.0】之间  {en} The probability value predicted to be male, between [0.0, 1.0]
  float attractive;                   //  {zh} 预测的颜值分数，范围【0，100】之间  {en} Predicted face value score, range between [0,100]
  float happy_score;                  //  {zh} 预测的微笑程度，范围【0，100】之间  {en} Predicted smile level, range [0, 100]
  bef_ai_face_attribute_expression_type exp_type;            //  {zh} 预测的表情类别  {en} Predicted expression categories
  float exp_probs[BEF_FACE_ATTRIBUTE_NUM_EXPRESSION];    //  {zh} 预测的每个表情的概率，未加平滑处理  {en} Predicted probability of each expression, unsmoothed
  // extra
  float real_face_prob;               //  {zh} 预测属于真人脸的概率，用于区分雕塑、漫画等非真实人脸  {en} Predict the probability of a real face, used to distinguish non-real faces such as sculptures and comics
  float quality;                      //  {zh} 预测人脸的质量分数，范围【0，100】之间  {en} Predict the quality score of the face, between [0,100]
  float arousal;                      //  {zh} 情绪的强烈程度  {en} The intensity of emotions
  float valence;                      //  {zh} 情绪的正负情绪程度  {en} Positive and negative emotional degree
  float sad_score;                    //  {zh} 伤心程度  {en} Sad degree
  float angry_score;                  //  {zh} 生气程度  {en} Angry degree
  float surprise_score;               //  {zh} 吃惊的程度  {en} Degree of surprise
  float mask_prob;                    //  {zh} 预测带口罩的概率  {en} Predict the probability of wearing a mask
  float wear_hat_prob;                //  {zh} 戴帽子的概率  {en} Probability of wearing a hat
  float mustache_prob;                //  {zh} 有胡子的概率  {en} Probability of having a beard
  float lipstick_prob;                //  {zh} 涂口红的概率  {en} Probability of applying lipstick
  float wear_glass_prob;              //  {zh} 带普通眼镜的概率  {en} Probability of wearing ordinary glasses
  float wear_sunglass_prob;           //  {zh} 带墨镜的概率  {en} Probability of wearing sunglasses
  float blur_score;                   //  {zh} 模糊程度  {en} Degree of blur
  float illumination;                 //  {zh} 光照  {en} Illumination
  float confused_prob;                // {zh} /< 疑惑表情概率 {en} /< Doubt expression probability
} bef_ai_face_attribute_info;


typedef enum {
  //  {zh} 身份相关的属性(性别、年龄)检测隔帧数，默认值为12;  {en} Identity-related attributes (gender, age) detection interval frame number, the default value is 12;
  BEF_FACE_ATTRIBUTE_IDRelatedDetectInterval = 1,
  //  {zh} 非身份相关的属性(表情、颜值、微笑程度）检测隔帧数，默认值为1，即每帧都识别；  {en} Non-identity-related attributes (expression, face value, smile degree) detect the number of frames, the default value is 1, that is, each frame is recognized;
  //  {zh} 保留字段，当前不可设；  {en} Reserved fields, currently unavailable;
  BEF_FACE_ATTRIBUTE_DetectInterval = 2,
  //  {zh} 当身份相关的属性识别置信度足够高时，停止计算该属性（结果在SDK中存储中正常返回，对外不感知）  {en} When the confidence level of identity-related attribute recognition is high enough, stop calculating the attribute (the result returns normally in the SDK and is not perceived to the outside world)
  //  {zh} 默认值为1，表示打开，设置为0,表示关闭；  {en} The default value is 1, which means open, and set to 0, which means closed;
  BEF_FACE_ATTRIBUTE_IDRelatedAccumulateResult = 3,
}bef_ai_face_attribute_param_config_type;

/* {zh} 
 *@brief 多个人脸属性结构体
 *@param
 *      face_count 有效的人脸个数
**//* {en} 
 *@brief Multiple face attribute structures
 *@param
 *      face_count number of valid faces
**/
typedef struct bef_ai_face_attribute_result {
  bef_ai_face_attribute_info  attr_info[BEF_MAX_FACE_NUM];    // {zh} 存放人脸属性结果数组 {en} Store face attribute result array
  int face_count;                         // {zh} 有效的人脸个数，即表示attr_info中的前face_count个人脸是有效的 {en} The number of valid faces, that is, the first face_count faces in the attr_info are valid
} bef_ai_face_attribute_result;



/** {zh} 
 * @brief 创建人脸属性检测的句柄
 * @param [in] config Config of face attribute detect algorithm
 *                    人脸属性检测算法的配置
 * @param [in] strModelPath 模型文件所在路径
 * @param [out] handle Created face attribute detect handle
 *                     创建的人脸属性检测句柄
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_base_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
/** {en} 
 * @brief Create a handle for face attribute detection
 * @param  [in] config Config of face attribute detection algorithm
 *                     Configuration of face attribute detection algorithm
 * @param  [in] strModelPath model file path
 * @param  [out] handle Created face attribute detection handle
 *                     If
 * @return succeed return BEF_RESULT_SUC, other values please see bef_effect_base_define h Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_base_define for details.
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_attribute_create(
  unsigned long long config,
  const char * strModelPath,
  bef_effect_handle_t *handle
);

/** {zh} 
 * @brief 单个人脸属性检测
 * @param [in] handle Created face attribute detect handle
 *                    已创建的人脸属性检测句柄
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
 * @param [in] detect_config Config of face detect, for example
 *                           人脸检测相关的配置
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_base_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
/** {en} 
 * @brief Single face attribute detection
 * @param  [in] Handle Created face attribute detection handle
 *                    Created face attribute detection handle
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
 * @param  [in] detect_config Config of face detection, for example
 *                           Configuration related to face detection
 * @return If Return successfully BEF_RESULT_SUC, other values please see bef_effect_base_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_base_define
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_attribute_detect(
  bef_effect_handle_t handle,
  const unsigned char *image,
  bef_ai_pixel_format pixel_format,
  int image_width,
  int image_height,
  int image_stride,
  const bef_ai_face_106 *ptr_base_info,
  unsigned long long config,
  bef_ai_face_attribute_info *ptr_face_attribute_info
);

/** {zh} 
 * @brief 多个人脸属性检测
 * @param [in] handle Created face attribute detect handle
 *                    已创建的人脸属性检测句柄
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
 * @param [in] face_count 人脸检测人脸数
 * @param [in] detect_config Config of face detect, for example
 *                           人脸检测相关的配置
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_base_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
/** {en} 
 * @brief Multiple face attribute detection
 * @param  [in] Handle Created face attribute detection handle
 *                    Created face attribute detection handle
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
 * @param  [in] face_count Face detection face number
 * @param  [in] detect_config Config of face detection, for example
 *                           Configuration related to face detection
 * @return If succeed in returning BEF_RESULT_SUC other, value please see bef_effect_base_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_base_define for details.
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_attribute_detect_batch(
  bef_effect_handle_t handle,
  const unsigned char *image,
  bef_ai_pixel_format pixel_format,
  int image_width,
  int image_height,
  int image_stride,
  const bef_ai_face_106 *ptr_base_info,
  int face_count,
  unsigned long long config,
  bef_ai_face_attribute_result *ptr_face_attribute_result
);


/** {zh} 
 * @brief Set face attribute detect parameter based on type 
 *     设置人脸属性检测的相关参数
 * @param [in] handle Created face detect handle
 *                    已创建的人脸检测句柄
 * @param [in] type Face detect type that needs to be set, check bef_face_detect_type for the detailed
 *                  需要设置的人体检测类型，可参考 bef_face_detect_type
 * @param [in] value Type value, check bef_face_detect_type for the detailed
 *                   参数值, 具体请参数 bef_face_detect_type 枚举中的说明
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_base_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_base_define.h
 */
/** {en} 
 * @brief Set face attribute detecting parameter based on type
 *     Set the relevant parameters of face attribute detecting
 * @param  [in] handle Created face detecting handle
 *                    created face detecting handle
 * @param  [in] type Face detecting type that needs to be set, check bef_face_detect_type for the detailed
 *                  The human body detection type that needs to be set can refer to bef_face_detect_type
 * @param  [in] value Type value, check bef_face_detect_type for the detailed
 *                   parameter value, please specify the parameter bef_face_detect_type the description in the enumeration
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_base_define. H
 *         successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_base_define for details.
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_attribute_setparam(
  bef_effect_handle_t handle,
  bef_ai_face_attribute_param_config_type type,
  float value
);


/** {zh} 
 * @param [in] handle Destroy the created face attribute detect handle
 *                    销毁创建的人脸属性检测句柄
 */
/** {en} 
 * @param [In] Handle Destroy the created face attribute detecting handle
 *                    Destroy the created face attribute detecting handle
 */
BEF_SDK_API void
bef_effect_ai_face_attribute_destroy(
  bef_effect_handle_t handle
);

/** {zh} 
 * @brief 人脸属性检测授权
 * @param [in] handle Created face attribute detect handle
 *                    已创建的人脸检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face attribute detection authorization
 * @param  [in] handle Created face attribute detection handle
 *                    created face detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         successfully return BEF_RESULT_SUC, authorization code illegally return BEF_RESULT_INVALID_LICENSE, other failures return corresponding error codes, please refer to bef_effect_ai_public_define for details.
 */
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_attribute_check_license(JNIEnv* env,
        jobject context, bef_effect_handle_t handle, const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_attribute_check_license(bef_effect_handle_t handle,
        const char *licensePath);
#endif
#endif

BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_attribute_check_online_license(bef_effect_handle_t handle, const char *licensePath);

#endif // _BEF_EFFECT_FACE_DETECT_AI_H_
