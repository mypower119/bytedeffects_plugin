// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <UIKit/UIKit.h>
@class BEFilterItem, BEEffectItem, BEModernFilterPickerView;

@protocol BEModernFilterPickerViewDelegate <NSObject>

- (void)filterPicker:(BEModernFilterPickerView *)pickerView didSelectFilter:(BEFilterItem *)filter;

@end

@interface BEModernFilterPickerView : UIView

@property (nonatomic, weak) id<BEModernFilterPickerViewDelegate> delegate;

- (void)refreshWithFilters:(NSArray <BEFilterItem *>*)filters;
- (void)setAllCellsUnSelected;
- (void)setSelectItem:(NSString *)filterPath;

@end
