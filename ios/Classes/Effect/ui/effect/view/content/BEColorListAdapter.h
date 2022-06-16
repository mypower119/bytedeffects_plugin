//
//  BEColorListAdapter.h
//  BEEffect
//
//  Created by qun on 2021/8/30.
//

#ifndef BEColorListAdapter_h
#define BEColorListAdapter_h

#import <UIKit/UIKit.h>
#import "BEEffectColorItem.h"

@class BEColorListAdapter;
@protocol BEColorListAdapterDelegate <NSObject>

- (void)colorListAdapter:(BEColorListAdapter *)adapter didSelectedAt:(NSInteger)index;

@end

@interface BEColorListAdapter : NSObject

- (instancetype)initWithColorset:(NSArray<BEEffectColorItem *> *)colorset;

- (void)refreshWith:(NSArray<BEEffectColorItem *> *)colorset;

- (void)selectItem:(NSInteger)index;

- (void)addToContainer:(UIView *)container placeholder:(UIView *)placeholder;

@property (nonatomic, weak) id<BEColorListAdapterDelegate> delegate;
@property (nonatomic, readonly) UICollectionView *collectionView;

@end

#endif /* BEColorListAdapter_h */
