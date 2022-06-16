//
//  BEItemPickerView.h
//  Effect
//
//  Created by qun on 2021/5/27.
//

#ifndef BEItemPickerView_h
#define BEItemPickerView_h

#import <UIKit/UIKit.h>
#import "BEEffectItem.h"

@class BEItemPickerView;
@protocol BEItemPickerViewDelegate <NSObject>

- (void)pickerView:(BEItemPickerView *)view didSelectItem:(BEEffectItem *)item;

@end

@interface BEItemPickerView : UIView

@property (nonatomic, weak) id<BEItemPickerViewDelegate> delegate;

- (void)setItems:(NSArray<BEEffectItem *> *)items;
- (void)setSelectItem:(BEEffectItem *)selectItem;

@end

#endif /* BEItemPickerView_h */
