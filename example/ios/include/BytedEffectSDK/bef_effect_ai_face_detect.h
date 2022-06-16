// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.
#ifndef _BEF_EFFECT_FACE_DETECT_AI_H_
#define _BEF_EFFECT_FACE_DETECT_AI_H_

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
#include<jni.h>
#endif

#include "bef_effect_ai_public_define.h"


//***************************** begin Create-Config *****************/
// Config when creating handle
#define BEF_DETECT_LARGE_MODEL 0x00100000  //  {zh} 106模型初始化参数，更准, 现已废弃  {en} 106 model initialization parameters, more accurate, now obsolete
#define BEF_DETECT_SMALL_MODEL 0x00200000  //  {zh} 106模型初始化参数，更快  {en} 106 model initialization parameters, faster
#define BEF_DETECT_FACE_240_DETECT_FASTMODE \
0x00300000  //  {zh} 240模型初始化参数，更快  {en} 240 model initialization parameters, faster
//**************************** end of Create-Config *****************/

//***************************** begin Mode-Config ******************/
#define BEF_DETECT_MODE_VIDEO_SLOW 0x00010000  //  {zh} 视频检测，能检测更小的人脸,初始化+预测参数  {en} Video detection, can detect smaller faces, initialization + prediction parameters
#define BEF_DETECT_MODE_VIDEO 0x00020000  //  {zh} 视频检测，初始化+预测参数  {en} Video detection, initialization + prediction parameters
#define BEF_DETECT_MODE_IMAGE 0x00040000  //  {zh} 图片检测，初始化+预测参数  {en} Image detection, initialization + prediction parameters
#define BEF_DETECT_MODE_IMAGE_SLOW \
0x00080000  //  {zh} 图片检测，人脸检测模型效果更好，能检测更小的人脸，初始化+预测参数  {en} Image detection, face detection model effect is better, can detect smaller faces, initialization + prediction parameters
//***************************** enf of Mode-Config *****************/

//***************************** Begin Config-106 point and action **/
// for 106 key points detect
//  {zh} NOTE 当前版本 张嘴、摇头、点头、挑眉默认都开启，设置相关的位不生效  {en} NOTE current version, open mouth, shake head, nod, raise eyebrows are turned on by default, set the relevant bit does not take effect
#define BEF_FACE_DETECT 0x00000001  //  {zh} 检测106点  {en} Detect 106 points
//  {zh} 人脸动作  {en} Face Action
#define BEF_EYE_BLINK 0x00000002   //  {zh} 眨眼  {en} Blink
#define BEF_MOUTH_AH 0x00000004    //  {zh} 张嘴  {en} Open your mouth
#define BEF_HEAD_YAW 0x00000008    //  {zh} 摇头  {en} Shake your head
#define BEF_HEAD_PITCH 0x00000010  //  {zh} 点头  {en} Nod your head
#define BEF_BROW_JUMP 0x00000020   //  {zh} 挑眉  {en} Raise eyebrows
#define BEF_MOUTH_POUT 0x00000040  //  {zh} 嘟嘴  {en} Beak

#define BEF_DETECT_FULL 0x0000007F  //  {zh} 检测上面所有的特征，初始化+预测参数  {en} Detect all the features above, initialize + predict parameters

#define BEF_EYE_BLINK_LEFT \
0x00000080  //  {zh} 左眼闭眼，只用于提取对应的action，动作检测依然是眨眼  {en} Left eye closed, only used to extract the corresponding action, action detection is still blinking
#define BEF_EYE_BLINK_RIGHT \
0x00000100  //  {zh} 右眼闭眼，只用于提取对应的action，动作检测依然是眨眼  {en} Right eye closed, only used to extract the corresponding action, action detection is still blinking
#define BEF_INDIAN_HEAD_ROLL \
0x00000200  //  {zh} 印度式摇头，只用于提取对应的action，动作检测依然是摇头  {en} Indian head shaking, only used to extract the corresponding action, action detection is still head shaking

//**************************** End Config-106 point and action *******/

