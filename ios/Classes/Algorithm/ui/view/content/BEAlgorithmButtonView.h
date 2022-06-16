//
//  BEAlgorithmButtonView.h
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#ifndef BEAlgorithmButtonView_h
#define BEAlgorithmButtonView_h

#include <UIKit/UIKit.h>
#include "BEAlgorithmItem.h"

@class BEAlgorithmButtonView;
@protocol BEAlgorithmButtonViewDelegate <NSObject>

- (void)algorithmButtonView:(BEAlgorithmButtonView *)view onItem:(BEAlgorithmItem *)item selected:(BOOL)selected;

@end

// {zh} / 算法 button View，用于展示一个 AlgorithmItem 列表 {en} /Algorithm button View to display a list of AlgorithmItems
@interface BEAlgorithmButtonView : UIView

@property (nonatomic, weak) id<BEAlgorithmButtonViewDelegate> delegate;
@property (nonatomic, strong) BEAlgorithmItem *item;
@property (nonatomic, strong) NSMutableSet<BEAlgorithmKey *> *selectSet;

// protected

@property (nonatomic, strong) NSArray<BEAlgorithmItem *> *items;


- (void)setItemWithoutUI:(BEAlgorithmItem *)item;

- (BOOL)openItem:(NSInteger)index;

- (void)closeItem:(NSInteger)index;

- (void)selectItem:(NSInteger)index;

- (void)unselectItem:(NSInteger)index;

@end

#endif /* BEAlgorithmButtonView_h */
