//
//  BETitleBoardView.h
//  Effect
//
//  Created by qun on 2021/5/27.
//

#ifndef BETitleBoardView_h
#define BETitleBoardView_h

#import <UIKit/UIKit.h>
#import "BEBoardBottomView.h"

@protocol BETitleBoardViewDelegate <BEBoardBottomViewDelegate>

@end

// {zh} / 一个带有标题的面板 view，内含了 BoardBottomView 和一个标题， {en} /A panel view with a title, including BoardBottomView and a title,
// {zh} / 只需要给它传一个 contentView 就可以构成一个完整的面板 {en} /Just pass it a contentView to form a complete panel
@interface BETitleBoardView : UIView

@property (nonatomic, strong) UIView *boardContentView;

@property (nonatomic, weak) id<BETitleBoardViewDelegate> delegate;
- (void)updateBoardTitle:(NSString *)title;

@end

#endif /* BETitleBoardView_h */