//******************************* Begin Config-280 point *************/
// for 280 points
//  {zh} NOTE: 现在改了二级策略，眉毛、眼睛、嘴巴关键点会在一个模型中出  {en} NOTE: Now changed the secondary strategy, eyebrows, eyes, mouth key points will be out in a model
#define TT_MOBILE_FACE_240_DETECT \
0x00000100  //  {zh} 检测二级关键点: 眉毛, 眼睛, 嘴巴，初始化+预测参数  {en} Detection of secondary key points: eyebrows, eyes, mouth, initialization + prediction parameters
#define AI_BROW_EXTRA_DETECT TT_MOBILE_FACE_240_DETECT   //  {zh} 眉毛 13*2个点  {en} Eyebrows 13 * 2 dots
#define AI_EYE_EXTRA_DETECT TT_MOBILE_FACE_240_DETECT    //  {zh} 眼睛 22*2个点  {en} Eyes 22 * 2 points
#define AI_MOUTH_EXTRA_DETECT TT_MOBILE_FACE_240_DETECT  //  {zh} 嘴巴 64个点  {en} Mouth 64 points
#define AI_MOUTH_MASK_DETECT 0x00000300   //  {zh} 嘴巴 mask  {en} Mouth mask
#define AI_TEETH_MASK_DETECT 0x00000300   //  {zh} 牙齿 mask  {en} Dental mask
#define AI_FACE_MASK_DETECT 0x00000500     //  {zh} 人脸 mask  {en} Face mask
#define AI_IRIS_EXTRA_DETECT 0x00000800   //  {zh} 虹膜 20*2个点  {en} Iris 20 * 2 points

#define TT_MOBILE_FACE_280_DETECT \
0x00000900  //  {zh} 检测二级关键点: 眉毛, 眼睛, 嘴巴，虹膜，初始化+预测参数  {en} Detection of secondary key points: eyebrows, eyes, mouth, iris, initialization + prediction parameters
//******************************* End Config-280 point ***************/

#define TT_MOBILE_FORCE_DETECT 0x00001000  //  {zh} 强制这帧人脸检测，并显示结果  {en} Force this frame face detection and display the result

//bef_effect_public_face_define
#define BEF_MAX_FACE_NUM  10

//  {zh} 眼睛,眉毛,嘴唇详细检测结果, 280点结果  {en} Eyes, eyebrows, lips detailed test results, 280 points result
typedef struct bef_ai_face_ext_info_t {
    int eye_count;                  //  {zh} 检测到眼睛数量  {en} Number of eyes detected
    int eyebrow_count;              //  {zh} 检测到眉毛数量  {en} Number of eyebrows detected
    int lips_count;                 //  {zh} 检测到嘴唇数量  {en} Lip count detected
    int iris_count;                 //  {zh} 检测到虹膜数量  {en} Iris count detected
    
    bef_ai_fpoint eye_left[22];        //  {zh} 左眼关键点  {en} Key point of left eye
    bef_ai_fpoint eye_right[22];       //  {zh} 右眼关键点  {en} Right eye key point
    bef_ai_fpoint eyebrow_left[13];    //  {zh} 左眉毛关键点  {en} Left eyebrow key point
    bef_ai_fpoint eyebrow_right[13];   //  {zh} 右眉毛关键点  {en} Right eyebrow key point
    bef_ai_fpoint lips[64];            //  {zh} 嘴唇关键点  {en} Key points of lips
    bef_ai_fpoint left_iris[20];       //  {zh} 左虹膜关键点  {en} Left iris key point
    bef_ai_fpoint right_iris[20];      //  {zh} 右虹膜关键点  {en} Right iris key point
} bef_ai_face_ext_info;




