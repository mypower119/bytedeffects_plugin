//
//  BEBaseSelectableView.h
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#ifndef BEBaseSelectableView_h
#define BEBaseSelectableView_h

#import <UIKit/UIKit.h>

@class BEBaseSelectableView;
@protocol BESelectableConfig <NSObject>

@property (nonatomic, assign) CGSize imageSize;

- (BEBaseSelectableView *)generateView;

@end

/// @brief 可选中的 View 基类
@interface BEBaseSelectableView : UIView

@property (nonatomic, assign) BOOL isSelected;

@end

#endif /* BEBaseSelectableView_h */
