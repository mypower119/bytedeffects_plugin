//
//  BECarQuilityView.m
//  BytedEffects
//
//  Created by qun on 2020/9/6.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BECarQuilityView.h"
#import "BEPropertyTextView.h"

#import "Masonry.h"

@interface BECarQuilityView ()

@property (nonatomic, strong) BEPropertyTextView *tvGray;
@property (nonatomic, strong) BEPropertyTextView *tvBlur;

@end

@implementation BECarQuilityView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self addSubview:self.tvGray];
        [self addSubview:self.tvBlur];
        
        [self.tvBlur mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.tvGray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@[self.tvBlur, self.tvGray]);
            make.width.mas_greaterThanOrEqualTo(120);
        }];
    }
    return self;
}

- (void)updateQuility:(BOOL)gray blur:(BOOL)blur {
    [self.tvGray setValue:gray ? NSLocalizedString(@"car_gray_ok", nil) : NSLocalizedString(@"car_gray_not", nil)];
    [self.tvBlur setValue:blur ? NSLocalizedString(@"car_blur_ok", nil) : NSLocalizedString(@"car_blur_not", nil)];
}

#pragma mark - getter
- (BEPropertyTextView *)tvGray {
    if (_tvGray == nil) {
        _tvGray = [BEPropertyTextView new];
        [_tvGray setTitle:NSLocalizedString(@"car_gray", nil)];
    }
    return _tvGray;
}

- (BEPropertyTextView *)tvBlur {
    if (_tvBlur == nil) {
        _tvBlur = [BEPropertyTextView new];
        [_tvBlur setTitle:NSLocalizedString(@"car_blur", nil)];
    }
    return _tvBlur;
}

@end
