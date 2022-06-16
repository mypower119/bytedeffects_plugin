#ifndef BEF_AI_IMAGE_QUALITY_ENHANCEMENT_PUBLICE_DEFINE_H
#define BEF_AI_IMAGE_QUALITY_ENHANCEMENT_PUBLICE_DEFINE_H

#include <stddef.h>
#include "bef_effect_ai_public_define.h"
#include <stdint.h>

//**************  common begin *****************************
#define bef_effect_result_t int

typedef union bef_ai_lens_data{
    int texture[2]; //  {zh} 如果是纹理，这里纹理的index, ios 的纹理目前只支持metal的纹理, android 需要oes 纹理，且纹理放在0 位置  {en} If it is a texture, the index of the texture here, the texture of ios currently only supports metal texture, android needs oes texture, and the texture is placed at 0 position
    void* buffer;   //  {zh} 如果是数据输入，iOS 传入pixelBuffer的指针  {en} If it is data input, iOS pass pointer to pixelBuffer
}bef_ai_lens_data;

#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
typedef enum bef_ai_lens_power_level{
    BEF_AI_LENS_POWER_LEVEL_DEFAULT = 0,
    BEF_AI_LENS_POWER_LEVEL_LOW,
    BEF_AI_LENS_POWER_LEVEL_NORMAL,
    BEF_AI_LENS_POWER_LEVEL_HIGH,
    BEF_AI_LENS_POWER_LEVEL_AUTO,
} bef_ai_lens_power_level;

#endif

typedef enum bef_ai_lens_data_type{
    BEF_AI_LENS_ANDROID_TEXTURE_RGBA,
    BEF_AI_LENS_ANDROID_TEXTURE_OES,
    BEF_AI_LENS_METAL_TEXTURE_RGBA,
    BEF_AI_LENS_PXIELBUFFER_NV12,
    BEF_AI_LENS_METAL_TEXTURE_NV12,
}bef_ai_lens_data_type;


//**************  common end *****************************
typedef struct bef_ai_video_sr_input{
    int width;   //  {zh} 输入数据的宽度  {en} Width of input data
    int height;  //  {zh} 输入数据的高度  {en} Height of input data
    bef_ai_lens_data data;   //  {zh} 输入数据的数据  {en} Input data
    bef_ai_lens_data_type type; //  {zh} 输入数据的类型，iOS 支持pixelbuffer 输出，Android 支持oes 纹理  {en} Type of input data, iOS support pixelbuffer output, Android support oes texture
}bef_ai_video_sr_input;

typedef struct bef_ai_video_sr_output{
    bef_ai_lens_data data;   //  {zh} 输出类型数据，会根据输入，填充对应的输出部分  {en} The output type data will be filled with the corresponding output part according to the input
    int width;   //  {zh} 输出数据的宽度  {en} Width of output data
    int height;  //  {zh} 输入数据的高度  {en} Height of input data
}bef_ai_video_sr_output;

typedef struct bef_ai_night_scene_data{
    int width;   //  {zh} 输入数据的宽度  {en} Width of input data
    int height;  //  {zh} 输入数据的高度  {en} Height of input data
    bef_ai_lens_data data;   //  {zh} 输入数据的数据  {en} Input data
    bef_ai_lens_data_type type; //  {zh} 输入数据的类型 iOS暂时不支持 Android 支持oes 纹理  {en} Type of input data iOS Temporarily not supported for Android support oes texture
}bef_ai_night_scene_data;

typedef enum bef_ai_lens_backend_type
{
    BEF_AI_LENS_BACKEND_GPU = 0,
}bef_ai_lens_backend_type;


//**************  video  super resolution begin *****************************
 # if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
