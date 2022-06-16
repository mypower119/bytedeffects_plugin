//
//  BEAlgorithmView.h
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#ifndef BEAlgorithmView_h
#define BEAlgorithmView_h

#import <UIKit/UIKit.h>
#import "BETitleBoardView.h"
#import "BEAlgorithmButtonView.h"

@class BEAlgorithmView;
@protocol BEAlgorithmViewDelegate <BETitleBoardViewDelegate, BEAlgorithmButtonViewDelegate>

@end

// {zh} / 算法页面底部面板 {en} /Algorithm page bottom panel
@interface BEAlgorithmView : UIView

@property (nonatomic, weak) id<BEAlgorithmViewDelegate> delegate;

- (void)setItem:(BEAlgorithmItem *)item selectSet:(NSMutableSet<BEAlgorithmKey *> *)selectSet;
- (void)setContentView:(UIView *)contentView title:(NSString *)title;

@end

#endif /* BEAlgorithmView_h */
