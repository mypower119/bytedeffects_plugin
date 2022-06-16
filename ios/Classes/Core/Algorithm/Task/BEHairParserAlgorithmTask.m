//
//  BEHairParserAlgorithmTask.m
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEHairParserAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "bef_effect_ai_hairparser.h"

static int WIDTH = 128;
static int HEIGHT = 224;

@implementation BEHairParserAlgorithmResult

@end
@interface BEHairParserAlgorithmTask () {
    bef_effect_handle_t             _handle;
    int                             _size[3];
    unsigned char                   *_hairParserInfo;
    int                             _hairParserInfoLen;
}

@property (nonatomic, strong) id<BEHairParserResourceProvider> provider;

@end

@implementation BEHairParserAlgorithmTask

@dynamic provider;

+ (BEAlgorithmKey *)HAIR_PARSER {
    GET_TASK_KEY(hairParser, YES)
}

- (int)initTask {
#if BEF_HAIR_PARSE_TOB
    bef_effect_result_t ret = bef_effect_ai_hairparser_create(&_handle);
    CHECK_RET_AND_RETURN(bef_effect_ai_hairparser_create, ret)
    if (self.licenseProvider.licenseMode == OFFLINE_LICENSE) {
        ret = bef_effect_ai_hairparser_check_license(_handle, self.licenseProvider.licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_hairparser_check_license, ret)
    }
    else if (self.licenseProvider.licenseMode == ONLINE_LICENSE){
        if (![self.licenseProvider checkLicenseResult: @"getLicensePath"])
            return self.licenseProvider.errorCode;
        
        char* licensePath = self.licenseProvider.licensePath;
        ret = bef_effect_ai_hairparser_check_online_license(_handle, licensePath);
        CHECK_RET_AND_RETURN(bef_effect_ai_hairparser_check_online_license, ret)
    }
    
    ret = bef_effect_ai_hairparser_init_model(_handle, self.provider.hairParserModelPath);
    CHECK_RET_AND_RETURN(bef_effect_ai_hairparser_init_model, ret)
    ret = bef_effect_ai_hairparser_set_param(_handle, WIDTH, HEIGHT, true, true);
    CHECK_RET_AND_RETURN(bef_effect_ai_hairparser_set_param, ret)
    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if BEF_HAIR_PARSE_TOB
    BEHairParserAlgorithmResult *result = [BEHairParserAlgorithmResult new];
    bef_effect_result_t ret = bef_effect_ai_hairparser_get_output_shape(_handle, _size, _size + 1, _size + 2);
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_hairparser_get_output_shape, ret, result)
    if (_hairParserInfoLen != _size[0] * _size[1] * _size[2]) {
        if (_hairParserInfo != nil) {
            free(_hairParserInfo);
        }
        _hairParserInfoLen = _size[0] * _size[1] * _size[2];
        _hairParserInfo = malloc(_hairParserInfoLen);
    }
    RECORD_TIME(parseHair)
    ret = bef_effect_ai_hairparser_do_detect(_handle, buffer, format, width, height, stride, rotation, _hairParserInfo, false);
    STOP_TIME(parseHair)
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_hairparser_do_detect, ret, result)
    result.mask = _hairParserInfo;
    result.size = _size;
    return result;
    
#endif
    return nil;
}

- (int)destroyTask {
#if BEF_HAIR_PARSE_TOB
    bef_effect_ai_hairparser_destroy(_handle);
    free(_hairParserInfo);
    return 0;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEHairParserAlgorithmTask.HAIR_PARSER;
}

@end
