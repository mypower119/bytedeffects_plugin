//
//  BEButtonViewCell.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/13.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"

#import "BEButtonViewCell.h"
#import "BEButtonView.h"

@interface BEButtonViewCell ()

@property (nonatomic, strong) BEButtonView *buttonView;

@end

@implementation BEButtonViewCell

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    };
    return self;
}

#pragma mark - public
- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg title:(NSString *)title expand:(BOOL)expand withPoint:(BOOL)withPoint {
    [self.buttonView setSelectImg:selectImg unselectImg:unselectImg title:title expand:expand withPoint:withPoint];
}

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg
{
    [self.buttonView setSelectImg:selectImg unselectImg:unselectImg];
}

- (void)setPointOn:(BOOL)isOn {
    [self.buttonView setPointOn:isOn];
}

- (void)setUsedStatus:(BOOL)uesd{
    [self.buttonView setPointOn:uesd];
}

#pragma mark - setter

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.buttonView.selected = selected;
}

#pragma mark - getter

- (BEButtonView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [BEButtonView new];
        _buttonView.userInteractionEnabled = NO;
    }
    return _buttonView;
}

@end
