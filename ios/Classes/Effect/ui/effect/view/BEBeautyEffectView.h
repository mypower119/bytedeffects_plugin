//
//  BEBeautyEffectView.h
//  Effect
//
//  Created by qun on 2021/5/23.
//

#ifndef BEBeautyEffectView_h
#define BEBeautyEffectView_h

#import <UIKit/UIKit.h>
#import "BEEffectItem.h"
#import "BEEffectDataManager.h"
#import "BETextSliderView.h"
#import "BEBoardBottomView.h"
#import "BEFaceBeautyViewController.h"

@protocol BEBeautyEffectDelegate <BETextSliderViewDelegate, BEBoardBottomViewDelegate>

- (NSMutableSet<BEEffectItem *> *)selectNodes;
- (BEEffectDataManager *)dataManager;
- (void)tabDidChanged:(BEEffectCategoryModel *)model;
- (void)didClickOptionBack:(UIView *)sender;
- (NSString *)filterPath;
- (BOOL)closeFilter;
- (void)setCloseFilter:(BOOL)closeFilter;

@end

@interface BEBeautyEffectView : UIView

@property (nonatomic, weak) id<BEBeautyEffectDelegate> delegate;
@property (nonatomic, strong) NSString *titleType;
@property (nonatomic, strong) NSMutableArray *faceBeautyViewArray;

- (void)refreshUI;
- (void)updateProgress:(float)progress;
- (void)updateProgressWithItem:(BEEffectItem *)item;
- (void)showOption:(BEFaceBeautyViewController *)optionVC withAnimation:(BOOL)animation;
- (void)hideOption:(BOOL)animation;
- (void)hideTextSlider;

@end

#endif /* BEBeautyEffectView_h */
