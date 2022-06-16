//
//  BEBoardBottomView.h
//  Common
//
//  Created by qun on 2021/5/24.
//

#ifndef BEBoardBottomView_h
#define BEBoardBottomView_h

#import <UIKit/UIKit.h>

@class BEBoardBottomView;
@protocol BEBoardBottomViewDelegate <NSObject>

- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender;
- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender;
@optional
- (BOOL)boardBottomViewShowReset:(BEBoardBottomView *)view;
- (void)boardBottomView:(BEBoardBottomView *)view didTapReset:(UIView *)sender;

@end

// {zh} / 面板底部的 View，主要是实现了面板底部的关闭、拍照按钮 {en} /View at the bottom of the panel, mainly realizes the close and photo buttons at the bottom of the panel
@interface BEBoardBottomView : UIView

@property (nonatomic, weak) id<BEBoardBottomViewDelegate> delegate;

@end


#endif /* BEBoardBottomView_h */
