//
//  BEGestureManager.m
//  BytedEffects
//
//  Created by qun on 2021/2/25.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEGestureManager.h"
#import "BEGestureRecognizer.h"

@interface BEGestureManager () <UIGestureRecognizerDelegate, BEGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotateRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;
@property (nonatomic, strong) BEGestureRecognizer *gestureRecognizer;

@property (nonatomic, weak) UIView *view;

@end


@implementation BEGestureManager {
    CGFloat         _preScale;
    CGFloat         _preRotate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enable = YES;
        _skipEdge = YES;
        _edgeWidth = 10;
        _preScale = 1.f;
        _preRotate = 0.f;
    }
    return self;
}

- (void)attachView:(UIView *)view {
    self.view = view;
    [view addGestureRecognizer:self.tapRecognizer];
    [view addGestureRecognizer:self.panRecognizer];
    [view addGestureRecognizer:self.pinchRecognizer];
    [view addGestureRecognizer:self.rotateRecognizer];
    [view addGestureRecognizer:self.longPressRecognizer];
    [view addGestureRecognizer:self.gestureRecognizer];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [self.delegate gestureManager:self onGesture:BEGestureTypeTap x:point.x y:point.y dx:0.f dy:0.f factor:0.f];
    } else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [self.panRecognizer velocityInView:self.view];
        [self.delegate gestureManager:self onGesture:BEGestureTypePan x:point.x y:point.y dx:velocity.x dy:velocity.y factor:0.025f];
    } else if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        CGFloat scale = self.pinchRecognizer.scale;
        [self.delegate gestureManager:self onGesture:BEGestureTypeScale x:scale / _preScale y:0.f dx:0.f dy:0.f factor:3.f];
        _preScale = scale;
    } else if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        CGFloat rotate = self.rotateRecognizer.rotation;
        [self.delegate gestureManager:self onGesture:BEGestureTypeRotate x:rotate - _preRotate y:0.f dx:0.f dy:0.f factor:6.f];
        _preRotate = rotate;
    } else if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [self.delegate gestureManager:self onGesture:BEGestureTypeLongPress x:point.x y:point.y dx:0.f dy:0.f factor:0.f];
    }
}

#pragma mark BEGestureRecognizerDelegate
- (void)gestureRecognizer:(BEGestureRecognizer *)recognizer onTouchEvent:(NSSet<UITouch *> *)touches {
    NSInteger pointerCount = touches.count;
    for (int i = 0; i < touches.count; ++i) {
        UITouch *touch = touches.allObjects[i];
        CGPoint point = [touch locationInView:self.view];
        CGFloat force = touch.force;
        CGFloat majorRadius = touch.majorRadius;
        switch (touch.phase) {
            case UITouchPhaseBegan:
                [self.delegate gestureManager:self onTouchEvent:BETouchEventBegan x:point.x y:point.y force:force majorRadius:majorRadius pointerId:i pointerCount:pointerCount];
                [self be_touchBegan];
                break;
            case UITouchPhaseMoved:
                [self.delegate gestureManager:self onTouchEvent:BETouchEventMoved x:point.x y:point.y force:force majorRadius:majorRadius pointerId:i pointerCount:pointerCount];
                break;
            case UITouchPhaseStationary:
                [self.delegate gestureManager:self onTouchEvent:BETouchEventStationary x:point.x y:point.y force:force majorRadius:majorRadius pointerId:i pointerCount:pointerCount];
                break;
            case UITouchPhaseEnded:
                [self.delegate gestureManager:self onTouchEvent:BETouchEventEnded x:point.x y:point.y force:force majorRadius:majorRadius pointerId:i pointerCount:pointerCount];
                [self be_touchEnded];
                break;
            case UITouchPhaseCancelled:
                [self.delegate gestureManager:self onTouchEvent:BETouchEventCanceled x:point.x y:point.y force:force majorRadius:majorRadius pointerId:i pointerCount:pointerCount];
                [self be_touchEnded];
                break;
            default:
                break;
        }
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_skipEdge) {
        CGPoint point = [touch locationInView:self.view];
        if (point.x < _edgeWidth) {
            return NO;
        }
    }
    return _enable ? touch.view == self.view : NO;
}

#pragma mark private
- (void)be_touchBegan {
    _preScale = 1.f;
    _preRotate = 0.f;
}

- (void)be_touchEnded {
    
}

#pragma mark getter
- (UITapGestureRecognizer *)tapRecognizer {
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _tapRecognizer.delegate = self;
    }
    return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panRecognizer {
    if (_panRecognizer == nil) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _panRecognizer.delegate = self;
    }
    return _panRecognizer;
}

- (UIPinchGestureRecognizer *)pinchRecognizer {
    if (_pinchRecognizer == nil) {
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _pinchRecognizer.delegate = self;
    }
    return _pinchRecognizer;
}

- (UIRotationGestureRecognizer *)rotateRecognizer {
    if (_rotateRecognizer == nil) {
        _rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    }
    return _rotateRecognizer;
}

- (UILongPressGestureRecognizer *)longPressRecognizer {
    if (_longPressRecognizer == nil) {
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _longPressRecognizer.delegate = self;
    }
    return _longPressRecognizer;
}

- (BEGestureRecognizer *)gestureRecognizer {
    if (_gestureRecognizer == nil) {
        _gestureRecognizer = [[BEGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _gestureRecognizer.recognizerDelegate = self;
        _gestureRecognizer.delegate = self;
    }
    return _gestureRecognizer;
}

@end
