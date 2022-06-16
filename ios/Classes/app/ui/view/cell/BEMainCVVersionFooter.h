//
//  BEMainCVVersionFooter.h
//  app
//
//  Created by qun on 2021/6/15.
//

#ifndef BEMainCVVersionFooter_h
#define BEMainCVVersionFooter_h

#import <UIKit/UIKit.h>

// {zh} / 主页 CollectionView footer，用于展示版本信息 {en} /Home CollectionView footer for displaying version information
@interface BEMainCVVersionFooter : UICollectionReusableView

- (void)updateWithVersion:(NSString *)version;

@end

#endif /* BEMainCVVersionFooter_h */
