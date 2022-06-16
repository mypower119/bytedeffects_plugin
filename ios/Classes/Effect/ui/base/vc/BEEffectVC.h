//
//  BEEffectVC.h
//  Effect
//
//  Created by qun on 2021/5/17.
//

#ifndef BEEffectVC_h
#define BEEffectVC_h

#import "BEBaseBarVC.h"
#import "BEEffectConfig.h"
#import "BEEffectManager.h"
#import "BEEffectDataManager.h"
#import "BEEffectBaseView.h"
#import "BEBubbleTipManager.h"
#import "BEBoardBottomView.h"
#import "TZImagePickerController.h"

@interface BEEffectVC : BEBaseBarVC <BEEffectBaseViewDelegate, TZImagePickerControllerDelegate, BEBoardBottomViewDelegate, RenderMsgDelegate>

// {zh} / 特效配置 {en} /Effect configuration
@property (nonatomic, strong) BEEffectConfig *effectConfig;

// protected

// {zh} / 特效 SDK {en} /Special effects SDK
@property (nonatomic, strong) BEEffectManager *manager;

// {zh} / 数据提供类 {en} /Data provision class
@property (nonatomic, strong) BEEffectDataManager *dataManager;

// {zh} / 弹出提示类 {en} /Pop-up prompt class
@property (nonatomic, strong) BEBubbleTipManager *tipManager;

// {zh} / 是否开启默认特效 {en} /Whether to enable default effects
@property (nonatomic, assign) BOOL defaultEffectOn;

@property (nonatomic, strong) BEEffectBaseView *effectBaseView;

// {zh} / @brief 设置默认特效 {en} /@brief Set default effects
// {zh} / @details 除了参数里带着的 items，其余的如滤镜、贴纸都会关闭 {en} /@Details except for the items in the parameters, the rest such as filters and stickers will be closed
// {zh} / @param items 特效列表 {en} /@Param items special effects list
- (void)resetToDefaultEffect:(NSArray<BEEffectItem *> *)items;

// {zh} / @brief 设置特效列表 {en} /@Briefly set the special effects list
// {zh} / @param items 特效列表 {en} /@Param items special effects list
- (void)updateComposerNode:(NSArray<BEEffectItem *> *)items;

// {zh} / @brief 更新特效强度 {en} /@Briefly update the intensity of special effects
// {zh} / @param item 特效项 {en} /@param item
- (void)updateComposerNodeIntensity:(BEEffectItem *)item;

// {zh} / @brief 重新设置特效 {en} /@Briefly reset the special effects
// {zh} / @details 只会重新设置特效，滤镜、贴纸等不会关闭， {en} /@Details will only reset the special effects, filters, stickers, etc. will not be turned off,
// {zh} / 子类可重写此方法 {en} /Subclass can override this method
- (void)refreshEffect;

/// @brief 更新底部菜单栏高度
/// @param view 菜单栏 view
/// @param size 菜单栏尺寸
- (void)updateBottomView:(UIView *)view withSize:(CGSize)size;
// {zh} / @brief 展示底部菜单栏 {en} /@Briefly show the bottom menu bar
// {zh} / @param view 菜单栏 view {en} /@param view menu bar view
// {zh} / @param target 父 view {en} /@param target parent view
- (void)showBottomView:(UIView *)view target:(UIView *)target;

// {zh} / @brief 隐藏底部菜单栏 {en} /@Brief Hide bottom menu bar
// {zh} / @param view 菜单栏 view {en} /@param view menu bar view
- (void)hideBottomView:(UIView *)view showBoard:(BOOL)isShowBoard;

@end

#endif /* BEEffectVC_h */
