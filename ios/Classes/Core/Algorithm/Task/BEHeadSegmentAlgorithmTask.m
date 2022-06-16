//
//  BEHeadSegmentAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEHeadSegmentAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

static int INPUT_WIDTH = 128;
static int INPUT_HEIGHT = 128;
static float ENABLE_TRACKING = 1;
static float MAX_FACE = 2;

@implementation BEHeadSegmentAlgorithmResult

@end
@interface BEHeadSegmentAlgorithmTask () {
    bef_ai_headseg_handle               _handle;
    bef_ai_headseg_output               _headSegInfo;
    BEFaceAlgorithmTask                 *_faceTask;
}

@property (nonatomic, strong) id<BEHeadSegmentResourceProvider> provider;

@end

@implementation BEHeadSegmentAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)HEAD_SEGMENT {
    GET_TASK_KEY(headSeg, YES)
}

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>)licenseProvider{
    if (self = [super initWithProvider:provider licenseProvider:licenseProvider]) {
        _faceTask = [[BEFaceAlgorithmTask alloc] initWithProvider:provider licenseProvider:licenseProvider];
    }
    return self;
}

- (int)initTask {
#if BEF_HEAD_SEG_TOB
    bef_ai_headseg_config conf;
    conf.net_input_height = INPUT_HEIGHT;
    conf.net_input_width = INPUT_WIDTH;
    
    bef_effect_result_t ret = BEF_AI_HSeg_CreateHandler(&_handle);
    CHECK_RET_AND_RETURN(BEF_AI_HSeg_CreateHandler, ret)

    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = BEF_AI_HSeg_CheckLicense(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(BEF_AI_HSeg_CheckLicense, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        ret = BEF_AI_HSeg_CheckOnlineLicense(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(BEF_AI_HSeg_CheckOnlineLicense, ret)
    }
    
    ret = BEF_AI_HSeg_SetConfig(_handle, &conf);
    CHECK_RET_AND_RETURN(BEF_AI_HSeg_SetConfig, ret)
    ret = BEF_AI_HSeg_SetParam(_handle, BEF_AI_HS_ENABLE_TRACKING, ENABLE_TRACKING);
    CHECK_RET_AND_RETURN(BEF_AI_HSeg_SetParam, ret)
    ret = BEF_AI_HSeg_SetParam(_handle, BEF_AI_HS_MAX_FACE, MAX_FACE);
    CHECK_RET_AND_RETURN(BEF_AI_HSeg_SetParam, ret)
    ret = BEF_AI_HSeg_InitModel(_handle, self.provider.headSegmentModelPath);
    CHECK_RET_AND_RETURN(BEF_AI_HSeg_InitModel, ret)
    ret = [_faceTask initTask];
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_HEAD_SEG_TOB

    BEHeadSegmentAlgorithmResult *result = [BEHeadSegmentAlgorithmResult new];
    
    BEFaceAlgorithmResult *faceRet = [_faceTask process:buffer width:width height:height stride:stride format:format rotation:rotation];
    bef_ai_face_info *faceInfo = faceRet.faceInfo;
    
    if (faceInfo == nil || faceInfo->face_count <= 0) return result;
    memset(&_headSegInfo, 0, sizeof(bef_ai_headseg_output));
    bef_ai_headseg_input args;
    args.image = buffer;
    args.image_width = width;
    args.image_height = height;
    args.image_stride = stride;
    args.orient = rotation;
    args.pixel_format = format;
    args.face_count = faceInfo->face_count;
    
    bef_ai_headseg_faceinfo headFaceInfo[args.face_count];
    for (int i = 0; i < args.face_count; i++) {
        headFaceInfo[i].face_id = faceInfo->base_infos[i].ID;
        memcpy(headFaceInfo[i].points, faceInfo->base_infos[i].points_array, sizeof(float) * 2 * 106);
    }
    args.face_info = headFaceInfo;
    
    RECORD_TIME(headSegment)
    bef_effect_result_t ret = BEF_AI_HSeg_DoHeadSeg(_handle, &args, &_headSegInfo);
    STOP_TIME(headSegment)
    CHECK_RET_AND_RETURN_RESULT(BEF_AI_HSeg_DoHeadSeg, ret, result);
    result.headSegInfo = &_headSegInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_HEAD_SEG_TOB
    [_faceTask destroyTask];
    BEF_AI_HSeg_ReleaseHandle(_handle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEHeadSegmentAlgorithmTask.HEAD_SEGMENT;
}

@end
