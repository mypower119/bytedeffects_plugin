//
//  BESelectableCell.h
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#ifndef BESelectableCell_h
#define BESelectableCell_h

#import "BESelectableButton.h"

@interface BESelectableCell : UICollectionViewCell

@property (nonatomic, assign) BOOL useCellSelectedState;
@property (nonatomic, strong) id<BESelectableConfig> selectableConfig;

@property (nonatomic, readonly) BESelectableButton *selectableButton;

@end

#endif /* BESelectableCell_h */
