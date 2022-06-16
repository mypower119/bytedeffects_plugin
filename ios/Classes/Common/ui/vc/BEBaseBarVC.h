//
//  BEBaseBarVC.h
//  Common
//
//  Created by qun on 2021/6/1.
//

#ifndef BEBaseBarVC_h
#define BEBaseBarVC_h

#import "BEBaseVC.h"
#import "BEBaseBarView.h"
#import "BEPopoverManager.h"
#import "BEGestureManager.h"

//   {zh} / 带一些 UI 的基类，包括上部的 bar 和底部的打开、拍照按钮，及相关代码逻辑     {en} /Base class with some UI, including the upper bar and the bottom open and photo buttons, and related code logic 
// {zh} / 以及一些测光逻辑 {en} /And some metering logic

//   {zh} / 功能：     {en} /Function: 
//   {zh} / 1. 基础 UI，上部的菜单栏、底部的拍照按钮等     {en} /1. Basic UI, upper menu bar, bottom photo button, etc 
// {zh} / 2. 基础功能，如人脸检测调测光、单击调测光等 {en} /2. Basic functions, such as face detection and light modulation, click light modulation, etc
//   {zh} / 3. 手势检测相关功能     {en} /3. Gesture detection related functions 
///
@interface BEBaseBarVC : BEBaseVC <BEBaseBarViewDelegate, BEPopoverManagerDelegate, BEGestureDelegate>

@property (nonatomic, strong) BEBaseBarView *baseView;
@property (nonatomic, strong) BEGestureManager *gestureManager;

// protected

//   {zh} / @brief 根据配置项展示 popover     {en} /@Briefly show popover according to configuration item 
//   {zh} / @param configs 配置项，具体见 BESwitchItemConfig 和 BESingleSwitchConfig     {en} /@param configs, see BESwitchItemConfig and BESingleSwitchConfig for details 
//   {zh} / @param anchor 目标 view     {en} /@param anchor target view 
- (void)showPopoverViewWithConfigs:(NSArray *)configs anchor:(UIView *)anchor;

//   {zh} / @brief 展示性能标签     {en} /@Briefly show performance tags 
//   {zh} / @param isShow 是否展示     {en} /@param isShow whether to show 
- (void)showProfile:(BOOL)isShow;

@end

#endif /* BEBaseBarVC_h */
