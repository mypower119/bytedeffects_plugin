//
//  BESearchView.h
//  app
//
//  Created by qun on 2021/6/3.
//

#ifndef BESearchLayoutView_h
#define BESearchLayoutView_h

#import <UIKit/UIKit.h>

@class BESearchLayoutView;
@protocol BESearchLayoutViewDelegate <NSObject>

- (void)searchView:(BESearchLayoutView *)view searchDidChanged:(NSString *)search;

@end

// {zh} / 搜索布局，包括一个搜索按钮和输入框 {en} /Search layout, including a search button and input box
@interface BESearchLayoutView : UIView

@property (nonatomic, weak) id<BESearchLayoutViewDelegate> delegate;
@property (nonatomic, strong) UITextField *tfSearch;

@end

#endif /* BESearchLayoutView_h */
