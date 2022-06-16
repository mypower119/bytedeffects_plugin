//
//  BELensVideoSR.m
//  BytedEffects
//
//  Created by Bytedance on 2020/12/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEVideoSRTask.h"
#import "bef_ai_image_quality_enhancement_video_sr.h"
#import "bef_ai_image_quality_enhancement_public_define.h"
#import "BEImageOpeartion.h"

@interface BEVideoSRTask()
    
@property(nonatomic, assign)bef_image_quality_enhancement_handle handle;

@end


@implementation BEVideoSRTask

#pragma mark -- inittask
-(int) initTask{
#if BEF_LENS_VIDEO_SR_TOB
    bef_ai_video_sr_init_config config;
    memset(&config, 0, sizeof(config));
    config.enable_mem_pool = true;
    config.input_type = BEF_AI_LENS_PXIELBUFFER_NV12;
    config.output_type = BEF_AI_LENS_PXIELBUFFER_NV12;

    int ret = bef_ai_image_quality_enhancement_video_sr_create(&_handle, &config);
    CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_video_sr_create, ret)
    
    if (self.provider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_ai_image_quality_enhancement_video_sr_check_license(_handle, self.provider.licensePath);
        CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_video_sr_check_license, ret)
    }
    else if (self.provider.licenseMode == ONLINE_LICENSE){
        if (![self.provider checkLicenseResult: @"getLicensePath"])
            return self.provider.errorCode;
        
        char* licensePath = self.provider.licensePath;
        ret = bef_ai_image_quality_enhancement_video_sr_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_video_sr_check_online_license, ret)
    }
    
    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}


-(CVPixelBufferRef)processInternal:(CVPixelBufferRef)srcBuffer
{
#if BEF_LENS_VIDEO_SR_TOB

    bef_ai_video_sr_input sr_input;
    bef_ai_video_sr_output sr_output;
    int ret;
    CVPixelBufferRef processedBuffer = NULL;
    BEImageBufferOperation* imageOp = [BEImageBufferOperation sharedInstance];
    
    
    if (srcBuffer != NULL){
        OSType imageFormat = CVPixelBufferGetPixelFormatType(srcBuffer);
        
        // If the format is yuv 420f, 420p
        if (imageFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange || imageFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange){
            sr_input.data.buffer = srcBuffer;
            sr_input.width = (int)CVPixelBufferGetHeightOfPlane(srcBuffer, 0);
            sr_input.height = (int)CVPixelBufferGetWidthOfPlane(srcBuffer, 0);
            
            ret = bef_ai_image_quality_enhancement_video_sr_set_width_and_height(_handle, sr_input.width, sr_input.height);
            CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_video_sr_set_width_and_height, ret)
            
            sr_input.type = BEF_AI_LENS_PXIELBUFFER_NV12;
            ret = bef_ai_image_quality_enhancement_video_sr_process(_handle, &sr_input, &sr_output);
            CHECK_RET_AND_RETURN(bef_ai_image_quality_enhancement_video_sr_process, ret)
            
            processedBuffer = sr_output.data.buffer;
        }
        //do the format change if posible, actually we can do more conversion
        //If the input format is 32BGRA, the pipeline is like below:
        // BGRA -> YUV420F -> VIDEO_SR -> BGRA
        else if (imageFormat == kCVPixelFormatType_32BGRA) //
        {
            // BGRA -> YUV420F
            CVPixelBufferRef yuv420fbuffer =
                [imageOp transforPixelbuffer:srcBuffer destFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
            
            sr_input.data.buffer = yuv420fbuffer;
            sr_input.width = (int)CVPixelBufferGetHeightOfPlane(srcBuffer, 0);
            sr_input.height = (int)CVPixelBufferGetWidthOfPlane(srcBuffer, 0);
            
            ret = bef_ai_image_quality_enhancement_video_sr_set_width_and_height(_handle, sr_input.width, sr_input.height);
            CHECK_RET_AND_RETURN_RESULT(bef_ai_image_quality_enhancement_video_sr_set_width_and_height, ret, NULL)
            
            RECORD_TIME(video_sr);
            ret = bef_ai_image_quality_enhancement_video_sr_process(_handle, &sr_input, &sr_output);
            STOP_TIME(video_sr);
            CHECK_RET_AND_RETURN_RESULT(bef_ai_image_quality_enhancement_video_sr_process, ret, NULL)
            
            // release the yuv420f buffer
            CVPixelBufferRelease(yuv420fbuffer);
            processedBuffer = sr_output.data.buffer;
        }
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
#if BEF_LENS_VIDEO_SR_TOB

    int ret = 0;
    
    ret = bef_ai_image_quality_enhancement_video_sr_destory(_handle);
    if (ret != 0){
        NSLog(@"bef_ai_image_quality_enhancement_vidoe_sr_destory is %d ", ret);
    }
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

@end
