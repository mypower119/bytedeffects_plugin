//
//  BEDownloadView.m
//  BECommon
//
//  Created by qun on 2021/10/28.
//

#import "BEDownloadView.h"

#define REFRESH_SET(NAME, TYPE, VALUE)\
- (void)set##NAME:(TYPE)VALUE {\
    _##VALUE = VALUE;\
    [self setNeedsDisplay];\
}

@interface BEDownloadView () {
    CGPoint             _center;
    CGFloat             _maxRadius;
}

@property (nonatomic, strong) UIImageView *iv;

@end

@implementation BEDownloadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _state = BEDownloadViewStateInit;
        _downloadProgress = 0.f;
        _backgroundLineWidth = 2.f;
        _progressLineWidth = 1.5f;
        
        _backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _progressColor = [UIColor colorWithWhite:1 alpha:1];
        
        self.opaque = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    _center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    _maxRadius = MIN(rect.size.width, rect.size.height) / 2 - 1;
    
    if (_iv) {
        _iv.frame = self.bounds;
    }
}

//REFRESH_SET(State, BEDownloadViewState, state)
REFRESH_SET(DownloadProgress, CGFloat, downloadProgress)
REFRESH_SET(BackgroundColor, UIColor *, backgroundColor)
REFRESH_SET(BackgroundLineWidth, CGFloat, backgroundLineWidth)
REFRESH_SET(ProgressColor, UIColor *, progressColor)
REFRESH_SET(ProgressLineWidth, CGFloat, progressLineWidth)
REFRESH_SET(DownloadImage, UIImage *, downloadImage)

- (void)setState:(BEDownloadViewState)state {
    _state = state;
    [self setNeedsDisplay];
    
    if (state == BEDownloadViewStateInit) {
        [self be_AddDownloadImage:nil];
    } else {
        if (_iv) {
            [_iv removeFromSuperview];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_state == BEDownloadViewStateDownloading) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShouldAntialias(context, true);
        CGContextClearRect(context, rect);
        
        [self be_drawBackgroundCircular:context];
        [self be_drawProgressCircular:context progress:_downloadProgress];
    }
}

- (void)be_drawBackgroundCircular:(CGContextRef)context {
    CGContextSetLineWidth(context, _backgroundLineWidth);
    CGContextSetStrokeColorWithColor(context, [_backgroundColor CGColor]);
    CGContextAddArc(context, _center.x, _center.y, _maxRadius - _backgroundLineWidth / 2, 0, 2 * M_PI, 0);
    CGContextStrokePath(context);
}

- (void)be_drawProgressCircular:(CGContextRef)context progress:(CGFloat)progress {
    CGFloat angle = 2 * M_PI * progress;
    CGContextSetLineWidth(context, _progressLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [_progressColor CGColor]);
    CGContextAddArc(context, _center.x, _center.y, _maxRadius - _backgroundLineWidth / 2, - M_PI_2, angle - M_PI_2, 0);
    CGContextStrokePath(context);
}

- (void)be_AddDownloadImage:(CGContextRef)context {
    [_iv removeFromSuperview];
    
    [self addSubview:self.iv];
    self.iv.frame = self.bounds;
}

- (UIImageView *)iv {
    if (_iv) {
        return _iv;
    }
    
    _iv = [UIImageView new];
    _iv.image = _downloadImage;
    return _iv;
}

@end
