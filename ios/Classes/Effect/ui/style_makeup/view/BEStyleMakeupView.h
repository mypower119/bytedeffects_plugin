//
//  BEStyleMakeupView.h
//  Effect
//
//  Created by qun on 2021/5/26.
//

#ifndef BEStyleMakeupView_h
#define BEStyleMakeupView_h

#import "BEItemPickerView.h"
#import "BETitleBoardView.h"
#import "BETextSwitchView.h"
#import "BETextSliderView.h"

@protocol BEStyleMakeupViewDelegate <BEItemPickerViewDelegate, BETitleBoardViewDelegate, BETextSliderViewDelegate, BETextSwitchItemViewDelegate>

@end

@interface BEStyleMakeupView : UIView

@property (nonatomic, weak) id<BEStyleMakeupViewDelegate> delegate;
@property (nonatomic, strong) BEEffectItem *item;
@property (nonatomic, strong) NSArray<BETextSwitchItem *> *switchTextItems;

- (void)updateSlideProgress:(float)progress;
- (void)setSelectItem:(BEEffectItem *)item;

@end

#endif /* BEStyleMakeupView_h */
