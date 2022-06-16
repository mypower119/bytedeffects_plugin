//
//  TextSliderView.m
//  oc_demo
//
//  Created by QunZhang on 2019/8/3.
//  Copyright © 2019 wuruoye. All rights reserved.
//

#import "BETextSliderView.h"

@interface BETextSliderView () {
    BOOL _isShowText;
    BOOL _isInTouch;
    
    //    {zh} 基本布局数据        {en} Basic layout data  
    CGFloat _width;
    CGFloat _height;
    CGFloat _realPaddingLeft;
    CGFloat _realPaddingRight;
    
    //    {zh} 上升/下降动画的速度相关        {en} Speed correlation of rising/falling animation  
    CGFloat _animationSlop;
    CGFloat _animationProgress;
    
    //    {zh} 文字偏移范围，即文字的高度        {en} Text offset range, that is, the height of the text  
    CGFloat _maxTextOffset;
    CGFloat _minTextOffset;
    
    //    {zh} 字体大小范围        {en} Font size range  
    CGFloat _maxTextSize;
    CGFloat _minTextSize;
    
    //    {zh} 实时绘制相关数据        {en} Draw relevant data in real time  
    CGFloat _currentX;
    CGFloat _currentY;
    CGFloat _currentTextOffset;
    CGSize _currentTextSize;
    NSMutableDictionary *_textAttribute;
    NSMutableParagraphStyle *_textStyle;
}

@end

@implementation BETextSliderView

@synthesize progress = _progress;

# pragma mark - 初始化操作

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultSize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultSize];
        [self initSize:frame];
    }
    return self;
}


//    {zh} 设置默认各数据的默认值        {en} Set the default value of each data  
- (void)initDefaultSize {
    _activeLineColor = [UIColor colorWithWhite:1 alpha:0.75];
    _inactiveLineColor = [UIColor colorWithWhite:0 alpha:0.2];
    _circleColor = [UIColor colorWithWhite:1 alpha:1];
    _textColor = [UIColor colorWithWhite:0.4 alpha:1];
    
    _lineHeight = DEFAULT_LINE_HEIGHT;
    _circleRadius = DEFAULT_CIRCLE_RADIUS;
    _textSize = DEFAULT_TEXT_SIZE;
    _paddingLeft = DEFAULT_PADDING_LEFT;
    _paddingRight = DEFAULT_PADDING_RIGHT;
    _paddingBottom = DEFAULT_PADDING_BOTTOM;
    _textOffset = DEFAULT_TEXT_OFFSET;
    _animationTime = DEFAULT_ANIMATION_TIME;
    
    _progress = 0;
    _negativeable = NO;
}

- (void)initSize:(CGRect)frame {
    _width = frame.size.width;
    _height = frame.size.height;
    
    _realPaddingLeft = _circleRadius/2 + _paddingLeft;
    _realPaddingRight = _circleRadius/2 + _paddingRight;
    
    _minTextOffset = _paddingBottom + _lineHeight / 2;
    _maxTextOffset = _textOffset + _minTextOffset;
    _currentTextOffset = _minTextOffset;
    
    _maxTextSize = _textSize;
    _minTextSize = 0.F;
    
    _animationSlop = 1.F / _animationTime;
    _animationProgress = 0.F;
    
}

# pragma mark - 绘制操作
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self checkSize:rect];
    
    //    {zh} 初始化环境        {en} Initialization environment  
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, true);
    CGContextClearRect(context, rect);
    
    //    {zh} 依次画出每一个部分        {en} Draw each part in turn  
    [self computeSize];
    [self drawLine:context];
    [self drawCircle:context];
    [self drawText:context];
    
    //    {zh} 是否需要继续绘制动画        {en} Need to continue drawing animation  
    if (_isShowText) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
}

- (void)drawCGLine:(CGContextRef)context rect:(CGRect)rect color:(UIColor*)color
{
    CGContextClipToRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextMoveToPoint(context, _realPaddingLeft, _currentY);
    CGContextAddLineToPoint(context, _width - _realPaddingRight, _currentY);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextResetClip(context);
}

