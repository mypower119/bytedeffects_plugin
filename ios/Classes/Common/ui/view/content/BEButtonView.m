//
//  BEButtonView.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/13.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"
#import "BEButtonView.h"
#import "BEScrollableLabel.h"

@interface BEButtonView ()

@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) BEScrollableLabel *lTitle;
@property (nonatomic, strong) UIImageView *ivPoint;

@property (nonatomic, strong) UIImage *selectImg;
@property (nonatomic, strong) UIImage *unselectImg;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *unselectColor;

@end


@implementation BEButtonView

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _selectColor = [UIColor colorWithWhite:1 alpha:1];
        _unselectColor = [UIColor colorWithWhite:0.65 alpha:1];
        _selected = NO;
        [self be_setClickListener];
    }
    return self;
}

- (void)be_setClickListener
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)onClicked
{
    if ([self.delegate respondsToSelector:@selector(buttonViewDidTap:)]) {
        [self.delegate buttonViewDidTap:self];
    }
}

#pragma mark - public

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _selectImg = selectImg;
    _unselectImg = unselectImg;
    self.iv.image = _selected ? selectImg : unselectImg;
    
    [self addSubview:self.iv];
    [self.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg title:(NSString *)title expand:(BOOL)expand withPoint:(BOOL)withPoint
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _selectImg = selectImg;
    _unselectImg = unselectImg;
    self.iv.image = _selected ? selectImg : unselectImg;
    self.lTitle.text = title;
    int titleOffset = 0;
    
    [self addSubview:self.iv];
    [self addSubview:self.lTitle];
    if (withPoint) {
        titleOffset = -8;
        self.ivPoint.hidden = YES;
        [self addSubview:self.ivPoint];
        [self.ivPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(5);
            make.bottom.equalTo(self).offset(1.5);
        }];
    }
    
    [self.lTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(titleOffset);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    if (expand) {
        [self.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self.lTitle.mas_top).with.offset(-5);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(self.iv.mas_height);
        }];
    } else {
        [self.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
    }
}

- (void)setPointOn:(BOOL)isOn {
    self.ivPoint.hidden = !isOn;
}

#pragma mark - setter

- (void)setSelected:(BOOL)selected
{
    [self.iv setImage:selected ? _selectImg : _unselectImg];
    self.lTitle.textColor = selected ? _selectColor : _unselectColor;
    _selected = selected;
}

#pragma mark - getter

- (UIImageView *)iv
{
    if (!_iv) {
        _iv = [UIImageView new];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
    }
    return _iv;
}

- (BEScrollableLabel *)lTitle
{
    if (!_lTitle) {
        _lTitle = [BEScrollableLabel new];
        _lTitle.font = [UIFont systemFontOfSize:13];
        _lTitle.textColor = _unselectColor;
        _lTitle.textAlignment = NSTextAlignmentCenter;
//        _lTitle.numberOfLines = 1;
//        _lTitle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _lTitle;
}

- (UIImageView *)ivPoint {
    if (_ivPoint == nil) {
        _ivPoint = [UIImageView new];
        _ivPoint.image = [UIImage imageNamed:@"ic_point"];
    }
    return _ivPoint;
}

@end
