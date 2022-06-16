//
//  BETabStickerPickerView.h
//  BEEffect
//
//  Created by qun on 2021/10/22.
//

#ifndef BENewTabStickerPickerView_h
#define BENewTabStickerPickerView_h

#import "BEStickerPickerView.h"

@class BETabStickerPickerView;
@protocol BETabStickerPickerViewDelegate <NSObject>

- (BOOL)tabPickerView:(BETabStickerPickerView *)pickerView willSelectItem:(BEStickerItem *)item atTabIndex:(NSIndexPath *)tabIndex withContentIndex:(NSIndexPath *)contentIndex;

@end

@interface BETabStickerPickerView : UIView

@property (nonatomic, weak) id<BETabStickerPickerViewDelegate> delegate;

- (void)setGroups:(NSArray<BEStickerGroup *> *)groups;
- (void)setSelectItem:(BEStickerItem *)item;
- (void)setSelectTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath;
- (void)refreshTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath;

@end

#endif /* BENewTabStickerPickerView_h */
