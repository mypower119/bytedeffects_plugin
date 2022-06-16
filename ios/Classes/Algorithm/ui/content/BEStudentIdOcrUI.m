//
//  BEStudentIdOcrUI.m
//  
//
//  Created by Bytedance on 2020/9/3.
//

#import "BEStudentIdOcrUI.h"
#import "BEStudentIdOcrVC.h"
#import "BEStudentIdOcrViewController.h"
#import "BEStudentIdOcrTask.h"

@interface BEStudentIdOcrUI () <BEStudentIdOcrFinishedDelegate, BEAlgorithmUIGenerator, BEStudentIdOcrVCDelegate>


@property (nonatomic, strong) BEStudentIdOcrViewController *studentIdOcrVc;
@property (nonatomic, strong) BEStudentIdOcrVC *vc;

@end

@implementation BEStudentIdOcrUI

- (id<BEAlgorithmUIGenerator>)algorithmGenerator {
    return self;
}

#pragma mark - BEAlgorithmUIGenerator

- (NSString *)title {
    return @"tab_student_id_ocr";
}

- (BEAlgorithmKey *)key {
    return BEStudentIdOcrTask.STUDENT_ID_OCR;
}

- (UIViewController *)create {
    if (self.vc != nil) {
        return self.vc;
    }
    BEStudentIdOcrVC *vc = [BEStudentIdOcrVC new];
    vc.delegate = self;
    self.vc = vc;
    return vc;
}

#pragma mark - BEStudentIdOcrVCDelegate
- (void)onItemClick {
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.studentIdOcrVc show:YES];
}

#pragma mark - BEStudentIdOcrFinishedDelegate

- (void)studentIdOcrFinish{
    [self.provider showOrHideVC:self.studentIdOcrVc show:false];
}

#pragma  mark - getter
- (BEStudentIdOcrViewController *) studentIdOcrVc{
    if (!_studentIdOcrVc){
        _studentIdOcrVc = [[BEStudentIdOcrViewController alloc] init];
        _studentIdOcrVc.delegate = self;
    }
    return _studentIdOcrVc;
}
@end