typedef struct bef_ai_video_sr_init_config
{
    const char* bin_path;   //  {zh} 传入的路径必须是存在并且有读写权限，超分算法会读写文件，这个路径需要外部传递进来  {en} The incoming path must exist and have read and write permissions. The super-score algorithm will read and write files. This path needs to be passed in externally
    bool ext_oes_texture;   //  {zh} 是否是oes 纹理  {en} Is it an oes texture?
    int max_height;         //  {zh} 算法输入图片的分辨率 (max_height, max_width), 创建的时候设定，避免频繁申请释放内存  {en} Algorithm input image resolution (max_height, max_width), set when creating, avoid frequent applications to free memory
    int max_width;
    void* filter_ptr;       //  {zh} 目前传null  {en} Current null
    int filter_size;        //  {zh} 目前传0  {en} Current pass 0
    float thresh;           //  {zh} 暂时不用设置  {en} No settings for now
    bef_ai_lens_data_type  input_type;       //  {zh} 输入类型  {en} Input Type
    bef_ai_lens_power_level power_level;    //  {zh} 传入频率设置等级，默认为auto等级（default是指随系统调节，low是使用低频率，normal是使用中频率，high是使用高频率，auto是sdk内部根据机型自动调节）  {en} Incoming frequency setting level, default is auto level (default refers to adjustment with the system, low is to use low frequency, normal is to use medium frequency, high is to use high frequency, auto is to automatically adjust according to the model internally in sdk)
    //  {zh} bef_ai_lens_backend_type backend_type;  // 目前仅支持GPU平台  {en} bef_ai_lens_backend_type backend_type;//Currently only supports GPU platforms
}bef_ai_video_sr_init_config;

#elif  defined(__APPLE__)
typedef struct bef_ai_video_sr_init_config
{
    const char* model_path;     //  {zh} 模型文件的路径  目前不需要传入  {en} The path to the model file, which currently does not need to be passed in
    int model_data_length;      //  {zh} 目前不需要传入  {en} No incoming currently required
    const char* metal_path;     //  {zh} 目前不需要传入  {en} No incoming currently required
    bool enable_mem_pool;       //  {zh} 是否使用内存池，短视频场景下使用  {en} Whether to use memory pool, use in short video scenes
    bef_ai_lens_data_type input_type;   //  {zh} 输入目前只有pixelbuffer格式  {en} The input is currently only in pixelbuffer format
    bef_ai_lens_data_type output_type;  //  {zh} 输出为pixelbuffer和 metal texture两种  {en} The output is pixelbuffer and metal texture
    float float_thresh;         //  {zh} 暂时不用设置  {en} No settings for now
}bef_ai_video_sr_init_config;
#endif


//**************  video  super resolution end *****************************

//**************  adaptive sharpen begin *****************************
// {zh} 自适应锐化支持的场景 {en} Adaptive sharpening supported scenes
typedef enum bef_ai_asf_scene_mode
{
    BEF_AI_LENS_ASF_SCENE_MODE_LIVE_GAME = 0,   // {zh} 游戏 {en} Game
    BEF_AI_LENS_ASF_SCENE_MODE_LIVE_PEOPLE,     //  {zh} 秀场  {en} Show
    BEF_AI_LENS_ASF_SCENE_MODE_EDIT,            //  {zh} 视频编辑  {en} Video editing
    BEF_AI_LENS_ASF_SCENE_MODE_RECORED_MAIN,    //  {zh} 主摄录制  {en} Main camera recording
    BEF_AI_LENS_ASF_SCENE_MODE_RECORED_FRONT    //  {zh} 前摄录制  {en} Proactive recording
}bef_ai_asf_scene_mode;


