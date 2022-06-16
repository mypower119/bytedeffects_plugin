//
//  BEStudentIdOrcVC.m
//  BytedEffects
//
//  Created by qun on 2020/9/10.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEStudentIdOcrVC.h"
#import "BESelectableButton.h"
#import "BELightUpSelectableView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEStudentIdOcrVC () <BESelectableButtonDelegate>

@property (nonatomic, strong) BESelectableButton *bt;

@end

@implementation BEStudentIdOcrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bt];
    [self.bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(90);
    }];
}

#pragma mark - BESelectableButtonDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    [self.delegate onItemClick];
}

#pragma mark - getter
- (BESelectableButton *)bt {
    if (!_bt) {
        _bt = [[BESelectableButton alloc]
               initWithSelectableConfig:
                 [BELightUpSelectableConfig
                  initWithUnselectImage:@"iconStudentIdNormal"
                  imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
        _bt.title = NSLocalizedString(@"tab_student_id_ocr", nil);
        _bt.delegate = self;
    }
    return _bt;
}

@end
