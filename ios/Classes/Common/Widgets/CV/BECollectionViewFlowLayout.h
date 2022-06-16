//
//  BECollectionViewFlowLayout.h
//  BECommon
//
//  Created by qun on 2021/12/16.
//

#ifndef BECenterCollectionViewFlowLayout_h
#define BECenterCollectionViewFlowLayout_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BECollectionViewLayoutMode) {
    BECollectionViewLayoutModeCenter,
    BECollectionViewLayoutModeExpand,
    BECollectionViewLayoutModeLeft,
};

@interface BECollectionViewFlowLayout : UICollectionViewFlowLayout

/// 列表排列模式，默认 BECollectionViewLayoutModeCenter
@property (nonatomic, assign) BECollectionViewLayoutMode mode;

@end

#endif /* BECenterCollectionViewFlowLayout_h */
