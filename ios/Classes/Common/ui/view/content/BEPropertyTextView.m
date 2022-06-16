//
//  BEPropertyTextView.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/17.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"

#import "BEPropertyTextView.h"

@interface BEPropertyTextView ()

@property (nonatomic, strong) UILabel *lTitle;
@property (nonatomic, strong) UILabel *lValue;
@property (nonatomic, strong) UIView *vInterval;

@end

@implementation BEPropertyTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.vInterval];
        [self addSubview:self.lTitle];
        [self addSubview:self.lValue];
        
        [self.vInterval mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(10);
        }];
        [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).with.mas_offset(5);
            make.bottom.equalTo(self);
            make.trailing.equalTo(self.vInterval.mas_leading);
        }];
        [self.lValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self).with.mas_offset(-5);
            make.bottom.equalTo(self);
            make.leading.equalTo(self.vInterval.mas_trailing);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.lTitle).offset(-5);
            make.trailing.equalTo(self.lValue).offset(5);
        }];
    }
    return self;
}

#pragma mark - public
- (void)setTitle:(NSString *)title {
    self.lTitle.text = title;
}

- (void)setValue:(NSString *)value {
    self.lValue.text = value;
}

#pragma mark - getter
- (UILabel *)lTitle {
    if (!_lTitle) {
        _lTitle = [UILabel new];
        _lTitle.textColor = [UIColor whiteColor];
        _lTitle.font = [UIFont systemFontOfSize:13];
        _lTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _lTitle;
}

- (UILabel *)lValue {
    if (!_lValue) {
        _lValue = [UILabel new];
        _lValue.textColor = [UIColor whiteColor];
        _lValue.font = [UIFont systemFontOfSize:13];
        _lValue.textAlignment = NSTextAlignmentRight;
    }
    return _lValue;
}

- (UIView *)vInterval {
    if (_vInterval != nil) {
        return _vInterval;
    }
    
    _vInterval = [UIView new];
    return _vInterval;
}

@end
