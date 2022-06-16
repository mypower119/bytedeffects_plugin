//
//  BECarInfoView.m
//  BytedEffects
//
//  Created by qun on 2020/9/6.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BECarInfoView.h"
#import "BEPropertyTextView.h"

#import "Masonry.h"

@interface BECarInfoView ()

@property (nonatomic, strong) UILabel *tv;

@end

@implementation BECarInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self addSubview:self.tv];
        
        [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)updateInfo:(NSString *)info {
    self.tv.text = info;
}

- (UILabel *)tv {
    if (_tv == nil) {
        _tv = [UILabel new];
        _tv.textColor = [UIColor whiteColor];
        _tv.font = [UIFont systemFontOfSize:13];
        _tv.textAlignment = NSTextAlignmentCenter;
    }
    return _tv;
}

@end
