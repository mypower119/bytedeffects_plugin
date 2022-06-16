// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import "BEMainTabCell.h"
#import "BEScrollableLabel.h"
#import <Masonry/Masonry.h>

@interface BEMainTabCell()

@property (nonatomic, strong) BEScrollableLabel *titleLabel;

@end

@implementation BEMainTabCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(16);
        }];
        
        _textScrollable = NO;
    }
    return self;
}

- (void)setTextScrollable:(BOOL)textScrollable {
    _textScrollable = textScrollable;
    
    self.titleLabel.scrollable = textScrollable;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    self.titleLabel.textColor = selected ? self.hightlightTextColor : self.normalTextColor;
}

-(void)renderWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setTitleLabelFont:(UIFont *)font{
    self.titleLabel.font = font;
}

- (void)setNormalTextColor:(UIColor *)normalTextColor {
    _normalTextColor = normalTextColor;
    
    if (!self.selected) {
        self.titleLabel.textColor = normalTextColor;
    }
}

- (void)setHightlightTextColor:(UIColor *)hightlightTextColor {
    _hightlightTextColor = hightlightTextColor;
    
    if (self.selected) {
        self.titleLabel.textColor = hightlightTextColor;
    }
}

#pragma mark - getter

- (BEScrollableLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[BEScrollableLabel alloc] init];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.label.numberOfLines = 0;
//        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.scrollable = self.textScrollable;
    }
    return _titleLabel;
}

@end
