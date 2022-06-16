//
//  BEAlgorithmTask.h
//  BytedEffectSDK
//
//  Created by qun on 2021/5/11.
//

#ifndef BEAlgorithmTask_h
#define BEAlgorithmTask_h

#import <Foundation/Foundation.h>
#import "bef_effect_ai_public_define.h"
#import "bef_effect_ai_error_code_format.h"
#import "BEAlgorithmKey.h"
#import "BETimeRecoder.h"
#import "Core.h"
#import "BELicenseHelper.h"

@protocol BEAlgorithmResourceProvider <NSObject>

@end

@interface BEAlgorithmTask : NSObject

@property (nonatomic, strong) id<BEAlgorithmResourceProvider> provider;
@property (nonatomic, strong) id<BELicenseProvider> licenseProvider;

//   {zh} / @brief 构造函数     {en} /@brief constructor 
// {zh} / @details 需要传入一个 BEAlgorithmResourceProvider，每一个算法所需要的资源文件不尽相同， {en} /@details need to pass in a BEAlgorithmResourceProvider, each algorithm needs different resource files,
//   {zh} / 所以每一个算法都会有单独的实现，比如人脸检测的 BEFaceResourceProvider，这只是一个 protocol，     {en} /So each algorithm will have a separate implementation, such as BEFaceResourceProvider for face detection, which is just a protocol, 
//   {zh} / 需要另外实现的，可以直接用工程中的 BEAlgorithmResourceHelper 实现类，它可以拿到所有算法所需要的资源。     {en} If you need to implement it separately, you can directly use the BEAlgorithm ResourceHelper implementation class in the project, which can get all the resources needed by the algorithm. 
// {zh} / @param provider 算法资源提供类 {en} /@param provider algorithm resource provider class
- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>) licenseProvider;

+ (BEAlgorithmKey *)ALGORITHM_FOV;

//   {zh} / @brief 初始化算法     {en} /@Brief initialization algorithm 
// {zh} / @details 调用了这个函数之后才会进行算法的初始化。 {en} /@details The algorithm will not be initialized until this function is called.
- (int)initTask;

// {zh} / @brief 算法调用 {en} /@brief algorithm call
//   {zh} / @details 输入为 buffer，输出这里是直接定义为 id，每一个算法会单独实现这个函数，     {en} /@details input is buffer, output here is directly defined as id, each algorithm will implement this function separately, 
//   {zh} / 返回值也是每个算法不同的，返回结果定义在各算法的头文件中，如 BEFaceAlgorithmResult。     {en} /The return value is also different for each algorithm, and the return result is defined in the header file of each algorithm, such as BEFaceAlgorithmResult. 
/// @param buffer buffer
//   {zh} / @param width 宽     {en} /@param width 
// {zh} / @param height 高 {en} /@param height
//   {zh} / @param stride 行宽，对于 RGBA 格式而言，一般是 width * 4     {en} /@param stride width, for RGBA format, generally width * 4 
//   {zh} / @param format buffer 格式     {en} /@param format buffer format 
// {zh} / @param rotation buffer 旋转角度 {en} /@param rotation buffer rotation angle
- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation;

//   {zh} / @brief 销毁算法     {en} /@Brief destruction algorithm 
- (int)destroyTask;

//   {zh} / @brief 设置算法参数     {en} /@Briefly set algorithm parameters 
// {zh} / @details 这个函数用于设置算法参数，每一个算法都有不同的参数 key，定义在各算法的头文件中， {en} /@details This function is used to set algorithm parameters. Each algorithm has a different parameter key, which is defined in the header file of each algorithm.
//   {zh} / 如 BEFaceAlgorithmTask.FACE_280 。     {en} /As BEFaceAlgorithmTask.FACE_280. 
// {zh} / @param key 参数 key {en} /@param key parameter key
//   {zh} / @param p 参数值     {en} /@param p parameter value 
- (void)setConfig:(BEAlgorithmKey *)key p:(NSObject *)p;

//   {zh} / @brief 最小检测尺寸     {en} /@Brief minimum detection size 
//   {zh} / @details 返回一个数组，分别为最小检测尺寸的宽、高，需要保证传入的图像尺寸不小于这个值。     {en} /@details Returns an array of the width and height of the minimum detection size respectively. It is necessary to ensure that the incoming image size is not less than this value. 
- (float *)preferSize;

//   {zh} / @brief 算法的 key     {en} /@Brief algorithm key 
- (BEAlgorithmKey *)key;

// protected
- (BOOL)boolConfig:(BEAlgorithmKey *)key orDefault:(BOOL)orDefault;
- (float)floatConfig:(BEAlgorithmKey *)key orDefault:(float)orDefault;

@end

#endif /* BEAlgorithmTask_h */
