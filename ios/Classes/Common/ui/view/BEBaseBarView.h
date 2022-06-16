//
//  BEBaseBarView.h
//  Common
//
//  Created by qun on 2021/5/17.
//

#ifndef BEBaseBarView_h
#define BEBaseBarView_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaserBarMode) {
    BEBaseBarBack = 1,
    BEBaseBarImagePicker = 2,
    BEBaseBarSetting = 4,
    BEBaseBarSwitch = 8,
    BEBaseBarAll = BEBaseBarBack | BEBaseBarImagePicker | BEBaseBarSetting | BEBaseBarSwitch,
};

@class BEBaseBarView;
@protocol BEBaseBarViewDelegate <NSObject>

//   {zh} / @brief 点击打开按钮回调     {en} /@brief Click on the open button to call back 
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender;

//   {zh} / @brief 点击拍照按钮回调     {en} /@BriefClick the photo button to call back 
- (void)baseView:(BEBaseBarView *)view didTapRecord:(UIView *)sender;

//   {zh} / @brief 点击重置按钮回调     {en} /@BriefClick the reset button to call back
- (void)baseView:(BEBaseBarView *)view didTapReset:(UIView *)sender;

//   {zh} / @brief 点击返回按钮回调     {en} /@brief Click back button to call back 
- (void)baseView:(BEBaseBarView *)view didTapBack:(UIView *)sender;

//   {zh} / @brief 点击设置按钮回调     {en} /@BriefClick the Settings button to call back 
- (void)baseView:(BEBaseBarView *)view didTapSetting:(UIView *)sender;

//   {zh} / @brief 点击选择图片按钮回调     {en} /@BriefClick the Select Picture button to call back 
- (void)baseView:(BEBaseBarView *)view didTapImagePicker:(UIView *)sender;

//   {zh} / @brief 点击切换相机按钮回调，仅在相机模式下     {en} /@Brief Click the Toggle Camera button to call back, only in camera mode 
- (void)baseView:(BEBaseBarView *)view didTapSwitchCamera:(UIView *)sender;

//   {zh} / @brief 点击播放按钮回调，仅在视频模式下     {en} /@Brief Click the play button to call back, only in video mode 
- (void)baseView:(BEBaseBarView *)view didTapPlay:(UIView *)sender;

- (void)baseViewDidTouch:(BEBaseBarView *)view;

@end

@interface BEBaseBarView : UIView

@property (nonatomic, weak) id<BEBaseBarViewDelegate> delegate;
@property (nonatomic, strong) UIButton *btnPlay;
//  是否显示重置按钮
@property (nonatomic, assign) BOOL showReset;

//   {zh} / @brief 显示打开、拍照按钮     {en} /@Briefly show the open and photo buttons 
- (void)showBoard;
//   {zh} / @brief 隐藏打开、拍照按钮     {en} /@Briefly hide the open and photo buttons 
- (void)hideBoard;

// {zh} / @brief 设置顶部栏显示类型 {en} /@Brief Set the display type of the top bar
// {zh} / @param mode 具体见 BaserBarMode {en} @Param mode See BaserBarMode for details
- (void)showBar:(NSInteger)mode;

//   {zh} / @brief 显示性能标签     {en} /@Briefing Show performance labels 
- (void)showProfile:(BOOL)show;
//   {zh} / @brief 更新性能数据     {en} /@Briefly update performance data 
//   {zh} / @param frameCount 帧率     {en} /@param frameCount 
//   {zh} / @param frameTime 上一帧耗时     {en} /@param frameTime-consuming previous frame 
- (void)updateProfile:(int)frameCount frameTime:(double)frameTime resolution:(CGSize)resolution;

@end

#endif /* BEBaseBarView_h */
