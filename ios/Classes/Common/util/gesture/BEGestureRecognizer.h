//
//  BEGestureRecognizer.h
//  BytedEffects
//
//  Created by qun on 2021/2/28.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEGestureRecognizer_h
#define BEGestureRecognizer_h

#import <UIKit/UIGestureRecognizerSubclass.h>

@class BEGestureRecognizer;
@protocol BEGestureRecognizerDelegate <NSObject>

- (void)gestureRecognizer:(BEGestureRecognizer *)recognizer onTouchEvent:(NSSet<UITouch *> *)touches;

@end

// {zh} / 触摸事件检测 {en} /Touch event detection
@interface BEGestureRecognizer : UIGestureRecognizer

@property (nonatomic, weak) id<BEGestureRecognizerDelegate> recognizerDelegate;

@end

#endif /* BEGestureRecognizer_h */
