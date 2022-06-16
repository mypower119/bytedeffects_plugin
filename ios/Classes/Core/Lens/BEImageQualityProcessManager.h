//
//  BEImageQualityProcessManager.h
//  BytedEffects
//
//  Created by Bytedance on 2020/12/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEImageQualityProcessManager_h
#define BEImageQualityProcessManager_h

#import "BEVideoSRTask.h"
#import "BEAdaptiveSharpenTask.h"
#import <CoreVideo/CVPixelBuffer.h>

typedef union ImageQualityDataInternal{
    CVPixelBufferRef pixelBuffer;
    unsigned int texture[2];
}ImageQualityDataInternal;

typedef NS_ENUM(NSInteger, ImageQualityDataType){
    ImageQualityDataTypeCVPixelBuffer,
    ImageQualityDataTypeOpenGlTexture,
    ImageQualityDataTypeMetalTexture,
};

typedef struct ImageQualityProcessData
{
    ImageQualityDataType type;
    ImageQualityDataInternal data;
    
}ImageQualityProcessData;

typedef NS_ENUM(NSInteger, ImageQualityProcessFinishStatus)
{
    ImageQualityProcessFinishStatusDoNothing = 0, // do nothing
    ImageQualityProcessFinishStatusSuccess,   // success
    ImageQualityProcessFinishStatusError,     // error happened, the reason need to review the log
    ImageQualityProcessFinishStatusSuccessNewPixelBuffer // success and new new pixelBuffer, means user the release it after all the use
};

@protocol BEImageQualityResourceProvider <BEVideoSRResourceProvider, BEAdaptiveSharpenResourceProvider>

@end

@interface BEImageQualityProcessManager : NSObject

//   {zh} / @brief 构造函数     {en} /@brief constructor 
//   {zh} / @details 需要传入一个 BEImageQualityResourceProvider，一般情况下，     {en} /@details need to pass in a BEImageQualityResourceProvider, in general, 
//   {zh} / 可以直接用工程中的 BELensResourceHelper 实现类。     {en} /You can directly implement the class with the BELensResourceHelper in the project. 
//   {zh} / @param provider 资源提供类     {en} /@param provider class 
- (instancetype)initWithProvider:(id<BELicenseProvider>)provider;

//   {zh} / @brief SDK 调用     {en} /@brief SDK call 
//   {zh} / @details 需要给函数两个参数，分别为输入、输出数据，输入输出目前都仅支持 CVPixelBuffer     {en} /@details need to give the function two parameters, respectively, input and output data, input and output currently only support CVPixelBuffer 
//   {zh} / @param input 输入数据     {en} /@param input data 
//   {zh} / @param output 输出数据     {en} /@param output data 
-(ImageQualityProcessFinishStatus)imageQualityProcess:(const ImageQualityProcessData*)input output:(ImageQualityProcessData*)output;

@property (nonatomic, assign)bool enableVideoSr;
@property (nonatomic, assign)bool enableAdaptiveSharpen;

//Control whether do all the image quality work
@property (nonatomic, assign)bool pause;

//   {zh} / @brief 是否开启视频超分     {en} /@Briefing whether to turn on video super score 
//   {zh} / @param enableVideoSr 视频超分     {en} /@param enableVideoSr 
- (void)setEnableVideoSr:(bool)enableVideoSr;

//   {zh} / @brief 是否开启自适应锐化     {en} /@Briefing whether to turn on adaptive sharpening 
//   {zh} / @param enableAdaptiveSharpen 自适应锐化     {en} /@param enableAdaptiveSharpen 
- (void)setEnableAdaptiveSharpen:(bool)enableAdaptiveSharpen;

@end

#endif /* BEImageQualityProcessManager_h */
