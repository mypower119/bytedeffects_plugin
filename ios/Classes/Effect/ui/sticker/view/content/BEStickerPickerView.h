//
//  BEStickerPickerView.h
//  BEEffect
//
//  Created by qun on 2021/10/22.
//

#ifndef BENewStickerPickerView_h
#define BENewStickerPickerView_h

#import <UIKit/UIKit.h>
#import "BEStickerItem.h"

@class BEStickerPickerView;
@protocol BEStickerPickerViewDelegate <NSObject>

- (BOOL)pickerView:(BEStickerPickerView *)pickerView willSelectItem:(BEStickerItem *)item atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BEStickerPickerView : UIView

@property (nonatomic, weak) id<BEStickerPickerViewDelegate> delegate;

@property (nonatomic, strong) BEStickerGroup *group;

- (void)setItems:(NSArray<BEStickerItem *> *)items;
- (void)setSelectItem:(BEStickerItem *)item;
- (void)setSelectIndex:(NSInteger)selectIndex;
- (void)refreshIndexPath:(NSIndexPath *)indexPath;

@end

#endif /* BENewStickerPickerView_h */