//  {zh} 供106点使用  {en} For 106 points
typedef struct bef_ai_face_106_st {
    bef_ai_rect rect;                //  {zh} 代表面部的矩形区域  {en} Represents a rectangular area of the face
    float score;                  //  {zh} 置信度  {en} Confidence
    bef_ai_fpoint points_array[106]; //  {zh} 人脸106关键点的数组  {en} Array of 106 key points of human face
    float visibility_array[106];  //  {zh} 对应点的能见度，点未被遮挡1.0, 被遮挡0.0  {en} Visibility of the corresponding point, the point is not occluded 1.0, is occluded 0.0
    float yaw;                    //  {zh} 水平转角,真实度量的左负右正  {en} Horizontal angle, left negative and right positive in real measurement
    float pitch;                  //  {zh} 俯仰角,真实度量的上负下正  {en} Pitch angle, true measurement of up, down and positive
    float roll;                   //  {zh} 旋转角,真实度量的左负右正  {en} Rotation angle, true measure of left negative right positive
    float eye_dist;               //  {zh} 两眼间距  {en} Distance between eyes
    int ID;                       //  {zh} faceID: 每个检测到的人脸拥有唯一的faceID.人脸跟踪丢失以后重新被检测到,会有一个新的faceID  {en} FaceID: Each detected face has a unique faceID. After the face tracking is lost and detected again, a new faceID will be given
    unsigned int action;          //  {zh} 动作, 定义在 bef_ai_effect_face_detect.h 里  {en} Action, defined in bef_ai_effect_face_detect h
    unsigned int tracking_cnt;
} bef_ai_face_106, *p_bef_ai_face_106;


//  {zh} @brief 检测结果  {en} @brief Test results
typedef struct bef_ai_face_info_st {
    bef_ai_face_106 base_infos[BEF_MAX_FACE_NUM];          //  {zh} 检测到的人脸信息  {en} Detected face information
    bef_ai_face_ext_info extra_infos[BEF_MAX_FACE_NUM];    //  {zh} 眼睛，眉毛，嘴唇关键点等额外的信息  {en} Eyes, eyebrows, lips, key points and other additional information
    int face_count;                                     //  {zh} 检测到的人脸数目  {en} Number of faces detected
} bef_ai_face_info, *p_bef_ai_face_info;

//  {zh} brief 算法格外参数设置  {en} Extra parameter setting of brief algorithm
typedef struct bef_ai_face_image_st {
    bef_ai_face_106 base_info;         //  {zh} 检测到的人脸信息  {en} Detected face information
    bef_ai_face_ext_info extra_info;   //  {zh} 眼睛，眉毛，嘴唇关键点等额外的信息  {en} Eyes, eyebrows, lips, key points and other additional information
    unsigned int texture_id;          //  {zh} 基于人脸位置的截图（已补充额头部分、已旋正）  {en} Screenshot based on the position of the face (the forehead part has been added and aligned)
    bef_ai_pixel_format pixel_format;  //  {zh} 截图格式，目前均为RGBA  {en} Screenshot format, currently all RGBA
    int image_width;                //  {zh} 截图像素宽度  {en} Screenshot pixel width
    int image_height;               //  {zh} 截图像素高度  {en} Screenshot pixel height
    int image_stride;               //  {zh} 截图行跨度  {en} Screenshot row span
} bef_ai_face_image_st, *p_bef_ai_face_image_st;


#define BEF_MOUTH_MASK_WIDTH 256
#define BEF_FACE_MASK_WIDTH BEF_MOUTH_MASK_WIDTH
#define BEF_TEETH_MASK_WIDTH BEF_MOUTH_MASK_WIDTH
typedef struct bef_ai_face_mask_base{
    int mask_size;        // mask_size
    unsigned char mask[BEF_MOUTH_MASK_WIDTH * BEF_MOUTH_MASK_WIDTH];  // mask data
    float warp_mat[6];          // warp mat data ptr, size 2*3
    int id;
}bef_ai_face_mask_base,  *p_bef_ai_face_mask_base;

//  {zh} brief 唇部mask  {en} Brief lip mask
typedef struct bef_ai_mouth_mask_info{
    bef_ai_face_mask_base mouth_mask[BEF_MAX_FACE_NUM];
    int face_count;
}bef_ai_mouth_mask_info,  *p_bef_ai_mouth_mask_info;

//  {zh} brief 嘴内mask  {en} Brief mouth mask
typedef struct bef_ai_teeth_mask_info{
    bef_ai_face_mask_base teeth_mask[BEF_MAX_FACE_NUM];
    int face_count;
}bef_ai_teeth_mask_info,  *p_bef_ai_teeth_mask_infos;

