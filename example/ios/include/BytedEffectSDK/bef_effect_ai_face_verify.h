#ifndef _BEF_EFFECT_FACE_VREIFY_AI_H_
#define _BEF_EFFECT_FACE_VREIFY_AI_H_

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"
#include "bef_effect_ai_face_detect.h"

#define BEF_AI_MAX_FACE_VERIFY_NUM  10

#define BEF_AI_FACE_FEATURE_DIM 128  //  {zh} 人脸特征的维数  {en} Dimension of face features


//  {zh} 结果信息  {en} Result information
typedef struct bef_ai_face_verify_info_s{
    bef_ai_face_106 base_infos[BEF_AI_MAX_FACE_VERIFY_NUM];//   {zh} 基本的人脸信息，包含106点、动作、姿态   {en} Basic face information, including 106 points, actions, gestures
    float features[BEF_AI_MAX_FACE_VERIFY_NUM][BEF_AI_FACE_FEATURE_DIM];  //  {zh} 存放人脸特征  {en} Store face features
        int valid_face_num;  //  {zh} 检测到的人脸数目  {en} Number of faces detected
} bef_ai_face_verify_info;

/** {zh} 
 * 创建人脸比对的句柄
 *@brief 初始化handle
 *@param face_verify_param_path  人脸识别模型的文件路径
 *@param max_face_num            要处理的最大人脸数，该值不能大于AI_MAX_FACE_NUM
 *@param [out] handle Created face verify handle
 *                     创建的人手检测句柄
 *@return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * Handle to create face comparison
 *@brief Initialize handle
 *@param face_verify_param_path  File path of face recognition model
 *@param max_face_num            The maximum number of faces to be processed, the value cannot be greater than AI_MAX_FACE_NUM
 *@param  [out] Handle Created face verify handle
 *                     Handle to create human hand detection
 *@return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_verify_create(
        const char *face_verify_param_path,
        const int max_face_num,
        bef_effect_handle_t *handle
);
/** {zh} 
 * @brief 人脸特征提取，支持最多10个人脸
 * @param [in] handle Created face verify handle
 *                    已创建的人脸检测句柄
 * @param [in] image Image base address
 *                   输入图片的数据指针
 * @param [in] pixel_format Pixel format of input image
 *                          输入图片的格式 支持RGBA, BGRA, BGR, RGB, GRAY(YUV暂时不支持)
 * @param [in] image_width  Image width
 *                          输入图像的宽度 (以像素为单位)
 * @param [in] image_height Image height
 *                          输入图像的高度 (以像素为单位)
 * @param [in] image_stride Image stride in each row
 *                          输入图像每一行的步长 (以像素为单位)
 * @param [in] orientation Image orientation
 *                         输入图像的转向，具体请参考 bef_effect_ai_public_define.h 中的 bef_rotate_type
 * @param [in] face_input      bef_ai_face_info
 *                          人脸106点检测结果
 * @param [out] face_info_ptr  存放结果信息，需外部分配好内存，需保证空间大于等于设置的最大检测人脸数
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face feature extraction, support up to 10 faces
 * @param  [in] Handle Created face verify handle
 *                    Created face detection handle
 * @param  [in] Image base address
 *                   Input image data pointer
 * @param  [in] pixel_format Pixel format of input image
 *                          Input image format, support RGBA, BGRA, BGR, RGB, GRAY (YUV temporarily not supported)
 * @param  [in] image_width Image width
 *                          Input image width (in pixels)
 * @param  [in] image_height Image height
 *                          Input image height (in pixels)
 * @param  [in] image_stride Image stride in each row
 *                          Input the step size of each row of the image (in pixels)
 * @param  [in] orientation Image orientation
 *                         Input image orientation
 * @param Input image steering, please refer to the bef_rotate_type in bef_effect_ai_public_define h  [in]
 *                          face_input
 * @param Face 106 point detection result  [out]
 * @return face_info_ptr store the result information, external memory allocation is required, and the space must be greater than or equal to the set maximum number of detected faces If
 *         succeed return BEF_RESULT_SUC, other values
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_extract_feature(
        bef_effect_handle_t handle,
        const unsigned char *image,
        bef_ai_pixel_format pixel_format,
        int image_width,
        int image_height,
        int image_stride,
        bef_ai_rotate_type orientation,
        const bef_ai_face_info *face_input,
        bef_ai_face_verify_info *verify_info_ptr
);


/** {zh} 
 * @brief 单个人脸特征提取
 * @param [in] handle Created face verify handle
 *                    已创建的人脸检测句柄
 * @param [in] image Image base address
 *                   输入图片的数据指针
 * @param [in] pixel_format Pixel format of input image
 *                          输入图片的格式 支持RGBA, BGRA, BGR, RGB, GRAY(YUV暂时不支持)
 * @param [in] image_width  Image width
 *                          输入图像的宽度 (以像素为单位)
 * @param [in] image_height Image height
 *                          输入图像的高度 (以像素为单位)
 * @param [in] image_stride Image stride in each row
 *                          输入图像每一行的步长 (以像素为单位)
 * @param [in] orientation Image orientation
 *                         输入图像的转向，具体请参考 bef_effect_ai_public_define.h 中的 bef_rotate_type
 * @param [in] face_input      bef_ai_face_106
 *                          单个人脸106点检测结果
 * @param [out] face_info_ptr  存放特征信息，需外部分配好内存，需保证空间大于等于定义的特征维度
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Single face feature extraction
 * @param  [in] Handle Created face verify handle
 *                    Created face detection handle
 * @param  [in] Image base address
 *                   Input image data pointer
 * @param  [in] pixel_format Pixel format of input image
 *                          Input image format, support RGBA, BGRA, BGR, RGB, GRAY (YUV temporarily not supported)
 * @param  [in] image_width Image width
 *                          Input image width (in pixels)
 * @param  [in] image_height Image height
 *                          Input image height (in pixels)
 * @param  [in] image_stride Image stride in each row
 *                          Input the step size of each row of the image (in pixels)
 * @param  [in] orientation Image orientation
 *                         Input image steering, please refer to the bef_rotate_type in bef_effect_ai_public_define h
 * @param  [in] face_input
 *                          Single face 106 point detection result
 * @param  [out] face_info_ptr store feature information, external memory allocation is required, and the space must be greater than or equal to the defined feature dimension
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Successful return BEF_RESULT_SUC, failure return
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_extract_feature_single(
        bef_effect_handle_t handle,
        const unsigned char *image,
        bef_ai_pixel_format pixel_format,
        int image_width,
        int image_height,
        int image_stride,
        bef_ai_rotate_type orientation,
        const bef_ai_face_106 *face_input,
        float *verify_info_ptr
);
/** {zh} 
 * @brief 人脸特征比对
 * @param [in] feature1 特征1
 *
 * @param [in] feature2 特征2
 *
 * @param [in] size   特征维度
 *
 * @return [out] 特征距离
 **/
