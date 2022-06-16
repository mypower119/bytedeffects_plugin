//
//  BEDynamicGestureAlgorithmResult.m
//  BECore
//
//  Created by bytedance on 2021/11/11.
//

#import "BEChromaKeyingAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"

@implementation BEChromaKeyingAlgorithmResult

@end
@interface BEChromaKeyingAlgorithmTask () {
    bef_effect_handle_t      _handle;
    bef_ai_chroma_keying_ret _chromKeyingInfo;
}

@property (nonatomic, strong) id<BEChromaKeyingResourceProvider> provider;

@end

@implementation BEChromaKeyingAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)CHROMA_KEYING {
    GET_TASK_KEY(chromaKeying, YES)
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (int)initTask {
#if BEF_CHROMA_KEYING_TOB
    bef_effect_result_t ret = bef_effect_ai_chroma_keying_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_chroma_keying_create, ret)
    
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_chroma_keying_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_chroma_keying_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_chroma_keying_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_chroma_keying_check_online_license, ret);
    }
    
    ret = bef_effect_ai_chroma_keying_init(_handle, self.provider.chromaKeyingModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_chroma_keying_init, ret)
    return ret;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEChromaKeyingAlgorithmResult *)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_CHROMA_KEYING_TOB
    BEChromaKeyingAlgorithmResult *result = [BEChromaKeyingAlgorithmResult new];


    unsigned char *data = NULL;
    bool imageWithPadding = (stride != width * 4);
    if (imageWithPadding) {
        data = malloc(width * height * 4 * sizeof(unsigned char));
        for (int i = 0; i < height; ++i) {
            memcpy(data + i * width * 4, buffer + i * stride, width * 4);
        }
        stride = width * 4;
    }
    
    RECORD_TIME(chromaKeying)
    bef_effect_result_t ret = bef_effect_ai_chroma_keying_detect(_handle, imageWithPadding ? data : buffer, format, width, height, stride, rotation, &_chromKeyingInfo);
    STOP_TIME(chromaKeying)
    if (imageWithPadding) free(data);
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_chroma_keying_detect, ret, result)
    result.chromaKeyingInfo = &_chromKeyingInfo;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_CHROMA_KEYING_TOB
    return bef_effect_ai_chroma_keying_release(_handle);
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEChromaKeyingAlgorithmTask.CHROMA_KEYING;
}

@end
