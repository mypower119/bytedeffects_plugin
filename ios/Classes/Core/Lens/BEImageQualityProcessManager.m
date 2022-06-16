//
//  BEImageQualityProcessManager.m
//  BytedEffects
//
//  Created by Bytedance on 2020/12/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEImageQualityProcessManager.h"
#import "BEVideoSRTask.h"
#import "BEAdaptiveSharpenTask.h"
#import "BEImageOpeartion.h"

@interface BEImageQualityProcessManager()

@property (nonatomic, strong) BEVideoSRTask* videoSrTask;
@property (nonatomic, strong) BEAdaptiveSharpenTask* adapterSharpenTask;
@property (nonatomic, strong) id<BELicenseProvider> provider;

@end

@implementation BEImageQualityProcessManager

- (instancetype)initWithProvider:(id<BELicenseProvider>)provider {
    self = [super init];
    if (self) {
        _videoSrTask = nil;
        _adapterSharpenTask = nil;
        _enableVideoSr = false;
        _enableAdaptiveSharpen = false;
        _pause = false;
        _provider = provider;
    }
    return self;
}


/// Close all the inited task when dealloc
-(void)dealloc{
    if (_videoSrTask){ // Means we should destory it
        [_videoSrTask destroyTask];
        _videoSrTask = nil;
    }
    
    if(_adapterSharpenTask)
    {
        [_adapterSharpenTask destroyTask];
        _adapterSharpenTask = nil;
    }
}

