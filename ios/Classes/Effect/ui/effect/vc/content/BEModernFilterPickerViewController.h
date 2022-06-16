// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <UIKit/UIKit.h>
#import "BEEffectDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BEModernFilterPickerViewController : UIViewController

@property(nonatomic, strong) BEEffectDataManager *dataManager;

- (void)setAllCellsUnSelected;
- (void)setSelectItem:(NSString *)filterPath;

@end

NS_ASSUME_NONNULL_END
