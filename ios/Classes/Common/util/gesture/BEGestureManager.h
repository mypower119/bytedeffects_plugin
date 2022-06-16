//
//  BEGestureManager.h
//  BytedEffects
//
//  Created by qun on 2021/2/25.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEGestureManager_h
#define BEGestureManager_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BETouchEvent) {
    BETouchEventBegan,
    BETouchEventMoved,
    BETouchEventStationary,
    BETouchEventEnded,
    BETouchEventCanceled,
};

typedef NS_ENUM(NSInteger, BEGestureType) {
    BEGestureTypeTap,
    BEGestureTypePan,
    BEGestureTypeScale,
    BEGestureTypeRotate,
    BEGestureTypeLongPress,
    BEGestureTypeDoubleTap,
};

@class BEGestureManager;
@protocol BEGestureDelegate <NSObject>

// {zh} / @brief 触摸事件回调 {en} /@brief touch event callback
/// @param manager BEGestureManager
// {zh} / @param event 事件类型 {en} /@param event event type
// {zh} / @param x 触摸位置 {en} @Param x touch position
// {zh} / @param y 触摸位置 {en} @Param y touch position
// {zh} / @param force 触摸压力值 {en} @param force touch pressure value
// {zh} / @param majorRadius 触摸范围 {en} @param majorRadius touch range
// {zh} / @param pointerId 触摸点 id {en} /@param pointerId touch point id
// {zh} / @param pointerCount 触摸点数量 {en} @param pointerCount number of touch points
- (void)gestureManager:(BEGestureManager *)manager onTouchEvent:(BETouchEvent)event x:(CGFloat)x y:(CGFloat)y force:(CGFloat)force majorRadius:(CGFloat)majorRadius pointerId:(NSInteger)pointerId pointerCount:(NSInteger)pointerCount;

// {zh} / @brief 手势事件回调 {en} /@brief gesture event callback
/// @param manager BEGestureManager
// {zh} / @param gesture 手势类型 {en} @param gesture type
// {zh} / @param x 触摸位置，根据手势不同而不同，如缩放手势表示缩放倍数，旋转手势表示旋转角度 {en} /@Param x Touch position, depending on the gesture, such as the zoom gesture indicates the zoom multiple, and the rotation gesture indicates the rotation angle
// {zh} / @param y 触摸位置 {en} @Param y touch position
/// @param dx dx
/// @param dy dy
// {zh} / @param factor 缩放因数 {en} /@param factor scaling factor
- (void)gestureManager:(BEGestureManager *)manager onGesture:(BEGestureType)gesture x:(CGFloat)x y:(CGFloat)y dx:(CGFloat)dx dy:(CGFloat)dy factor:(CGFloat)factor;

@end


//   {zh} / @brief 手势检测类     {en} /@Brief gesture detection class 
//   {zh} / @details 内部整合了多种手势检测（单击、长按、缩放、旋转、触摸等），提供统一输出口。     {en} /@details integrates a variety of gesture detection (click, long press, zoom, rotation, touch, etc.) to provide a unified output port. 
@interface BEGestureManager : NSObject

@property (nonatomic, weak) id<BEGestureDelegate> delegate;

//   {zh} / 是否开启检测     {en} /Whether to open detection 
@property (nonatomic, assign, getter=isEnable) BOOL enable;

//   {zh} / 是否跳过左边界的事件，在与 NavigationController 共同使用的时候，     {en} /Whether to skip the events on the left side, when used with NavigationController, 
// {zh} / 需要设置为 YES 以支持侧滑返回。 {en} /Need to be set to YES to support sideslip return.
@property (nonatomic, assign, getter=isSkipEdge) BOOL skipEdge;

//   {zh} / 边界的宽度，默认 10     {en} /Boundary width, default 10 
@property (nonatomic, assign) CGFloat edgeWidth;

//   {zh} / @brief 将手势检测绑定到 UIView     {en} Bind gesture detection to UIView 
//   {zh} / @details 后续所有事件的 x y，都是基于此 view 的尺寸给出的。     {en} /@details The x y of all subsequent events is given based on the size of this view. 
//   {zh} / @param view 需要检测手势的 view     {en} /@Param view The view that needs to detect gestures 
- (void)attachView:(UIView *)view;

@end

#endif /* BEGestureManager_h */
