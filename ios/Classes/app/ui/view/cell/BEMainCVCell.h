//
//  BEMainCVCell.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEMainCVCell_h
#define BEMainCVCell_h

#import <UIKit/UIKit.h>

@interface BEMainCVTitleCell : UICollectionViewCell

@end

// {zh} / 主页 CollectionView 功能项，用于展示每一个功能 {en} /Home CollectionView function items to show each function
@interface BEMainCVItemCell : UICollectionViewCell

- (void)updateTitle:(NSString *)title icon:(NSString *)icon;

@end

#endif /* BEMainCVCell_h */
