//
//  BEHeaderScrollViewDelegate.h
//  app
//
//  Created by qun on 2021/9/29.
//

#ifndef BEHeaderScrollViewDelegate_h
#define BEHeaderScrollViewDelegate_h

#import <UIKit/UIKit.h>

@interface BEHeaderScrollViewDelegate : NSObject <UICollectionViewDelegateFlowLayout>


/// header 的最小高度
@property (nonatomic, assign) NSInteger minHeaderHeight;

/// header 最大高度
@property (nonatomic, assign) NSInteger maxHeaderHeight;

/// header view
@property (nonatomic, strong) UIView *headerView;

/// 当前 heder view 的显示高度
@property (nonatomic) CGFloat headerHeight;

/// 滑动 view
@property (nonatomic, readonly) UICollectionView *collectionView;

- (CGFloat)offsetYWithSection:(NSInteger)section;
- (NSArray<NSIndexPath *> *)realVisiableItems:(NSArray<NSIndexPath *> *)items;

+ (void)swizzleMethods;

@end

#endif /* BEHeaderScrollViewDelegate_h */