//  {zh} brief 面部mask  {en} Brief mask
typedef struct bef_ai_face_mask_info{
    bef_ai_face_mask_base face_mask[BEF_MAX_FACE_NUM];
    int face_count;
}bef_ai_face_mask_info,  *p_bef_ai_face_mask_info;

//  {zh} brief  每个脸的遮挡概率  {en} Brief the occlusion probability of each face
typedef struct bef_ai_face_occlusion_info_base {
  float prob;
  int id;
} bef_ai_face_occlusion_info_base, *p_bef_ai_face_occlusion_info_base;

//  {zh} brief  mask类型枚举  {en} Brief mask type enumeration
typedef enum {
    BEF_FACE_DETECT_MOUTH_MASK = 1,
    BEF_FACE_DETECT_TEETH_MASK = 2,
    BEF_FACE_DETECT_FACE_MASK = 3,
} bef_face_mask_type;


/** {zh} 
 * @brief 创建人脸检测的句柄
 * @param [in] config Config of face detect algorithm 人脸检测算法的配置
 * 图片模式： BEF_DETECT_SMALL_MODEL| BEF_DETECT_MODE_IMAGE | BEF_DETECT_FULL
 * 视频模式： BEF_DETECT_SMALL_MODEL| BEF_DETECT_MODE_VIDEO | BEF_DETECT_FULL
 * 图片稍慢模式： BEF_DETECT_SMALL_MODEL| BEF_DETECT_MODE_IMAGE_SLOW | BEF_DETECT_FULL
 *
 * @param [in] strModelPath 模型文件所在路径
 * @param [out] handle Created face detect handle
 *                     创建的人脸检测句柄
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Create a handle for face detection
 * @param  [in] config Config of face detection algorithm Configuration of face detection algorithm
 * Picture mode: BEF_DETECT_SMALL_MODEL | BEF_DETECT_MODE_IMAGE | BEF_DETECT_FULL
 * Video mode: BEF_DETECT_SMALL_MODEL | BEF_DETECT_MODE_VIDEO | BEF_DETECT_FULL
 * Picture slightly slower mode: BEF_DETECT_SMALL_MODEL | BEF_DETECT_MODE_IMAGE_SLOW | BEF_DETECT_FULL
 *
 * @param  [in] strModelPath model file path
 * @param  [out] handle Created face detection handle
 *                     If
 * @return succeed return BEF_RESULT_SUC, other values please see .h Successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details.
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 /Users/vunguyen/Desktop/Projects/GoGame/BytePlus_Effects_SDK_V4.3.1_standard/byted_effect_ios/iossample_static/Pods/Headers/Public/BytedEffectSDK/bef_effect_ai_face_verify.h:207:16: Parameter 'Handle' not found in the function declaration */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_detect_create(
                                 unsigned long long config,
                                 const char * strModelPath,
                                 bef_effect_handle_t *handle
                                 );

