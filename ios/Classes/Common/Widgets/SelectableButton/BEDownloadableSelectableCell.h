//
//  BEDownloadableSelectableCell.h
//  BECommon
//
//  Created by qun on 2021/12/10.
//

#ifndef BEDownloadableSelectableCell_h
#define BEDownloadableSelectableCell_h

#import "BESelectableButton.h"
#import "BEDownloadView.h"

@interface BEDownloadableSelectableCell : UICollectionViewCell

@property (nonatomic, assign) BOOL useCellSelectedState;
@property (nonatomic, strong) id<BESelectableConfig> selectableConfig;

@property (nonatomic, readonly) BESelectableButton *selectableButton;
@property (nonatomic, readonly) BEDownloadView *downloadView;

@end

#endif /* BEDownloadableSelectableCell_h */
