//
//  BEGestureRecognizer.m
//  BytedEffects
//
//  Created by qun on 2021/2/28.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEGestureRecognizer.h"

@interface BEGestureRecognizer ()

@end

@implementation BEGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.recognizerDelegate gestureRecognizer:self onTouchEvent:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self.recognizerDelegate gestureRecognizer:self onTouchEvent:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.recognizerDelegate gestureRecognizer:self onTouchEvent:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.recognizerDelegate gestureRecognizer:self onTouchEvent:touches];
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

@end
