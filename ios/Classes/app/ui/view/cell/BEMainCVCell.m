//
//  BEMainCVCell.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEMainCVCell.h"
#import "BEScrollableLabel.h"
#import <Masonry/Masonry.h>
#import "Common.h"

@implementation BEMainCVTitleCell



@end

@interface BEMainCVItemCell ()

@property (nonatomic, strong) UIImageView *ivIcon;
@property (nonatomic, strong) UILabel *lTitle;

@end

@implementation BEMainCVItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        
        [self addSubview:self.ivIcon];
        [self addSubview:self.lTitle];
        
        [self.ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(20);
        }];
        [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self.ivIcon.mas_trailing).offset(15);
            make.trailing.equalTo(self).offset(-10);
//            make.height.mas_equalTo(16);
        }];
    }
    return self;
}

- (void)updateTitle:(NSString *)title icon:(NSString *)icon {
    self.lTitle.text = NSLocalizedString(title, nil);
    self.ivIcon.image = [UIImage imageNamed:icon];
}

#pragma mark - getter
- (UIImageView *)ivIcon {
    if (_ivIcon == nil) {
        _ivIcon = [[UIImageView alloc] init];
    }
    return _ivIcon;
}

- (UILabel *)lTitle {
    if (_lTitle == nil) {
        _lTitle = [[UILabel alloc] init];
        _lTitle.textColor = BEColorWithRGBHex(0x1D2129);
        _lTitle.numberOfLines = 0;
        _lTitle.font = [UIFont systemFontOfSize:14];
        _lTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _lTitle;
}

@end