#pragma mark - public
-(ImageQualityProcessFinishStatus)imageQualityProcess:(const ImageQualityProcessData*)input output:(ImageQualityProcessData*)output{
    int ret = ImageQualityProcessFinishStatusDoNothing;
    CVPixelBufferRef destBuffer  = NULL;
    
    /// If paused just do nothing
    if (_pause){
        return ImageQualityProcessFinishStatusDoNothing;
    }
    
    // Whether do the video superpixel
    if (_enableVideoSr){
        if (_videoSrTask){ // process when inited
            // Only support yuv420f yuv420p at now
            if (input->type == ImageQualityDataTypeCVPixelBuffer){
                CVPixelBufferRef srcBuffer = input->data.pixelBuffer;
                OSType srcType = CVPixelBufferGetPixelFormatType(srcBuffer);
                CVPixelBufferRef inputBuffer = NULL;
                
                ///First, gen a new CVPixelbuffer if need
                {
                    if (srcType != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange && srcType != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange){
                        inputBuffer = [self formtChangeIfNeeded:srcBuffer destFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
                    }
                }
                
                /// Second, process the buffer
                {
                    if (inputBuffer != nil){
                        destBuffer = [_videoSrTask processCVPixelBuffer:inputBuffer];
                        CVPixelBufferRelease(inputBuffer);
                    }else {
                        destBuffer = [_videoSrTask processCVPixelBuffer:srcBuffer];
                    }
                }
                
                /// Third, gen a dest  format cvpixelbuffer is need
                {
                    if (destBuffer != NULL){
                        //   {zh} / 这里一定retain，不然当加速进行转换的时候有，会出现bad_access     {en} /It must be retained here, otherwise there will be bad_access when accelerating the conversion 
                        CVPixelBufferRetain(destBuffer);
                        CVPixelBufferRef outputBuffer = [self formtChangeIfNeeded:destBuffer destFormat:kCVPixelFormatType_32BGRA];
                        CVPixelBufferRelease(destBuffer);
                        
                        if (outputBuffer){
                            output->type = ImageQualityDataTypeCVPixelBuffer;
                            output->data.pixelBuffer = outputBuffer;
                            
                            return ImageQualityProcessFinishStatusSuccessNewPixelBuffer;
                        }else {
                            output->type = ImageQualityDataTypeCVPixelBuffer;
                            output->data.pixelBuffer = destBuffer;
                            
                            return ImageQualityProcessFinishStatusSuccess;
                        }
                    }else {
                        return ImageQualityProcessFinishStatusError;
                    }
                }
            }
        }
    }
    else if(_enableAdaptiveSharpen)
    {
        if (_adapterSharpenTask){ // process when inited
            // Only support yuv420f yuv420p at now
            if (input->type == ImageQualityDataTypeCVPixelBuffer){
                CVPixelBufferRef srcBuffer = input->data.pixelBuffer;
                OSType srcType = CVPixelBufferGetPixelFormatType(srcBuffer);
                CVPixelBufferRef inputBuffer = NULL;
                
                ///First, gen a new CVPixelbuffer if need
                {
                    if (srcType != kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange && srcType != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange){
                        inputBuffer = [self formtChangeIfNeeded:srcBuffer destFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
                    }
                }
                
                /// Second, process the buffer
                {
                    if (inputBuffer != nil){
                        destBuffer = [_adapterSharpenTask processCVPixelBuffer:inputBuffer];
                        CVPixelBufferRelease(inputBuffer);
                    }else {
                        destBuffer = [_adapterSharpenTask processCVPixelBuffer:srcBuffer];
                    }
                }
                
                /// Third, gen a dest  format cvpixelbuffer is need
                {
                    if (destBuffer != NULL){
                        //   {zh} / 这里一定retain，不然当加速进行转换的时候有，会出现bad_access     {en} /It must be retained here, otherwise there will be bad_access when accelerating the conversion 
                        CVPixelBufferRetain(destBuffer);
                        CVPixelBufferRef outputBuffer = [self formtChangeIfNeeded:destBuffer destFormat:kCVPixelFormatType_32BGRA];
                        CVPixelBufferRelease(destBuffer);
                        
                        if (outputBuffer){
                            output->type = ImageQualityDataTypeCVPixelBuffer;
                            output->data.pixelBuffer = outputBuffer;
                            
                            return ImageQualityProcessFinishStatusSuccessNewPixelBuffer;
                        }else {
                            output->type = ImageQualityDataTypeCVPixelBuffer;
                            output->data.pixelBuffer = destBuffer;
                            
                            return ImageQualityProcessFinishStatusSuccess;
                        }
                    }else {
                        return ImageQualityProcessFinishStatusError;
                    }
                }
            }
        }
    }
    
    /// If nothing happend, we also need the change format to support other sdk
    destBuffer = [self formtChangeIfNeeded:input->data.pixelBuffer destFormat:kCVPixelFormatType_32BGRA];
    
    if (destBuffer){
        output->data.pixelBuffer = destBuffer;
        output->type = ImageQualityDataTypeCVPixelBuffer;
        ret = ImageQualityProcessFinishStatusSuccessNewPixelBuffer;
    }
    return ret;
}


#pragma mark - private change CVPixelbuffer format if needed

-(CVPixelBufferRef)formtChangeIfNeeded:(CVPixelBufferRef)srcBuffer destFormat:(OSType)destFormat
{
    BEImageBufferOperation *imageOp = [BEImageBufferOperation sharedInstance];
    return [imageOp transforPixelbuffer:srcBuffer destFormat:destFormat];
}

#pragma  mark - setter
-(void)setEnableVideoSr:(bool)enableVideoSr{
    // Dont't need to de anything
    if (_enableVideoSr == enableVideoSr)
        return ;
    
    if (enableVideoSr){
        if (!_videoSrTask){ // If not inited, we should init one
            _videoSrTask = [[BEVideoSRTask alloc]init];
            _videoSrTask.provider = self.provider;
            
            if ([_videoSrTask initTask]){ // No zero means initlization error
                _videoSrTask = nil;
            }
        }
    }else {
        if (_videoSrTask){ // Means we should destory it
            [_videoSrTask destroyTask];
            _videoSrTask = nil;
        }
    }
    _enableVideoSr = enableVideoSr;
}

- (void)setEnableAdaptiveSharpen:(bool)enableAdaptiveSharpen
{
    // Dont't need to de anything
    if (_enableAdaptiveSharpen == enableAdaptiveSharpen)
        return ;
    
    if (enableAdaptiveSharpen){
        if (!_adapterSharpenTask){ // If not inited, we should init one
            _adapterSharpenTask = [[BEAdaptiveSharpenTask alloc]init];
            _adapterSharpenTask.provider = self.provider;
            
            if ([_adapterSharpenTask initTask]){ // No zero means initlization error
                _adapterSharpenTask = nil;
            }
        }
    }else {
        if (_adapterSharpenTask){ // Means we should destory it
            [_adapterSharpenTask destroyTask];
            _adapterSharpenTask = nil;
        }
    }
    _enableAdaptiveSharpen = enableAdaptiveSharpen;
}

@end
