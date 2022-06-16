//
//  BESearchView.h
//  app
//
//  Created by qun on 2021/6/10.
//

#ifndef BESearchView_h
#define BESearchView_h

#import "BESearchLayoutView.h"

@class BESearchView;
@protocol BESearchViewDelegate <BESearchLayoutViewDelegate>

- (void)searchView:(BESearchView *)view didTapCancel:(UIView *)sender;

@end

// {zh} / 搜索页面 View {en} /Search Page View
@interface BESearchView : UIView

@property (nonatomic, weak) id<BESearchViewDelegate> delegate;

@end

#endif /* BESearchView_h */
