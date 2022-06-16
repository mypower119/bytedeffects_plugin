//
//  BEStickerView.h
//  BEEffect
//
//  Created by qun on 2021/10/22.
//

#ifndef BENewStickerView_h
#define BENewStickerView_h

#import "BEStickerItem.h"
#import "BETabStickerPickerView.h"
#import "BETitleBoardView.h"

@protocol BEStickerViewDelegate <BETabStickerPickerViewDelegate, BETitleBoardViewDelegate>

@end

@interface BEStickerView : UIView

@property (nonatomic, weak) id<BEStickerViewDelegate> delegate;

- (void)setGroups:(NSArray<BEStickerGroup *> *)groups;
//- (void)setSelectItem:(BEStickerItem *)item;
- (void)setSelectTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath;
- (void)refreshTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath;

@end

#endif /* BENewStickerView_h */
