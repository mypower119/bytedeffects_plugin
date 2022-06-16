//
//  BEScrollablePropertyTextView.m
//  BECommon
//
//  Created by qun on 2021/7/15.
//

#import "BEScrollablePropertyTextView.h"
#import "BEScrollableLabel.h"
#import "Masonry.h"

@interface BEScrollablePropertyTextView ()

@property (nonatomic, strong) BEScrollableLabel *lTitle;
@property (nonatomic, strong) BEScrollableLabel *lValue;

@end

@implementation BEScrollablePropertyTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lTitle];
        [self addSubview:self.lValue];
        
        [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self).with.mas_offset(5);
            make.bottom.equalTo(self);
            make.trailing.equalTo(self.lValue.mas_leading).mas_offset(-5);
            make.width.equalTo(self.lValue);
        }];
        [self.lValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.trailing.equalTo(self).with.mas_offset(-5);
            make.bottom.equalTo(self);
            make.leading.equalTo(self.lTitle.mas_trailing).mas_offset(5);
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
- (BEScrollableLabel *)lTitle {
    if (!_lTitle) {
        _lTitle = [BEScrollableLabel new];
        _lTitle.textColor = [UIColor whiteColor];
        _lTitle.font = [UIFont systemFontOfSize:13];
        _lTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _lTitle;
}

- (BEScrollableLabel *)lValue {
    if (!_lValue) {
        _lValue = [BEScrollableLabel new];
        _lValue.textColor = [UIColor whiteColor];
        _lValue.font = [UIFont systemFontOfSize:13];
        _lValue.textAlignment = NSTextAlignmentRight;
    }
    return _lValue;
}

@end
