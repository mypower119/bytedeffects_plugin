//
//  BELensVideoSR.m
//  BytedEffects
//
//  Created by Bytedance on 2020/12/1.
//  Copyright © 2020 ailab. All rights reserved.
//

@import MetalKit;

#import <Foundation/Foundation.h>
#import "BEAdaptiveSharpenTask.h"
#import "bef_ai_image_quality_enhancement_adaptive_sharpen.h"
#import "bef_ai_image_quality_enhancement_public_define.h"
#import "BEImageOpeartion.h"


@interface BEAdaptiveSharpenTask()
    
@property(nonatomic, assign)bef_image_quality_enhancement_handle handle;

@end


@implementation BEAdaptiveSharpenTask
{
    id <MTLDevice> device;
    bef_ai_asf_init_config config;
}

#pragma mark -- inittask
-(int) initTask{
#if BEF_LENS_ADAPTIVE_SHARPEN_TOB
    
    int ret = 0;
    if(@available(iOS 11.0, *)) {
        device = MTLCreateSystemDefaultDevice();
        
        config.scene_mode = BEF_AI_LENS_ASF_SCENE_MODE_LIVE_PEOPLE;
        config.context = (__bridge void*)device;
        config.input_type = BEF_AI_LENS_PXIELBUFFER_NV12;
        config.output_type = BEF_AI_LENS_PXIELBUFFER_NV12;
        config.frame_width = 0;
        config.frame_height = 0;
        config.amount = 1.5;
        config.diff_img_smooth_enable = -1;
        config.edge_weight_gamma = -1;
        config.over_ratio = 1.5;
        
        ret = bef_ai_image_quality_enhancement_adaptive_sharpen_create(&_handle,&config);
        CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_adaptive_sharpen_create, ret)
    }
    else
    {
        CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_adaptive_sharpen, -1)
    }
    
    if (self.provider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_ai_image_quality_enhancement_adaptive_sharpen_check_license(_handle, self.provider.licensePath);
        CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_adaptive_sharpen_check_license, ret)
    }
    else if (self.provider.licenseMode == ONLINE_LICENSE){
        if (![self.provider checkLicenseResult: @"getLicensePath"])
            return self.provider.errorCode;
        
        char* licensePath = self.provider.licensePath;
        ret = bef_ai_image_quality_enhancement_adaptive_sharpen_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_adaptive_sharpen_check_online_license, ret)
    }
    
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}


-(CVPixelBufferRef)processInternal:(CVPixelBufferRef)srcBuffer
{
    #if BEF_LENS_ADAPTIVE_SHARPEN_TOB
    if (srcBuffer == nil)
    {
        return nil;
    }
    CVPixelBufferRef processedBuffer = nil;
    
    CVPixelBufferRef yuv420fbuffer = srcBuffer;
    OSType imageFormat = CVPixelBufferGetPixelFormatType(yuv420fbuffer);
    
    //do the format change if posible, actually we can do more conversion
    //If the input format is 32BGRA, the pipeline is like below:
    // BGRA -> YUV420F -> adaptive_sharpen -> BGRA
    if (imageFormat == kCVPixelFormatType_32BGRA)
    {
        // BGRA -> YUV420F
        BEImageBufferOperation* imageOp = [BEImageBufferOperation sharedInstance];
        yuv420fbuffer =
            [imageOp transforPixelbuffer:srcBuffer destFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    }
    
    imageFormat = CVPixelBufferGetPixelFormatType(yuv420fbuffer);
    if(imageFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || imageFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
    {
        bef_ai_asf_input sr_input;
        bef_ai_asf_output sr_output;
        int ret;
        
        sr_input.data.buffer = yuv420fbuffer;
        sr_input.type = BEF_AI_LENS_PXIELBUFFER_NV12;
        
        int width = (int)CVPixelBufferGetWidthOfPlane(yuv420fbuffer, 0);
        int height = (int)CVPixelBufferGetHeightOfPlane(yuv420fbuffer, 0);
        if(width != config.frame_width || height != config.frame_height)
        {
            
            
            bef_ai_asf_property propertyConfig;
            
            propertyConfig.scene_mode = config.scene_mode;
            propertyConfig.frame_width = width;
            propertyConfig.frame_height = height;
            propertyConfig.amount = config.amount;
            propertyConfig.over_ratio = config.over_ratio;
            propertyConfig.edge_weight_gamma = config.edge_weight_gamma;
            propertyConfig.diff_img_smooth_enable = config.diff_img_smooth_enable;
            
            ret = bef_ai_image_quality_enhancement_adaptive_sharpen_set_property(_handle,&propertyConfig);
            CHECK_RET_AND_RETURN_RESULT(bef_ai_image_quality_enhancement_adaptive_sharpen_set_property, ret, nil)
            
            config.frame_width = width;
            config.frame_height = height;
        }
        
        ret = bef_ai_image_quality_enhancement_adaptive_sharpen_process(_handle, &sr_input, &sr_output);
        //    {zh} 错误码为 -69 时可以忽略，但是错误信息还是要打印一下        {en} Error code is -69 can be ignored, but the error message still needs to be printed  
        if (ret == BEF_RESULT_IMAGE_QUALITY_ASP_UNDER_INIT) {
            const char *msg = bef_effect_ai_error_code_get(ret);
            if (msg != NULL) {
                NSLog(@"%s error: %d, %s", "bef_ai_image_quality_enhancement_adaptive_sharpen_process", ret, msg);
            } else {
                NSLog(@"%s error: %d", "bef_ai_image_quality_enhancement_adaptive_sharpen_process", ret);
            }
            return nil;
        }
        CHECK_RET_AND_RETURN_RESULT(bef_ai_image_quality_enhancement_adaptive_sharpen_process, ret, nil)
        
        processedBuffer = sr_output.data.buffer;
    }
    else
    {
        NSLog(@"not support!");
        return nil;
    }
    
    //after the video sr process, it will alwayse be yuv 420 buffer
    //we need to de the left procss by transfer it bgra8888
    return processedBuffer;
#endif
    return nil;
    
}

-(CVPixelBufferRef)processCVPixelBuffer:(CVPixelBufferRef)srcBuffer
{
    CVPixelBufferRef ret = NULL;
    
    
    ret = [self processInternal:srcBuffer];
    
    return ret;
}

-(int)destroyTask{
#if BEF_LENS_ADAPTIVE_SHARPEN_TOB
    int ret = 0;
    
    ret = bef_ai_image_quality_enhancement_adaptive_sharpen_destory(_handle);
    if (ret != 0){
        NSLog(@"bef_ai_image_quality_enhancement_adaptive_sharpen_destory is %d ", ret);
    }
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

@end