- (void)drawLine:(CGContextRef)context {
    CGContextSetLineWidth(context, _lineHeight);
    CGContextSetLineCap(context, kCGLineCapRound);
    

    
    if(_negativeable)
    {
        CGRect selectRect = _progress < 0.5?
                            CGRectMake(_currentX, 0, _width/2 - _currentX, _height):
                            CGRectMake( _width/2, 0, _currentX - _width/2, _height);
        
        [self drawCGLine:context rect:CGRectMake(0, 0, _width, _height) color:_inactiveLineColor];
        if(_progress!= 0.5)
        {
           [self drawCGLine:context rect:selectRect color:_activeLineColor];
        }
    }
    else
    {
        CGFloat offset = -_lineHeight / 2 + _lineHeight * _progress;
        // draw left line
        [self drawCGLine:context rect:CGRectMake(0, 0, _currentX + offset, _height) color:_activeLineColor];
        
        // draw right line
        [self drawCGLine:context rect:CGRectMake(_currentX + offset, 0, _width, _height) color:_inactiveLineColor];
    }
}

- (void)drawCircle:(CGContextRef)context {
    CGFloat radius = _isShowText ? MAX(MAX(_currentTextSize.width, _currentTextSize.height), _circleRadius) : _circleRadius;
    //    {zh} x/y 在原来的基础上向左/向上偏移半个半径，使圆形居中        {en} X/y offset half a radius to the left/up on the original basis to center the circle  
    CGFloat x = _currentX - radius / 2;
    CGFloat y = _height - _currentTextOffset - radius / 2;
    
    CGContextSetFillColorWithColor(context, [_circleColor CGColor]);
    CGContextAddEllipseInRect(context, CGRectMake(x, y, radius, radius));
    
    CGContextDrawPath(context, kCGPathFill);
}

-(void)drawText:(CGContextRef)context {
    if (!_isShowText) {
        return;
    }
    
    //    {zh} x/y 在原来的基础上向左/向上偏移半个宽/高，使文字矩形居中        {en} X/y shifts half width/height to the left/up on the original basis to center the text rectangle  
    CGFloat x = _currentX - _currentTextSize.width / 2;
    CGFloat y = _height - _currentTextOffset - _currentTextSize.height / 2;
    
    CGFloat showValue = _negativeable? (_progress * 100 - 50): _progress * 100;
    NSString *text = [[NSString alloc] initWithFormat:@"%d",  (int)showValue];  //@((int)(showValue)).stringValue;
    CGRect rect = CGRectMake(x, y, _currentTextSize.width, _currentTextSize.height);
    [text drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:_textAttribute context:nil];
}

#pragma mark - 监听手势操作

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    
    //    {zh} 设置延时显示 text        {en} Set delay to display text  
    _isInTouch = true;
    [self performSelector:@selector(startShowText) withObject:nil afterDelay:0.5];
    
    UITouch *touch = [touches anyObject];
    [self dispatchX:[touch locationInView:self].x];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
    
    //    {zh} 获取手的位置        {en} Get the position of the hand  
    UITouch *touch = [touches anyObject];
    [self dispatchX:[touch locationInView:self].x];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
    //    {zh} 取消延迟显示        {en} Cancel delay display  
    _isInTouch = false;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesCancelled:touches withEvent:event];
    //    {zh} 取消延迟显示        {en} Cancel delay display  
    _isInTouch = false;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

# pragma mark - 工具方法
//    {zh} 设置展示文字，并请求重绘        {en} Set the display text and request a redraw  
- (void)startShowText {
    _isShowText = true;
    [self setNeedsDisplay];
}

//    {zh} 剪裁 x ，使 x 的值处于绘制区域        {en} Cut x so that the value of x is in the drawing area  
- (CGFloat)clip:(CGFloat)x {
    if (x < _realPaddingLeft) {
        x = _realPaddingLeft;
    }
    if (x > _width - _realPaddingRight) {
        x = _width - _realPaddingRight;
    }
    return x;
}

