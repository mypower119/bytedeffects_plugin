//
//  BEScanView.m
//  Effect
//
//  Created by qun on 2021/6/3.
//

#import "BEScanView.h"

// {zh} / 每秒扫屏幕次数，full scan / second {en} /Screen scans per second, full scans/second
static const CGFloat SCAN_VELOCITY = 0.5;

@interface BEScanView ()

// {zh} / 当前扫过的进度 {en} /Current scan progress
@property (nonatomic, assign) CGFloat maskProportion;

// {zh} / 上一次绘制时间 {en} /Last draw time
@property (nonatomic, assign) double lastFrameTime;

// {zh} / 扫描范围 {en} /Scan range
@property (nonatomic, assign) CGRect maskRect;

@property (nonatomic, assign) BOOL needNextFrame;

@end

@implementation BEScanView

- (instancetype)initWithFrame:(CGRect)frame qrRect:(CGRect)rect {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:[self maskLayerWithFrame:frame qrRect:rect]];
        
        _maskProportion = 0.f;
        _lastFrameTime = 0.f;
        _needNextFrame = YES;
    }
    return self;
}

- (void)startScan {
    _lastFrameTime = 0.f;
    _maskProportion = 0.f;
    _needNextFrame = YES;
    [self setNeedsDisplay];
}

- (void)stopScan {
    _lastFrameTime = 0.f;
    _maskProportion = 0.f;
    _needNextFrame = NO;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    double curTime = [NSDate date].timeIntervalSince1970;
    if (_lastFrameTime == 0.f) {
        // skip
    } else {
        double intervalTime = curTime - _lastFrameTime;
        double intervalProportion = intervalTime * SCAN_VELOCITY;
        _maskProportion += intervalProportion;
        if (_maskProportion >= 1.f) {
            _maskProportion -= 1.f;
        }
        
        CGRect maskRect = CGRectMake(_maskRect.origin.x, _maskRect.origin.y, _maskRect.size.width, _maskRect.size.height * _maskProportion);
        
        //  {zh} 初始化环境  {en} Initialization environment
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, true);
        CGContextClearRect(context, rect);
        
        UIImage *img = [UIImage imageNamed:@"ic_scan_mask"];
        CGContextClipToRect(context, maskRect);
        CGContextDrawImage(context, _maskRect, img.CGImage);
        CGContextResetClip(context);
    }
    
    if (_needNextFrame) {
        _lastFrameTime = curTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
}

- (CAShapeLayer *)maskLayerWithFrame:(CGRect)frame qrRect:(CGRect)rect {
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    int qrCodeScanRectWidth = rect.size.width;
    CGFloat left = width / 2 - qrCodeScanRectWidth / 2;
    CGFloat right = width - left;
    CGFloat top = height / 2 - qrCodeScanRectWidth / 2;
    CGFloat bottom = height - top;
    
    // {zh} 添加了上下左右四个框来实现扫码的扫描框 {en} Added four boxes to scan the code
    UIBezierPath *leftPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., left, height)];
    UIBezierPath *rightPath = [UIBezierPath bezierPathWithRect:CGRectMake(right, 0., left, height)];
    UIBezierPath *topPath = [UIBezierPath bezierPathWithRect:CGRectMake(left, 0., qrCodeScanRectWidth, top)];
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:CGRectMake(left, bottom, qrCodeScanRectWidth, bottom)];
    [leftPath appendPath:rightPath];
    [leftPath appendPath:topPath];
    [leftPath appendPath:bottomPath];
    
    CAShapeLayer *qrCodeScanMaskLayer = [CAShapeLayer layer];
    qrCodeScanMaskLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    qrCodeScanMaskLayer.opacity = 0.5;
    qrCodeScanMaskLayer.path = leftPath.CGPath;
    
    int borderLenght = 20;
    CAShapeLayer *leftTopLayer = [CAShapeLayer layer];
    leftTopLayer.frame = CGRectMake(left-1, top-1, borderLenght, borderLenght);
    leftTopLayer.contents = (id) [UIImage imageNamed:@"ic_rect_left_top"].CGImage;
    [qrCodeScanMaskLayer addSublayer:leftTopLayer];
    
    CAShapeLayer *leftBottomLayer = [CAShapeLayer layer];
    leftBottomLayer.frame = CGRectMake(left-1, bottom+1-borderLenght, borderLenght, borderLenght);
    leftBottomLayer.contents = (id) [UIImage imageNamed:@"ic_rect_left_bottom"].CGImage;
    [qrCodeScanMaskLayer addSublayer:leftBottomLayer];
    
    CAShapeLayer *rightTopLayer = [CAShapeLayer layer];
    rightTopLayer.frame = CGRectMake(right+1-borderLenght, top-1, borderLenght, borderLenght);
    rightTopLayer.contents = (id) [UIImage imageNamed:@"ic_rect_right_top"].CGImage;
    [qrCodeScanMaskLayer addSublayer:rightTopLayer];
    
    CAShapeLayer *rightBottomLayer = [CAShapeLayer layer];
    rightBottomLayer.frame = CGRectMake(right+1-borderLenght, bottom+1-borderLenght, borderLenght, borderLenght);
    rightBottomLayer.contents = (id) [UIImage imageNamed:@"ic_rect_right_bottom"].CGImage;
    [qrCodeScanMaskLayer addSublayer:rightBottomLayer];
    
    _maskRect = CGRectMake(left, top, right-left, bottom-top);
    
    return qrCodeScanMaskLayer;
}

@end
