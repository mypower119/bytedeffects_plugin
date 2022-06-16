//
//  BEPopoverView.m
//  Common
//
//  Created by qun on 2021/6/17.
//

#import "BEPopoverView.h"
#import "BEPopoverIndicatorView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEPopoverView ()

@end

@implementation BEPopoverView

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView sourceRect:(CGRect)sourceRect {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat LINE_HEIGHT = BEF_DESIGN_SIZE(48);
        CGFloat INDICATOR_MARGIN = BEF_DESIGN_SIZE(3.5);
        CGFloat INDICATOR_HEIGHT = BEF_DESIGN_SIZE(8);
        CGFloat INDICATOR_WIDTH = BEF_DESIGN_SIZE(20);
        
        contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        contentView.layer.cornerRadius = 6;
        contentView.frame = CGRectMake(16, sourceRect.origin.y + sourceRect.size.height + INDICATOR_HEIGHT + INDICATOR_MARGIN, self.frame.size.width - 32, LINE_HEIGHT * (contentView.subviews.count + 1) / 2);
        [self addSubview:contentView];
        
        CGFloat x = sourceRect.origin.x + sourceRect.size.width / 2 - INDICATOR_WIDTH / 2;
        CGFloat y = sourceRect.origin.y + sourceRect.size.height;
        BEPopoverIndicatorView *indicator = [[BEPopoverIndicatorView alloc] initWithFrame:CGRectMake(x, y, INDICATOR_WIDTH, INDICATOR_HEIGHT + INDICATOR_MARGIN)];
        indicator.indicatorColor = [UIColor colorWithWhite:0 alpha:0.6];
        indicator.backgroundColor = [UIColor clearColor];
        [self addSubview:indicator];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    UIView *v = [self hitTest:point withEvent:event];
    
    if (v == self) {
        [self.delegate popoverViewDidTouch:self];
    }
}

@end
