//
//  BEC1InfoVc.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEC1InfoVC.h"
#import "BEPropertyTextView.h"
#import "Masonry.h"
#import "Common.h"

static CGFloat MIN_WIDTH = 120;

@interface BEC1InfoVC ()

@property (nonatomic, strong) BEPropertyTextView *tv;

@end

@implementation BEC1InfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    self.tv.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self.view addSubview:self.tv];
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ALGORITHM_INFO_TOP_MARGIN);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(MIN_WIDTH);
    }];
}

- (void)updateInfo:(NSString *)title value:(NSString *)value {
    [self.tv setTitle:title];
    [self.tv setValue:value];
}

#pragma mark - getter
- (BEPropertyTextView *)tv {
    if (!_tv) {
        _tv = [BEPropertyTextView new];
    }
    return _tv;
}

@end