//    {zh} 根据 x 的位置，计算出当前的进度，将其分发出去，并请求重绘        {en} Based on the position of x, calculate the current progress, distribute it, and request a redraw  
- (void)dispatchX:(CGFloat)x {
    x = [self clip:x];
    CGFloat progress = (x - _realPaddingLeft) / (_width - _realPaddingLeft - _realPaddingRight);
    
    if (_progress != progress) {
        _progress = progress;
        //    {zh} 震动反馈        {en} Vibration feedback  
        if (progress == 0 || progress == 1) {
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
                [generator prepare];
                [generator impactOccurred];
            } else {
                // Fallback on earlier versions
            }
        }
        //    {zh} 分发结果        {en} Distribution of results  
        if ([self.delegate respondsToSelector:@selector(progressDidChange:progress:)]) {
            [self.delegate progressDidChange:self progress:_progress];
        }
        //    {zh} 请求重绘        {en} Request redraw  
        if (!_isShowText) {
            [self setNeedsDisplay];
        }
    }
}

//    {zh} 根据当前的进度，计算当前 x y 的值，并在需要展示文字时，计算文字展示动画的进度并设置对应的值        {en} According to the current progress, calculate the current value of x y, and when you need to display text, calculate the progress of the text display animation and set the corresponding value  
- (void)computeSize {
    CGFloat width = _width - _realPaddingLeft - _realPaddingRight;
    _currentX = width * _progress + _realPaddingLeft;
    _currentY = _height - _paddingBottom - _lineHeight / 2;
    
    if (_isShowText) {
        _animationProgress += _isInTouch ? _animationSlop : -_animationSlop;
        if (_animationProgress > 1) {
            _animationProgress = 1;
        } else if (_animationProgress < 0) {
            _isShowText = false;
            _animationProgress = 0;
        }
        
        _currentTextOffset = (_maxTextOffset - _minTextOffset) * _animationProgress + _minTextOffset;
        CGFloat textSize = (_maxTextSize - _minTextSize) * _animationProgress + _minTextSize;
        
        NSString *text = _negativeable ? @(-100).stringValue : @(100).stringValue;
        if (!_textStyle) {
            _textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            _textStyle.alignment = NSTextAlignmentCenter;
        }
        if (!_textAttribute) {
            _textAttribute = [NSMutableDictionary dictionary];
            _textAttribute[NSForegroundColorAttributeName] = _textColor;
            _textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:textSize];
            _textAttribute[NSParagraphStyleAttributeName] = _textStyle;
        } else {
            _textAttribute[NSForegroundColorAttributeName] = _textColor;
            _textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:textSize];
        }
        CGSize size = [text sizeWithAttributes:_textAttribute];
        _currentTextSize = size;
    }
}

- (void)checkSize:(CGRect)rect {
    if (_width != CGRectGetWidth(rect) || _height != CGRectGetHeight(rect)) {
        [self initSize:rect];
    }
}

#pragma mark - setter
- (void)setTextOffset:(CGFloat)textOffset {
    _textOffset = textOffset;
    [self initSize:self.frame];
}

- (void)setTextSize:(CGFloat)textSize {
    _textSize = textSize;
    [self initSize:self.frame];
}

- (void)setCircleRadius:(CGFloat)circleRadius {
    _circleRadius = circleRadius;
    [self initSize:self.frame];
}

- (void)setAnimationTime:(NSInteger)animationTime {
    _animationTime = animationTime;
    [self initSize:self.frame];
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    _paddingLeft = paddingLeft;
    [self initSize:self.frame];
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    _paddingRight = paddingRight;
    [self initSize:self.frame];
}

- (void)setPaddingBottom:(CGFloat)paddingBottom {
    _paddingBottom = paddingBottom;
    [self initSize:self.frame];
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1) {
        progress = 1;
    } else if (progress < 0) {
        progress = 0;
    }
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setNegativeable:(BOOL)negativeable {
    _negativeable = negativeable;
    [self setNeedsDisplay];
}

@end