/** {zh} 
 * @brief 人脸检测
 * @param [in] handle Created face detect handle
 *                    已创建的人脸检测句柄
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
 * @param [in] detect_config Config of face detect, for example, BEF_FACE_DETECT | BEF_DETECT_EYEBALL | BEF_BROW_JUMP
 *                           人脸检测相关的配置
 * @return If succeed return BEF_RESULT_SUC, other value please see bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face detection
 * @param  [in] Handle Created face detection handle
 *                    Created face detection handle
 * @param  [in] Image Image base address
 *                   Data pointer of the input image
 * @param  [in] pixel_format Pixel format of input image
 *                          Format of the input image
 * @param  [in] image_width Image width
 *                          Width of the input image in pixels
 * @param  [in] image_height Image height
 *                          Height of the input image in pixels
 * @param  [in] image_stride Image stride in each row
 *                          Step size of each row of the input image in pixels
 * @param  [in] orientation Image orientation
 *                         The steering of the input image, please refer to the bef_rotate_type in bef_effect_ai_public_define h
 * @param  [in] detect_config Config of face detection, for example, BEF_FACE_DETECT | BEF_DETECT_EYEBALL | BEF_BROW_JUMP
 *                           Configuration related to face detection
 * @return If succeed return, other values please see bef_effect_ai_public_define h
 *         Successfully return, BEF_RESULT_SUC fail to return the corresponding error code, please refer to bef_effect_ai_public_define h
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_detect(
                          bef_effect_handle_t handle,
                          const unsigned char *image,
                          bef_ai_pixel_format pixel_format,
                          int image_width,
                          int image_height,
                          int image_stride,
                          bef_ai_rotate_type orientation,
                          unsigned long long detect_config,
                          bef_ai_face_info *p_face_info
                          );

typedef enum {
    //  {zh} 设置每隔多少帧进行一次人脸检测(默认值有人脸时24, 无人脸时24/3=8), 值越大,  {en} Set how many frames are used for face detection (the default value is 24 when there is a face, 24/3 = 8 when there is no face), the larger the value,
    //  {zh} cpu占用率越低, 但检测出新人脸的时间越长.  {en} The lower the CPU occupancy rate, the longer it takes to detect new faces.
    BEF_FACE_PARAM_FACE_DETECT_INTERVAL = 1,  // default 24
    //  {zh} 设置能检测到的最大人脸数目(默认值5),  {en} Set the maximum number of faces that can be detected (default value 5),
    //  {zh} 当跟踪到的人脸数大于该值时，不再进行新的检测. 该值越大, 但相应耗时越长.  {en} When the number of tracked faces is greater than this value, no new detection is performed. The larger the value, the longer the corresponding time consumption.
    //  {zh} 设置值不能大于 AI_MAX_FACE_NUM  {en} The setting value cannot be greater than AI_MAX_FACE_NUM
    BEF_FACE_PARAM_MAX_FACE_NUM = 2,  // default 5
    //  {zh} 动态调整能够检测人脸的大小，视频模式强制是4，图片模式可以通过设置为8，检测更小的人脸，检测级别，越高代表能检测更小的人脸，取值范围：4～10  {en} Dynamic adjustment can detect the size of the face, the video mode is forced to 4, the picture mode can be set to 8, detect smaller faces, detection level, the higher the representative can detect smaller faces, the value range: 4~ 10
    BEF_FACE_PARAM_MIN_DETECT_LEVEL = 3,
    //  {zh} base 关键点去抖参数，[1-30]  {en} Base key point debuffeting parameters, [1-30]
    BEF_FACE_PARAM_BASE_SMOOTH_LEVEL = 4,
    //  {zh} extra 关键点去抖参数，[1-30]  {en} Extra key points to shake parameters, [1-30]
    BEF_FACE_PARAM_EXTRA_SMOOTH_LEVEL = 5,
    //  {zh} 嘴巴 mask 去抖动参数， [0-1], 默认0， 平滑效果更好，速度更慢  {en} Mouth mask dejitter parameter, [0-1], default 0, better smoothing effect, slower speed
    BEF_FACE_PARAM_MASK_SMOOTH_TYPE = 6,
} bef_face_detect_type;


/** {zh} 
 * @brief Set face detect parameter based on type 设置人脸检测的相关参数
 * @param [in] handle Created face detect handle
 *                    已创建的人脸检测句柄
 * @param [in] type Face detect type that needs to be set, check bef_face_detect_type for the detailed
 *                  需要设置的人体检测类型，可参考 bef_face_detect_type
 * @param [in] value Type value, check bef_face_detect_type for the detailed
 *                   参数值, 具体请参数 bef_face_detect_type 枚举中的说明
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Set face detection parameter based on type Set the relevant parameters of face detection
 * @param  [in] handle Created face detection handle
 *                     created face detection handle
 * @param  [in] type Face detection type that needs to be set, check bef_face_detect_type for the detailed
 *                  The human body detection type that needs to be set can refer to bef_face_detect_type
 * @param  [in] value Type value, check bef_face_detect_type for the detailed
 *                    parameter value, please specify the parameter bef_face_detect_type description in the enumeration
 * @return If succeed return BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define. H
 *          successfully return BEF_RESULT_SUC, fail to return the corresponding error code, please refer to bef_effect_ai_public_define for details.
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_detect_setparam(
                                   bef_effect_handle_t handle,
                                   bef_face_detect_type type,
                                   float value
                                   );
/* {zh} 
 *@brief 初始化handle
 *@param [in] config 指定240模型的模型参数，创建240或者280
 *Config-240，TT_MOBILE_FACE_240_DETECT
 *Config-280，TT_MOBILE_FACE_280_DETECT
 *Config-240 快速模式, TT_MOBILE_FACE_240_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE
 *Config-280 快速模式, TT_MOBILE_FACE_280_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE
 *@param [in] param_path 模型的文件路径
 */
