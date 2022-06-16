//
//  BEFaceBeautyViewController.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEEffectItem.h"
#import "BEEffectDataManager.h"
#import "BEFaceBeautyView.h"

@class BEFaceBeautyViewController;
@protocol BEFaceBeautyViewControllerDelegate <NSObject>

- (void)faceBeautyViewController:(BEFaceBeautyViewController *)vc didClickBack:(UIView *)sender;

@end

@interface BEFaceBeautyViewController : UIViewController <BEFaceBeautyViewDelegate>

@property (nonatomic, weak) id<BEFaceBeautyViewControllerDelegate> delegate;
@property (nonatomic, weak) UIView *placeholderView;
@property (nonatomic, weak) UIView *removeTitlePlaceholderView;
@property (nonatomic, strong) BEFaceBeautyView *beautyView;
// protected
@property (nonatomic, assign) BEEffectItem *item;
@property (nonatomic, strong) UILabel *lTitle;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) NSString *titleType;

- (void)addToView:(UIView *)view;
- (void)removeFromView;

- (void)showPlaceholder:(BOOL)show;

- (void)showTitlePlaceholder:(BOOL)show;

- (void)faceBeautyViewArray:(NSMutableArray *)viewArray;

- (void)setItem:(BEEffectItem *)item;

- (void)setSelectNodes:(NSMutableSet<BEEffectItem *> *)selectNodes dataManager:(BEEffectDataManager *)dataManager;

// protected
- (void)refreshWithNewItem:(BEEffectItem *)item;
- (void)BEEffectVCResetClean;
@end
