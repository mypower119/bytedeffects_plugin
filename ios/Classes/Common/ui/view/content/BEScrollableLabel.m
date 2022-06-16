//
//  BEScrollableLabel.m
//  BECommon
//
//  Created by qun on 2021/7/7.
//

#import "BEScrollableLabel.h"

static NSString *const ANIMATION_KEY = @"BEScrollableLabelKey";

@interface BEScrollableLabel ()

@property (nonatomic, assign) CGSize oldSize;

@end

@implementation BEScrollableLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _label = [UILabel new];
        _scrollable = YES;
        
        [self addSubview:_label];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc
{
    [self.label.layer removeAllAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGSizeEqualToSize(self.frame.size, self.oldSize)) {
        return;
    }
    
    self.oldSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [self be_checkAndStartScroll];
}

- (void)setText:(NSString *)text {
    if ([text isEqual:self.label.text]) {
        return;
    }
    _text = text;
    self.label.text = text;
    
    [self be_checkAndStartScroll];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.label.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (textAlignment == self.label.textAlignment) {
        return ;
    }
    _textAlignment = textAlignment;
    self.label.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    if (font == self.label.font) {
        return;
    }
    _font = font;
    self.label.font = font;
    
    [self be_checkAndStartScroll];
}

- (void)setScrollable:(BOOL)scrollable {
    _scrollable = scrollable;
    
    [self be_checkAndStartScroll];
}

- (void)be_checkAndStartScroll {
    NSString *text = self.text == nil ? @"" : self.text;
    UIFont *font = self.font;
    if (font == nil) {
        NSLog(@"font is nil in %@", self);
        font = [UIFont systemFontOfSize:15];
    }
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    //  {zh} 纵向没有约束的话，就取 label 的高  {en} If there is no constraint on the vertical direction, take the height of the label
    if (self.bounds.size.height == 0) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, textSize.height);
    }
    
    if (_scrollable && textSize.width > self.frame.size.width) {
        self.label.frame = CGRectMake(0, 0, textSize.width, self.frame.size.height);
//        [self.label.layer removeAllAnimations];
        [self.label.layer addAnimation:[self be_getLayerAnimation] forKey:ANIMATION_KEY];
    } else {
        [self.label.layer removeAllAnimations];
        self.label.frame = self.bounds;
    }
}

- (BOOL)be_needScroll {
    NSString *text = self.text == nil ? @"" : self.text;
    CGFloat stringWidth = [text boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
    return stringWidth > self.frame.size.width;
}

- (CAAnimation *)be_getLayerAnimation {
    CGPoint anchorPoint = self.label.layer.anchorPoint;
    
    CGFloat t1 = 0.3;
    CGFloat t2 = [self be_animationDuration:self.label.frame.size.width - self.frame.size.width];
    CGFloat t3 = 0.3;
    CGFloat t4 = 0;
    CGFloat total = t1 + t2 + t3 + t4;
    CAKeyframeAnimation *keyAni = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyAni.keyTimes = @[@(t1/total), @(t2/total),
//                        @(t3/total), @(t4/total),
    ];
    keyAni.values = @[@(self.label.frame.size.width * anchorPoint.x),
                      @(self.label.frame.size.width * anchorPoint.x - (self.label.frame.size.width - self.frame.size.width)),
//                      @(self.label.frame.size.width * anchorPoint.x - (self.label.frame.size.width - self.frame.size.width)),
//                      @(self.label.frame.size.width * anchorPoint.x)
    ];
    
    keyAni.beginTime = CACurrentMediaTime() + 0.5;
    keyAni.duration = total;
    keyAni.fillMode = kCAFillModeBoth;
    keyAni.repeatCount = CGFLOAT_MAX;
    keyAni.removedOnCompletion = NO;
    return keyAni;
}

- (CGFloat)be_animationDuration:(CGFloat)length {
    CGFloat duration = length / 20;
    if (duration < 1) {
        duration = 1;
    }
    return duration;
}

@end