/** {en} 
 * @brief Face feature comparison
 * @param  [in] Feature 1
 *
 * @param  [in] Feature 2
 *
 * @param  [in] Size Feature dimension
 *
 * @return  [out] Feature distance
 **/

BEF_SDK_API double bef_effect_ai_face_verify(const float *feature1,
                                             const float *feature2, int size);
/** {zh} 
 * @brief 特征相似度计算
 *
 * @param [in] d 特征距离
 *
 * @return [out] 特征相似度
 **/
/** {en} 
 * @brief Feature similarity calculation
 *
 * @param  [in] d feature distance
 *
 * @return  [out]  feature similarity
 **/
BEF_SDK_API double bef_effect_ai__dist2score(double d);

/** {zh} 
 * @param [in] handle Destroy the created face detect handle
 *                    销毁创建的人脸比对句柄
 */
/** {en} 
 * @param [In] Handle Destroy the created face detection handle
 *                    Destroy the created face comparison handle
 */
BEF_SDK_API void
bef_effect_ai_face_verify_destroy(
        bef_effect_handle_t handle
);

/** {zh} 
 * @brief 人脸比对授权
 * @param [in] handle Created face detect handle
 *                    已创建的人脸检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face comparison authorization
 * @param  [in] handle Created face detection handle
 *                    created face detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed returns BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         successfully returned BEF_RESULT_SUC, authorization code returned illegally BEF_RESULT_INVALID_LICENSE, other failures returned corresponding error codes, please refer to bef_effect_ai_public_define for details
 */
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_verify_check_license(JNIEnv *env, jobject context,
                                                                 bef_effect_handle_t handle,
                                                                 const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_verify_check_license(bef_effect_handle_t handle, const char *licensePath);
#endif
#endif


BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_verify_check_online_license(bef_effect_handle_t handle, const char *licensePath);


#endif // _BEF_EFFECT_FACE_DETECT_AI_H_
