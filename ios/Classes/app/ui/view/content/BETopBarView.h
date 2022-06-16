//
//  BETopBarView.h
//  app
//
//  Created by qun on 2021/6/3.
//

#ifndef BETopBarView_h
#define BETopBarView_h

#import <UIKit/UIKit.h>

@class BETopBarView;
@protocol BETopBarViewDelegate <NSObject>

- (void)topBarView:(BETopBarView *)view didTapSearch:(UIView *)sender;
- (void)topBarView:(BETopBarView *)view didTapQRScan:(UIView *)sender;

@end

// {zh} / 顶部 bar，包括一个搜索栏和扫一扫按钮 {en} /Top bar, including a search bar and sweep button
@interface BETopBarView : UIView

@property (nonatomic, weak) id<BETopBarViewDelegate> delegate;

@end

#endif /* BETopBarView_h */
