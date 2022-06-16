//
//  BEMainCVVersionFooter.m
//  app
//
//  Created by qun on 2021/6/15.
//

#import "BEMainCVVersionFooter.h"
#import "Masonry.h"
#import "Common.h"

@interface BEMainCVVersionFooter ()

@property (nonatomic, strong) UILabel *l;

@end

@implementation BEMainCVVersionFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.l];
        
        [self.l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.topMargin.mas_equalTo(40);
            make.bottomMargin.mas_equalTo(-28);
        }];
    }
    return self;
}

- (void)updateWithVersion:(NSString *)version {
    self.l.text = version;
}

#pragma mark - getter
- (UILabel *)l {
    if (_l == nil) {
        _l = [UILabel new];
        _l.textColor = BEColorWithRGBHex(0x86909C);
        _l.font = [UIFont systemFontOfSize:14];
    }
    return _l;
}

@end
