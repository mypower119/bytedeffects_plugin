//
// Created by zhengyanxin on 2019-08-12.
//

#ifndef ANDROIDDEMO_BEF_EFFECT_AI_PET_FACE_H
#define ANDROIDDEMO_BEF_EFFECT_AI_PET_FACE_H

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"

#define AI_PET_MAX_POINT_NUM 90                     //  {zh} 宠物脸的关键点的最大点数  {en} Maximum number of key points of pet face
#define AI_CAT_POINT_NUM 82                         //  {zh} 猫：82点  {en} Cat: 82 points
#define AI_DOG_POINT_NUM 76                         //  {zh} 狗：76点（不加耳朵）  {en} Dog: 76 points (without ears)
#define AI_OTHER_POINT_NUM 4                        //  {zh} 其它动物：4点(目前不支持)  {en} Other animals: 4 points (not currently supported)
#define AI_MAX_PET_NUM 10

#define AI_PET_OPEN_LEFT_EYE          0x00000001    //  {zh} 左眼睛是否睁开  {en} Is the left eye open
#define AI_PET_OPEN_RIGHT_EYE         0x00000002    //  {zh} 右眼睛是否睁开  {en} Is the right eye open
#define AI_PET_OPEN_MOUTH             0x00000004    //  {zh} 嘴巴是否张开  {en} Is the mouth open

typedef void *PetFaceHandle;                        // {zh} /< 关键点检测句柄 {en} /< Keypoint detection handle

typedef enum {
    BEF_CAT                 =                       1,   //  {zh} 猫  {en} Cat
    BEF_DOG                 =                       2,   //  {zh} 狗  {en} Dog
    BEF_HUMAN               =                       3,   //  {zh} 人（目前不支持）  {en} People (not currently supported)
    BEF_OTHERS              =                      99,   //  {zh} 其它宠物类型（目前不支持）  {en} Other pet types (not currently supported)
}bef_ai_pet_face_type;


typedef enum {
    BEF_DetCat              =             0x00000001,  //  {zh} 开启猫脸检测  {en} Turn on cat face detection
    BEF_DetDog              =             0x00000002,  //  {zh} 开启狗脸检测  {en} Turn on dog face detection
    BEF_QuickMode           =             0x00000004,  //  {zh} 开启快速版本  {en} Open Quick Version
}bef_ai_pet_face_config_type;

typedef struct bef_ai_pet_info_st {
    bef_ai_pet_face_type type;                          // {zh} / < 宠物类型 {en} /< Pet type
    bef_ai_rect rect;                            // {zh} / < 代表面部的矩形区域 {en} /< Represents the rectangular area of the face
    float score;                            // {zh} / < 宠物脸检测的置信度 {en} /< Confidence level of pet face detection
    bef_ai_fpoint points_array[AI_PET_MAX_POINT_NUM]; // {zh} / < 宠物脸关键点的数组 {en} /< Array of pet face key points
    float yaw;                              // {zh} / < 水平转角,真实度量的左负右正 {en} /< Horizontal corner, true measure left negative right positive
    float pitch;                            // {zh} / < 俯仰角,真实度量的上负下正 {en} /< Pitch angle, true measurement of up negative down positive
    float roll;                             // {zh} / < 旋转角,真实度量的左负右正 {en} /< Rotation angle, the real measure is left negative and right positive
    int id;                                 // {zh} / < faceID: 每个检测到的宠物脸拥有唯一id，跟踪丢失以后重新被检测到,会有一个新的id {en} /< faceID: Each detected pet face has a unique id. If the trace is lost and detected again, there will be a new id
    unsigned int action;                    // {zh} / < 脸部动作，目前只包括：左眼睛睁闭，右眼睛睁闭，嘴巴睁闭， {en} /< Face movements, currently only include: left eye open and close, right eye open and close, mouth open and close,
    // {zh} / < action 的第1，2，3位分别编码： 左眼睛睁闭，右眼睛睁闭，嘴巴睁闭，其余位数预留 {en} /< The 1st, 2nd, and 3rd digits of the action are encoded respectively: left eye open and closed, right eye open and closed, mouth open and closed, and the remaining digits are reserved
    
    int ear_type; // {zh} / < 判断是竖耳还是垂耳，竖耳为0，垂耳为1 {en} /< Identify whether it is a vertical ear or a lop ear, the vertical ear is 0, and the lop ear is 1
} bef_ai_pet_face_info, *p_bef_ai_pet_face_info;

// {zh} / @brief 检测结果 {en} @brief test results
typedef struct bef_ai_pet_face_result_st {
    bef_ai_pet_face_info p_faces[AI_MAX_PET_NUM];       // {zh} /< 检测到的宠物脸信息 {en} /< Detected pet face information
    int face_count;                        // {zh} /< 检测到的宠物脸数目，p_faces 数组中，只有face_count个结果是有效的； {en} /< Number of pet faces detected, p_faces array, only face_count results are valid;
} bef_ai_pet_face_result, *p_bef_ai_pet_face_result;



