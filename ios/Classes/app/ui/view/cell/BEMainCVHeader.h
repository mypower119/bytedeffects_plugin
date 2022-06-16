//
//  BEMainCVHeader.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEMainCVHeader_h
#define BEMainCVHeader_h

#import <UIKit/UIKit.h>

// {zh} / 主页 CollectionView header，用于展示分组标题 {en} /Home CollectionView header for displaying group headers
@interface BEMainCVHeader : UICollectionReusableView

- (void)updateWithTitle:(NSString *)title;

@end

#endif /* BEMainCVHeader_h */