/* {en} 
 *@brief Initialize handle
 *@param  [in] config Specify the model parameters of the 240 model, create 240 or 280
 *Config-240, TT_MOBILE_FACE_240_DETECT
 *Config-280, TT_MOBILE_FACE_280_DETECT
 *Config-240 fast mode, TT_MOBILE_FACE_240_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE
 *Config-280 fast mode, TT_MOBILE_FACE_280_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE
 *@param  [in] param_path the file path of the model
 */
BEF_SDK_API bef_effect_result_t
bef_effect_ai_face_detect_add_extra_model(
                                          bef_effect_handle_t handle,
                                          unsigned long long config, //  {zh} 配置config，创建240或者280  {en} Configure config, create 240 or 280
                                          // Config-240，TT_MOBILE_FACE_240_DETECT
                                          // Config-280，TT_MOBILE_FACE_280_DETECT
                                          //  {zh} Config-240 快速模式, TT_MOBILE_FACE_240_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE  {en} Config-240 Fast Mode, TT_MOBILE_FACE_240_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE
                                          //  {zh} Config-280 快速模式, TT_MOBILE_FACE_280_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE  {en} Config-280 Fast Mode, TT_MOBILE_FACE_280_DETECT | TT_MOBILE_FACE_240_DETECT_FASTMODE
                                          const char *param_path
                                          );

/** {zh} 
 * @brief 获取不同类型的mask输出
 *
 */
/** {en} 
 * @brief Get different types of mask output
 *
 */
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_mask_detect(bef_effect_handle_t handle,unsigned long long config, bef_face_mask_type mask_type, void * result);

/** {zh} 
 * @param [in] handle Destroy the created face detect handle
 *                    销毁创建的人脸检测句柄
 */
/** {en} 
 * @param [In] Handle Destroy the created face detection handle
 *                    Destroy the created face detection handle
 */
BEF_SDK_API void
bef_effect_ai_face_detect_destroy(
                                  bef_effect_handle_t handle
                                  );

/** {zh} 
 * @brief 人脸检测授权
 * @param [in] handle Created face detect handle
 *                    已创建的人脸检测句柄
 * @param [in] license 授权文件字符串
 * @param [in] length  授权文件字符串长度
 * @return If succeed return BEF_RESULT_SUC, other value please refer bef_effect_ai_public_define.h
 *         成功返回 BEF_RESULT_SUC, 授权码非法返回 BEF_RESULT_INVALID_LICENSE ，其它失败返回相应错误码, 具体请参考 bef_effect_ai_public_define.h
 */
/** {en} 
 * @brief Face detection authorization
 * @param  [in] handle Created face detection handle
 *                    created face detection handle
 * @param  [in] license authorization file character string
 * @param  [in] length authorization file character string length
 * @return If succeed returns BEF_RESULT_SUC, other values please refer to bef_effect_ai_public_define h
 *         successfully returned BEF_RESULT_SUC, authorization code returned illegally BEF_RESULT_INVALID_LICENSE, other failures returned corresponding error codes, please refer to bef_effect_ai_public_define for details.
 */
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_check_license(JNIEnv *env, jobject context,
                                                                 bef_effect_handle_t handle,
                                                                 const char *licensePath);
#else
#ifdef __APPLE__
BEF_SDK_API bef_effect_result_t bef_effect_ai_face_check_license(bef_effect_handle_t handle, const char *licensePath);
#endif
#endif


BEF_SDK_API bef_effect_result_t bef_effect_ai_face_check_online_license(bef_effect_handle_t handle, const char *licensePath);

#endif // _BEF_EFFECT_FACE_DETECT_AI_H_
