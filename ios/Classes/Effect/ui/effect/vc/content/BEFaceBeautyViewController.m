//
//  BEFaceBeautyViewController.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "BEFaceBeautyViewController.h"
#import "BEColorFaceBeautyViewController.h"
#import "Masonry.h"

#import "BEEffectDataManager.h"
#import "UIResponder+BEAdd.h"
#import "Common.h"
#import "Effect.h"

@interface BEFaceBeautyViewController ()

@property (nonatomic, assign) NSMutableSet<BEEffectItem *> *selectNodes;
@property (nonatomic, strong) BEEffectDataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *faceBeautyViewArray;

@end


@implementation BEFaceBeautyViewController

#pragma mark - public
- (instancetype)init {
    self = [super init];
    if (self) {
        [self.beautyView removeFromSuperview];
        [self.view addSubview:self.beautyView];
        [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}

- (void)faceBeautyViewArray:(NSMutableArray *)viewArray{
    _faceBeautyViewArray = viewArray;
    [viewArray addObject:self.beautyView];
}

- (void)setItem:(BEEffectItem *)item {
    _item = item;
    self.beautyView.titleType = self.titleType;
    [self.beautyView setItem:item];
}

- (void)setSelectNodes:(NSMutableSet<BEEffectItem *> *)selectNodes dataManager:(BEEffectDataManager *)dataManager {
    self.selectNodes = selectNodes;
    self.dataManager = dataManager;
}

- (void)addToView:(UIView *)view {
    [[view be_topViewController] addChildViewController:self];
    [view addSubview:self.view];
}

- (void)removeFromView {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self.lTitle removeFromSuperview];
    [self.btnBack removeFromSuperview];
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    UIView *placeholderContainer = placeholderView.superview;
    if (placeholderContainer == nil) {
        return;
    }
    
    [placeholderContainer addSubview:self.lTitle];
    [placeholderContainer addSubview:self.btnBack];
    
    [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(placeholderView);
    }];
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.lTitle);
        make.width.mas_equalTo(self.btnBack.mas_height);
    }];
    
    self.lTitle.text = self.item.title;
    
    [self showPlaceholder:NO];
}

- (void)setRemoveTitlePlaceholderView:(UIView *)removeTitlePlaceholderView {
    [self showPlaceholder:NO];
}

- (void)showPlaceholder:(BOOL)show {
    self.lTitle.alpha = show ? 1 : 0;
    self.btnBack.alpha = show ? 1 : 0;
}


#pragma mark - BEFaceBeautyViewDelegate
- (void)onItemClean:(BOOL)isHidden {
    [self onItemCleanColorListAdapter:isHidden];
}
- (void)onItemCleanColorListAdapter:(BOOL)isHidden {
    
}
- (void)onItemSelect:(BEEffectItem *)item {
    [self refreshWithNewItem:item];
    
    if ([self.titleType isEqualToString:BEEffectAr_try_lipstick]) {
        for (int i=0; i<self.faceBeautyViewArray.count; i++) {
            BEFaceBeautyView *view = self.faceBeautyViewArray[i];
            if (self.beautyView != view) {
                [view cleanSelect];
            }
        }
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEEffectButtonItemSelectNotification
     object:nil
     userInfo:@{BEEffectNotificationUserInfoKey: item}];
}

- (void)refreshWithNewItem:(BEEffectItem *)item {
    if (item.ID == BETypeClose) {
        // close button, remove all the children of item's parent
        [self be_removeOrAddItem:self.selectNodes item:item.parent add:NO];
        [self.beautyView resetSelect];
        self.item.selectChild = nil;
    } else {
        BOOL effectItemBool = NO;
        BEEffectItem *effectItemOld = nil;
        if ([self.titleType isEqualToString:BEEffectAr_try_lipstick] || [self.titleType isEqualToString:BEEffectAr_hair_color]) {
            for (BEEffectItem *effectItem in self.selectNodes) {
                if (effectItem.ID == item.ID) {
                    effectItemBool = YES;
                    effectItemOld = effectItem;
                }
            }
        }
        if (effectItemBool == YES) {
            [self be_removeOrAddItem:self.selectNodes item:effectItemOld add:NO];
        }
        if (![self.selectNodes containsObject:item]) {
            NSMutableArray *itemIntensity = nil;
            // remove it's brother if not enable multi select
            if (!self.item.enableMultiSelect) {
                if (self.item.selectChild != nil) {
                    BEEffectItem *itemToRemove = self.item.selectChild;
                    
                    // do reuse intensity from it's brother if should
                    if (self.item.reuseChildrenIntensity) {
                        itemIntensity = itemToRemove.intensityArray;
                    }
                    
                    [self be_removeOrAddItem:self.selectNodes item:itemToRemove add:NO];
                }
            }
            self.item.selectChild = item;
            if (item.model != nil) {
                if (itemIntensity == nil) {
                    // if has default intensity, set it to item
                    itemIntensity = [self.dataManager defaultIntensity:item.ID];
                }
                if (itemIntensity != nil && item.intensityArray != nil) {
                    for (int i = 0; i < itemIntensity.count && i < item.intensityArray.count; i++) {
                        item.intensityArray[i] = itemIntensity[i];
                    }
                }
                // feature button, add the specific item
                [self be_removeOrAddItem:self.selectNodes item:item add:YES];
            }
        }
        self.item.selectChild = item;
    }
    // reset ui state
    [self.beautyView resetSelect];
}

#pragma mark - private
- (void)be_removeOrAddItem:(NSMutableSet *)set item:(BEEffectItem *)item add:(BOOL)add {
    if (add) {
        if (item.availableItem != nil) {
            [set addObject:item];
        }
        [item updateState];
    } else {
        // reset intensity
        [item reset];
        // update ui state if can
        [item updateState];
        // remove from selectNodes
        [set removeObject:item];
        // do the same in children
        if (item.children) {
            for (BEEffectItem *i in item.children) {
                [self be_removeOrAddItem:self.selectNodes item:i add:add];
            }
        }
    }
}
- (void)didClickOptionBack:(UIView *)sender {
    [self.delegate faceBeautyViewController:self didClickBack:sender];
}

#pragma mark - getter
- (BEFaceBeautyView *)beautyView {
    if (!_beautyView) {
        _beautyView = [BEFaceBeautyView new];
        _beautyView.delegate = self;
    }
    return _beautyView;
}

- (UILabel *)lTitle {
    if (_lTitle == nil) {
        _lTitle = [UILabel new];
        _lTitle.textColor = [UIColor whiteColor];
        _lTitle.font = [UIFont systemFontOfSize:15];
        _lTitle.textAlignment = NSTextAlignmentCenter;
        _lTitle.alpha = 0;
    }
    return _lTitle;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [UIButton new];
        [_btnBack setImage:[UIImage imageNamed:@"ic_arrow_left"] forState:UIControlStateNormal];
        _btnBack.backgroundColor = [UIColor clearColor];
        _btnBack.alpha = 0;
        _btnBack.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [_btnBack addTarget:self action:@selector(didClickOptionBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}
@end
