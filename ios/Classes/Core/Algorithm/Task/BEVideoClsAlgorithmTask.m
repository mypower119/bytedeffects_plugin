//
//  BEVideoClsAlgorithmTask.m
//  BytedEffects
//
//  Created by qun on 2020/8/17.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEVideoClsAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static const int FRAME_INTERVAL = 5;

@implementation BEVideoClsAlgorithmResult

@end
@interface BEVideoClsAlgorithmTask () {
    bef_ai_video_cls_handle             _handle;
    bef_ai_video_cls_ret            _videoClsInfo;
    
    int                             _frameCount;
}

@property (nonatomic, strong) id<BEVideoClsResourceProvider> provider;

@end

@implementation BEVideoClsAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)VIDEO_CLS {
    GET_TASK_KEY(videoCls, YES)
}

- (int)initTask {
#if BEF_VIDEO_CLS_TOB
    bef_effect_result_t ret = bef_effect_ai_video_cls_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_video_cls_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_video_cls_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_video_cls_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_video_cls_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_video_cls_check_online_license, ret)
    }
    
    ret = bef_effect_ai_video_cls_set_model(_handle, BEF_AI_kVideoClsModel1, self.provider.videoClsModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_video_cls_set_model, ret)
    _frameCount = 0;
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_VIDEO_CLS_TOB
    BEVideoClsAlgorithmResult *result = [BEVideoClsAlgorithmResult new];
    
    bef_ai_video_cls_args args;
    bef_ai_base_args base;
    base.image = buffer;
    base.image_width = width;
    base.image_height = height;
    base.pixel_fmt = format;
    base.orient = rotation;
    base.image_stride = stride;
    args.bases = &base;
    args.is_last = (++_frameCount % FRAME_INTERVAL) == 0;
    
    RECORD_TIME(videoCls)
    bef_effect_result_t ret = bef_effect_ai_video_cls_detect(_handle, &args, &_videoClsInfo);
    STOP_TIME(videoCls)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_video_cls_detect, ret, result)
    
    result.videoInfo = &_videoClsInfo;
    return result;
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_VIDEO_CLS_TOB
    bef_effect_ai_video_cls_release(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEVideoClsAlgorithmTask.VIDEO_CLS;
}

@end
