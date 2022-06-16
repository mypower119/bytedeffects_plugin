//
//  BEMainCVHeader.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEMainCVHeader.h"
#import "Masonry.h"
#import "Common.h"

@interface BEMainCVHeader ()

@property (nonatomic, strong) UILabel *l;

@end

@implementation BEMainCVHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.l];
        
        [self.l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(16);
            make.topMargin.mas_equalTo(20);
            make.bottomMargin.mas_equalTo(-12);
        }];
    }
    return self;
}

- (void)updateWithTitle:(NSString *)title {
    self.l.text = NSLocalizedString(title, nil);
}

#pragma mark - getter
- (UILabel *)l {
    if (_l == nil) {
        _l = [UILabel new];
        _l.textColor = BEColorWithRGBHex(0x1D2129);
        _l.font = [UIFont systemFontOfSize:14];
    }
    return _l;
}

@end