typedef struct bef_ai_asf_init_config{
    bef_ai_asf_scene_mode scene_mode;   // {zh} 场景模式 {en} Scene Mode
    void* context; // {zh} iOS端可以传入外部metal device，如果为nullptr，则在lens内部新建device {en} iOS can be passed into an external metal device, if it is nullptr, a new device is created inside the lens
#if defined(__ANDROID__) || defined(TARGET_OS_ANDROID)
    bef_ai_lens_power_level level; // {zh} iOS端无需设置 {en} iOS side does not need to be set up
#endif
    bef_ai_lens_data_type input_type; //  {zh} 输入数据的类型  {en} Type of input data
    bef_ai_lens_data_type output_type; //  {zh} 输出数据的类型  {en} Type of output data
    
    int frame_width;// {zh} 视频宽度 {en} Video Width
    int frame_height;// {zh} 视频高度 {en} Video height
    float amount;// {zh} 锐化强度增益，默认-1（无效值），即不调整。 有效值为>0：当设置>1时，会增大锐化强度，设置<1时，减弱锐化强度。 {en} Sharpening strength gain, default -1 (invalid value), that is, no adjustment. The effective value is > 0: When setting > 1, the sharpening strength will be increased, and when setting < 1, the sharpening strength will be weakened.
    float over_ratio;// {zh} 黑白边的容忍度增益，默认-1（无效值），即不调整。有效值为>0：当amount>1时，如果发现增大amount清晰度没有明显增加，可能需要稍微增大over_ratio，经验公式为：over_ratio= 1+ a * (amount -1)，其中比例系数a可调整，属于0～1范围。 {en} Tolerance gain of black and white edges, default -1 (invalid value), that is, no adjustment. The effective value is > 0: When amount > 1, if it is found that increasing amount clarity does not increase significantly, it may need to increase the over_ratio slightly, the empirical formula is: over_ratio = 1 + a * (amount -1), where the scale coefficient a is adjustable and belongs to the range of 0~ 1.
    float edge_weight_gamma;// {zh} 对中低频边缘的锐化强度进行调整， 默认-1（无效值），即 不调整。有效值为>0 {en} Adjust the sharpening intensity of the middle and low frequency edges, default -1 (invalid value), that is, no adjustment. The effective value is > 0
    int diff_img_smooth_enable;// {zh} 开启后减少锐化带来的边缘artifacts，但锐化强度会比关闭时弱一些， 默认-1（无效值），即保持内部设置，目前设置为开启。 有效值为0或1，0--关闭，1--开启 {en} After turning on, reduce the edge artifacts caused by sharpening, but the sharpening strength will be weaker than when turned off, the default -1 (invalid value), that is, keep the internal settings, currently set to turn on. Valid value is 0 or 1, 0 - off, 1 - on

}bef_ai_asf_init_config;

typedef struct bef_ai_asf_input{
    bef_ai_lens_data data;   //  {zh} 输入数据的数据  {en} Input data
    bef_ai_lens_data_type type;//  {zh} 输入数据格式  {en} Input data format
}bef_ai_asf_input;

typedef struct bef_ai_asf_output{
    bef_ai_lens_data data;   //  {zh} 输出类型数据，会根据输入，填充对应的输出部分  {en} The output type data will be filled with the corresponding output part according to the input
    bef_ai_lens_data_type type;//  {zh} 输入数据格式  {en} Input data format
}bef_ai_asf_output;

typedef struct bef_ai_asf_property{
    bef_ai_asf_scene_mode scene_mode;   // {zh} 场景模式 {en} Scene Mode
    int frame_width;// {zh} 视频宽度 {en} Video Width
    int frame_height;// {zh} 视频高度 {en} Video height
    float amount;// {zh} 锐化强度增益，默认-1（无效值），即不调整。 有效值为>0：当设置>1时，会增大锐化强度，设置<1时，减弱锐化强度。 {en} Sharpening strength gain, default -1 (invalid value), that is, no adjustment. The effective value is > 0: When setting > 1, the sharpening strength will be increased, and when setting < 1, the sharpening strength will be weakened.
    float over_ratio;// {zh} 黑白边的容忍度增益，默认-1（无效值），即不调整。有效值为>0：当amount>1时，如果发现增大amount清晰度没有明显增加，可能需要稍微增大over_ratio，经验公式为：over_ratio= 1+ a * (amount -1)，其中比例系数a可调整，属于0～1范围。 {en} Tolerance gain of black and white edges, default -1 (invalid value), that is, no adjustment. The effective value is > 0: When amount > 1, if it is found that increasing amount clarity does not increase significantly, it may need to increase the over_ratio slightly, the empirical formula is: over_ratio = 1 + a * (amount -1), where the scale coefficient a is adjustable and belongs to the range of 0~ 1.
    float edge_weight_gamma;// {zh} 对中低频边缘的锐化强度进行调整， 默认-1（无效值），即 不调整。有效值为>0 {en} Adjust the sharpening intensity of the middle and low frequency edges, default -1 (invalid value), that is, no adjustment. The effective value is > 0
    int diff_img_smooth_enable;// {zh} 开启后减少锐化带来的边缘artifacts，但锐化强度会比关闭时弱一些， 默认-1（无效值），即保持内部设置，目前设置为开启。 有效值为0或1，0--关闭，1--开启 {en} After turning on, reduce the edge artifacts caused by sharpening, but the sharpening strength will be weaker than when turned off, the default -1 (invalid value), that is, keep the internal settings, currently set to turn on. Valid value is 0 or 1, 0 - off, 1 - on
}bef_ai_asf_property;

//**************  adaptive sharpen end *****************************

typedef uint64_t bef_image_quality_enhancement_handle;
#endif 
