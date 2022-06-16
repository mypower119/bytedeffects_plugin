//
//  BEIconItemCell.h
//  Effect
//
//  Created by qun on 2021/5/25.
//

#ifndef BEIconItemCell_h
#define BEIconItemCell_h

#import <UIKit/UIKit.h>
#import "BEDownloadView.h"

@interface BEIconItemCell : UICollectionViewCell

/// 是否使 CollectionViewCell 的 selected 状态与控件的状态一致，默认 NO
@property (nonatomic, assign) BOOL useCellSelectedState;
@property (nonatomic, assign) BOOL isSelected;

- (void)updateWithIcon:(NSString *)iconName;
- (void)setDownloadState:(BEDownloadViewState)state;
- (void)setDownloadProgress:(CGFloat)progress;

@end

#endif /* BEIconItemCell_h */
