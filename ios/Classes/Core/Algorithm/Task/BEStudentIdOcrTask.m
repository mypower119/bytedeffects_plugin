//  BEStudentIdOcrTask.m
//  BytedEffects
//
//  Created by Bytedance on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEStudentIdOcrTask.h"
#import "bef_effect_ai_student_id_ocr.h"
#import "BEAlgorithmTaskFactory.h"

@implementation BEStudentIdOcrAlgorithmResult

@end
@interface BEStudentIdOcrTask () {
    bef_ai_student_id_handle _ocrHandle;
    bef_student_id_ocr_result _ocrResult;
}

@property (nonatomic, strong) id<BEStudentIdOcrResourceProvider> provider;

@end

@implementation BEStudentIdOcrTask

@dynamic provider;

+ (BEAlgorithmKey *)STUDENT_ID_OCR {
    GET_TASK_KEY(studentIdOcr, YES)
}

#pragma mark - override

-(int )initTask{
#if 0
    bef_effect_result_t ret = bef_effect_ai_student_id_ocr_create_handle(&_ocrHandle);
    CHECK_RET_AND_RETURN(bef_effect_ai_student_id_ocr_create_handle, ret)
    
    ret = bef_effect_ai_student_id_ocr_check_license(_ocrHandle, [self.licenseProvider licensePath]);
    CHECK_RET_AND_RETURN(bef_effect_ai_student_id_ocr_check_license, ret);
    
    ret = bef_effect_ai_student_id_ocr_init_model(_ocrHandle, BEF_STUDENT_ID_OCR_MODEL, self.provider.studentIdOocModel);
    CHECK_RET_AND_RETURN(bef_effect_ai_student_id_ocr_init_model, ret)
    return ret;
    
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (id)process:(const unsigned char *)buffer width:(int)width height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
#if 0
    BEStudentIdOcrAlgorithmResult *result = [BEStudentIdOcrAlgorithmResult new];
    
    RECORD_TIME(detectStudentIdOcr)
    bef_effect_result_t ret = bef_effect_ai_student_id_ocr_detect(_ocrHandle, buffer, format, width, height, stride, rotation, &_ocrResult);
    CHECK_RET_AND_RETURN_RESULT(bef_effect_ai_student_id_ocr_detect, ret, result)
    STOP_TIME(detectStudentIdOcr)
    
    result.idInfo = &_ocrResult;
    return result;
#endif
    return nil;
}

- (int) destroyTask{
#if 0
    bef_effect_ai_student_id_ocr_destroy(_ocrHandle);
    return 0;
#endif
    return BEF_RESULT_INVALID_INTERFACE;
}

- (BEAlgorithmKey *)key {
    return BEStudentIdOcrTask.STUDENT_ID_OCR;
}

//- (const char *)studentIdOocModel {
//    return [self.provider modelPath:@"/student_id_ocr/tt_student_id_ocr_v2.0.model"];
//}

@end