/** {zh} 
 * @brief 创建宠物脸检测的句柄
 *
 * @param [in] strModelPath 模型文件所在路径
 *
 * @param [in] config Config of pet face detect algorithm 宠物脸检测算法的配置
 *  可以配置只检测猫，只检测狗，或者同时检测猫狗
 *  例如：只检测狗 detect_config = bef_ai_pet_face_config_type::BEF_DetDog
 *       同时检测猫狗： 只检测狗 detect_config = bef_ai_pet_face_config_type::BEF_DetDog|bef_ai_pet_face_config_type::BEF_DetCat
 *
 * @param: max_face_num：指定最多能够检测到的宠物脸数目；
 *
 * @param [out] handle Created face detect handle
 *                     创建的宠物脸检测句柄
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Create a handle for pet face detection
 *
 * @param  [in] strModelPath model file path
 *
 * @param  [in] config Config of pet face detection algorithm Configuration of pet face detection algorithm
 *  You can configure only detect cats, only detect dogs, or detect cats and dogs at the same time
 *  For example: only detect dogs detect_config = bef_ai_pet_face_config_typ e::BEF _DetDog
 *       Also detect cats and dogs: only detect dogs detect_config = bef_ai_pet_face_config_typ e::BEF _DetDog | bef_ai_pet_face_config_typ e::BEF
 *
 * @param: max_face_num: Specify the maximum number of pet faces that can be detected;
 *
 * @param  [out] Handle Created face detection handle
 *                     Create a pet face detection handle
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API
bef_effect_result_t
bef_effect_ai_pet_face_create(
        const char * strModelPath,
        long long config,
        unsigned int maxNum,
        bef_effect_handle_t *handle
);



/** {zh} 
 * @brief 宠物脸检测
 * @param [in] handle Created face detect handle
 *                    已创建的宠物脸检测句柄
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
 * @param [in] orientation Image orientation
 *                         输入图像的转向，具体请参考 bef_effect_ai_public_define.h 中的 bef_rotate_type
 * @param [out] p_pet_face_result  存放结果信息，需外部分配好内存，需保证空间大于等于设置的最大检测宠物脸数
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Pet face detection
 * @param  [in] Handle Created face detection handle
 *                    Created pet face detection handle
 * @param  [in] Image base address
 *                   Data pointer of the input picture
 * @param  [in] pixel_format Pixel format of input image
 *                          Format of the input picture
 * @param  [in] image_width Image width
 *                          Width of the input image in pixels
 * @param  [in] image_height Image height
 *                          Height of the input image in pixels
 * @param  [in] image_stride Image stride in each row
 *                          Step size of each row of the input image in pixels
 * @param  [in] orientation Image orientation
 *                         Input the steering of the image, please refer to the bef_rotate_type in bef_effect_ai_public_define h
 * @param  [out] p_pet_face_result Store the result information, the memory needs to be allocated externally, and the space needs to be greater than or equal to the set maximum number of detected pet faces
 * @return If succeed return BEF_RESULT_SUC, other values please see bef_effect_ai_public_define h
 *         Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details
 */
BEF_SDK_API
bef_effect_result_t bef_effect_ai_pet_face_detect(
        bef_effect_handle_t handle,
        const unsigned char *image,
        bef_ai_pixel_format pixel_format,
        int image_width,
        int image_height,
        int image_stride,
        bef_ai_rotate_type orientation,
        bef_ai_pet_face_result *p_pet_face_result
);



/** {zh} 
 * @param [in] handle Destroy the created pet face detect handle
 *                    销毁创建的宠物脸检测句柄
 */
/** {en} 
 * @param [In] Handle Destroy the created pet face detecting handle
 *                    Destroy the created pet face detecting handle
 */
BEF_SDK_API
bef_effect_result_t bef_effect_ai_pet_face_release(bef_effect_handle_t handle);



/** {zh} 
 * @brief 宠物脸授权
 * @param [in] handle Created pet face handle
 *                    已创建的宠物脸检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Pet face authorization
 * @param  [in] handle Created pet face handle
 *                    created pet face detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         successfully return BEF_RESULT_SUC, the authorization code illegally returns BEF_RESULT_INVALID_LICENSE, other failures return the corresponding error code, please refer to bef_effect_ai_public_define for details.
 */
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_pet_face_check_license(JNIEnv *env, jobject context,
                                                                 bef_effect_handle_t handle,
                                                                 const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_pet_face_check_license(bef_effect_handle_t handle, const char *licensePath);
#endif
#endif

BEF_SDK_API bef_effect_result_t
bef_effect_ai_pet_face_check_online_license(bef_effect_handle_t handle, const char *licensePath);
#endif //ANDROIDDEMO_BEF_EFFECT_AI_PET_FACE_H
