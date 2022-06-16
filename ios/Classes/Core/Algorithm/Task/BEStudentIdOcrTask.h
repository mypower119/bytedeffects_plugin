//
//  BEStudentIDOcrTask.h
//  BytedEffects
//
//  Created by Bytedance on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEStudentIDOcrTask_h
#define BEStudentIDOcrTask_h

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_student_id_ocr.h"

@protocol BEStudentIdOcrResourceProvider <BEAlgorithmResourceProvider>

-(const char*)studentIdOocModel;

@end

@interface BEStudentIdOcrAlgorithmResult : NSObject

@property (nonatomic, assign) bef_student_id_ocr_result *idInfo;

@end

@interface BEStudentIdOcrTask : BEAlgorithmTask

+ (BEAlgorithmKey *)STUDENT_ID_OCR;

@end

#endif /* BEStudentIDOcrTask_h */
