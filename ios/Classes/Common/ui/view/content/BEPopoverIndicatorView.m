//
//  BEPopoverIndicatorView.m
//  Common
//
//  Created by qun on 2021/6/17.
//

#import "BEPopoverIndicatorView.h"

static CGFloat CURVE_PROPORTION = 1.f / 15;

@interface BEPopoverIndicatorView ()

@end

@implementation BEPopoverIndicatorView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //  {zh} 初始化环境  {en} Initialization environment
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, true);
    CGContextClearRect(context, rect);
    
    CGRect bounds = self.bounds;
    CGPoint p1 = CGPointMake(0, bounds.size.height);
    CGPoint p2 = CGPointMake(bounds.size.width/2, 0);
    CGPoint p3 = CGPointMake(bounds.size.width, bounds.size.height);
    CGPoint p4 = CGPointMake(p2.x - bounds.size.width * CURVE_PROPORTION, p2.y + bounds.size.height * CURVE_PROPORTION);
    CGPoint p5 = CGPointMake(p2.x + bounds.size.width * CURVE_PROPORTION, p2.y + bounds.size.height * CURVE_PROPORTION);
    
    //  {zh} 移动到左下角  {en} Move to the lower left corner
    CGContextMoveToPoint(context, p1.x, p1.y);
    //  {zh} 直线到 p4  {en} Straight to p4
    CGContextAddLineToPoint(context, p4.x, p4.y);
    //  {zh} 曲线到 p5  {en} Curve to p5
    CGContextAddQuadCurveToPoint(context, p2.x, p2.y, p5.x, p5.y);
    //  {zh} 直线到 p3  {en} Straight to p3
    CGContextAddLineToPoint(context, p3.x, p3.y);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, self.indicatorColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
}

@end
