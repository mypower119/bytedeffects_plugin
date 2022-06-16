//
//  BESelectableButton.h
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#ifndef BESelectableButton_h
#define BESelectableButton_h

#import "BEBaseSelectableView.h"

@class BESelectableButton;
@protocol BESelectableButtonDelegate <NSObject>

- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender;

@end

/// @brief 可选中的按钮
@interface BESelectableButton : UIView

- (instancetype)initWithSelectableConfig:(id<BESelectableConfig>)config;

/// 点击回调
@property (nonatomic, weak) id<BESelectableButtonDelegate> delegate;

@property (nonatomic, strong) id<BESelectableConfig> selectableConfig;

/// 是否选中
@property (nonatomic, assign) BOOL isSelected;

/// 是否显示原点标志
@property (nonatomic, assign) BOOL isPointOn;

/// 文字标题
@property (nonatomic, copy) NSString *title;

@end

#endif /* BESelectableButton_h */
