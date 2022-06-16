//
//  BEMainCVAdapter.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEMainCVAdapter_h
#define BEMainCVAdapter_h

#import <UIKit/UIKit.h>
#import "BEFeatureItem.h"
#import "BEEffectSwitchTabView.h"
#import "BEHeaderScrollViewDelegate.h"

@protocol BEMainCVDelegate <NSObject>

- (void)didClickItem:(BEFeatureItem *)item;

@end

// {zh} / 首页功能列表 CollectionView 的封装，还用于控制 CollectionView 与 SwitchTabView 的联动等功能 {en} /Home Feature List CollectionView encapsulation, also used to control the linkage between CollectionView and SwitchTabView and other functions
@interface BEMainCVAdapter : BEHeaderScrollViewDelegate <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<BEMainCVDelegate> delegate;
@property (nonatomic, strong) NSArray<BEFeatureGroup *> *featureItems;

@property (nonatomic, strong, readonly) BEEffectSwitchTabView *tabView;

@end

#endif /* BEMainCVAdapter_h */
