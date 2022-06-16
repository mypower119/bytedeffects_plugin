//
//  BELightClsViewController.m
//  BytedEffects
//
//  Created by QunZhang on 2019/12/5.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"

#import "BELightClsInfoVC.h"
#import "BEPropertyTextView.h"
#import "CommonSize.h"

static CGFloat MIN_WIDTH = 120;

@interface BELightClsInfoVC ()

@property (nonatomic, strong) BEPropertyTextView *tvType;
@property (nonatomic, strong) BEPropertyTextView *tvCredibility;

@end

@implementation BELightClsInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.userInteractionEnabled = NO;
    self.tvType.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    self.tvCredibility.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    
    [self.view addSubview:self.tvType];
    [self.view addSubview:self.tvCredibility];
    
    [self.tvType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ALGORITHM_INFO_TOP_MARGIN);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(20);
        make.width.equalTo(self.tvCredibility);
    }];
    [self.tvCredibility mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tvType.mas_bottom);
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(MIN_WIDTH);
    }];
}

- (void)updateLightInfo:(bef_ai_light_cls_result)lightInfo {
    NSArray<NSString *> *lightType = [self lightType];
    NSString *typeTitle;
    if (lightInfo.selected_index >= 0 && lightInfo.selected_index < lightType.count) {
        typeTitle = NSLocalizedString(lightType[lightInfo.selected_index], nil);
    } else {
        typeTitle = @"";
    }
    
    NSString *credibilityTitle = [NSString stringWithFormat:@"%.3f", lightInfo.prob];
    [self.tvType setValue:typeTitle];
    [self.tvCredibility setValue:credibilityTitle];
}


#pragma mark - getter

- (BEPropertyTextView *)tvType {
    if (!_tvType) {
        _tvType = [BEPropertyTextView new];
        [_tvType setTitle:NSLocalizedString(@"light_cls_type", nil)];
    }
    return _tvType;
}

- (BEPropertyTextView *)tvCredibility {
    if (!_tvCredibility) {
        _tvCredibility = [BEPropertyTextView new];
        [_tvCredibility setTitle:NSLocalizedString(@"light_cls_credibility", nil)];
    }
    return _tvCredibility;
}

- (NSArray<NSString *> *)lightType {
    static dispatch_once_t onceToken;
    static NSArray *array;
    dispatch_once(&onceToken, ^{
        array = @[
            @"indoor_yellow",
            @"indoor_white",
            @"indoor_weak",
            @"sunny",
            @"cloudy",
            @"night",
            @"back_light"
        ];
    });
    return array;
}

@end
