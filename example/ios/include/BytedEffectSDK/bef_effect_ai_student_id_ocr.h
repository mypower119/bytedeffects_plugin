#ifndef BEF_EFFECT_AI_STUDENT_ID_OCR_H
#define BEF_EFFECT_AI_STUDENT_ID_OCR_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include <jni.h>
#endif

#include "bef_effect_ai_public_define.h"

typedef unsigned long long bef_ai_student_id_handle;

/** {zh} 
 * @brief 模型枚举，有些模块可能有多个模型
 *
 */
/** {en} 
 * @brief Model enumeration, some modules may have multiple models
 *
 */
typedef enum bef_ai_student_id_ocr_model_type {
  BEF_STUDENT_ID_OCR_MODEL = 1,        
} bef_ai_student_id_ocr_model_type;


/** {zh} 
 * @brief 模型参数类型
 *
 */
/** {en} 
 * @brief Model parameter type
 *
 */
typedef enum bef_ai_student_id_orc_param_type
{
  BEF_STUDENT_ID_OCR_EDGE_TYPE = 1,
}bef_ai_student_id_orc_param_type;

/** {zh} 
 * @brief 封装预测接口的返回值
 *
 * @note 返回识别框的位置和大小
 */
/** {en} 
 * @brief Encapsulates the return value of the prediction interface
 *
 * @note  Returns the position and size of the recognition box
 */
typedef struct bef_student_id_ocr_result {
  int width;                   // {zh} /< 识别框的宽度 {en} /< Width of identification box
  int height;                  // {zh} /< 识别框的的高度 {en} /< Height of identification box
  int x;                       // {zh} /< 识别框的横坐标 {en} /< Abscissa of the identification box
  int y;                       // {zh} /< 识别框的纵坐标 {en} /< The ordinate of the identification box
  int length;                   // {zh} /< 识别出来的id的长度 {en} /< The length of the identified id
  char* result;                // {zh} /< 识别出的id的结果，这个部分的内存算法内部分配，用户在使用后，需要free，以免造成内存泄漏 {en} /< The result of the identified id, this part of the memory algorithm internal allocation, the user needs to be free after use, so as not to cause memory leakage
} bef_student_id_ocr_result;

BEF_SDK_API bef_effect_result_t
bef_effect_ai_student_id_ocr_create_handle(bef_ai_student_id_handle* handle);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_student_id_ocr_init_model(bef_ai_student_id_handle handle,
                                        bef_ai_student_id_ocr_model_type type,
                                        const char* model_path);

// BEF_SDK_API bef_effect_result_t
// bef_effect_ai_student_id_ocr_set_paramf(bef_ai_student_id_handle handle,
//                                         bef_ai_student_id_orc_param_type type,
//                                         float value);
                                    
BEF_SDK_API bef_effect_result_t
bef_effect_ai_student_id_ocr_detect(bef_ai_student_id_handle handle,
                                    const unsigned char* image,
                                    bef_ai_pixel_format pixel_format,
                                    int image_width,
                                    int image_height,
                                    int image_stride,
                                    bef_ai_rotate_type orientation,
                                    bef_student_id_ocr_result *id_info);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_student_id_ocr_destroy(bef_ai_student_id_handle handle);

BEF_SDK_API bef_effect_result_t
bef_effect_ai_student_id_ocr_check_license(bef_ai_student_id_handle handle, const char* licensePath);

#endif
