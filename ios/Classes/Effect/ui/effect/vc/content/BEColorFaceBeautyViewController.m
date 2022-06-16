//
//  BEColorFaceBeautyViewController.m
//  BEEffect
//
//  Created by qun on 2021/8/30.
//

#import "BEColorFaceBeautyViewController.h"
#import "BEColorListAdapter.h"
#import "Masonry.h"
#import "Effect.h"

@interface BEColorFaceBeautyViewController () <BEColorListAdapterDelegate>

@property (nonatomic, strong) NSArray<BEEffectColorItem *> *colorset;
@property (nonatomic, strong) BEColorListAdapter *colorListAdapter;
@property (nonatomic, weak) BEEffectItem *lastItem;

@end

@implementation BEColorFaceBeautyViewController

- (void)setItem:(BEEffectItem *)item {
    [super setItem:item];
    _colorset = item.colorset;
    _colorListAdapter = [[BEColorListAdapter alloc] initWithColorset:_colorset];
    _colorListAdapter.delegate = self;
}

#pragma mark - public
- (void)setPlaceholderView:(UIView *)placeholderView {
    [super setPlaceholderView:placeholderView];
    
    UIView *placeholderContainer = placeholderView.superview;
    if (placeholderContainer == nil) {
        return;
    }
    
    [self.colorListAdapter addToContainer:placeholderContainer placeholder:placeholderView];
    
    if (self.item.selectChild == nil || self.item.selectChild.ID == BETypeClose) {
        self.colorListAdapter.collectionView.hidden = YES;
        self.lTitle.hidden = NO;
    } else {
        self.colorListAdapter.collectionView.hidden = NO;
        self.lTitle.hidden = YES;
        BEEffectItem *item = self.item.selectChild;
        [self.colorListAdapter refreshWith:item.colorset];
        [self.colorListAdapter selectItem:[item.colorset indexOfObject:item.selectedColor]];
    }
}

- (void)setRemoveTitlePlaceholderView:(UIView *)removeTitlePlaceholderView {
    [super setRemoveTitlePlaceholderView:removeTitlePlaceholderView];
    
    UIView *placeholderContainer = removeTitlePlaceholderView.superview;
    if (placeholderContainer == nil) {
        return;
    }
    
    [self.colorListAdapter addToContainer:placeholderContainer placeholder:removeTitlePlaceholderView];
    self.colorListAdapter.collectionView.hidden = NO;
    BEEffectItem *item = self.item;
    [self.colorListAdapter refreshWith:item.colorset];
    [self.colorListAdapter selectItem:[item.colorset indexOfObject:item.selectedColor]];
}

- (void)removeFromView {
    [super removeFromView];
    [self.colorListAdapter.collectionView removeFromSuperview];
}

- (void)showPlaceholder:(BOOL)show {
    [super showPlaceholder:show];
    self.colorListAdapter.collectionView.alpha = show ? 1 : 0;
}

- (void)BEEffectVCResetClean {
    [super BEEffectVCResetClean];
}


#pragma mark - BEFaceBeautyViewDelegate
- (void)onItemCleanColorListAdapter:(BOOL)isHidden {
    BEEffectItem *item = self.item.selectChild;
    if (item == nil) {
        [self.colorListAdapter refreshWith:nil];
    }
    self.colorListAdapter.collectionView.hidden = isHidden;
}
- (void)refreshWithNewItem:(BEEffectItem *)item {
    BEEffectItem *oldItem;
    if ([self.titleType isEqualToString:BEEffectAr_hair_color]) {
        oldItem = item;
    }
    else {
        oldItem = self.item.selectChild;
    }
    BEEffectColorItem *oldColor = oldItem == nil ? nil : oldItem.selectedColor;
    [super refreshWithNewItem:item];
    if (item.ID == BETypeClose || item.colorset == nil) {
        //  {zh} 关闭按钮/不能选颜色的小项，显示标题  {en} Close button/can not select the color of the small items, display the title
        self.lTitle.hidden = NO;
        self.colorListAdapter.collectionView.hidden = YES;
    } else {
        //  {zh} 复用其他按钮的颜色值  {en} Multiplexing the color values of other buttons
        if (oldColor != nil) {
            [self be_updateItemColor:item withIndex:[item.colorset indexOfObject:oldColor]];
        }
        if (item.selectedColor == nil) {
            //  {zh} 没有选择颜色的时候，默认选择 0  {en} When no color is selected, 0 is selected by default
            [self colorListAdapter:nil didSelectedAt:0];
        }
        
        //  {zh} 其他按钮，显示颜色  {en} Other buttons, display color
        self.lTitle.hidden = YES;
        self.colorListAdapter.collectionView.hidden = NO;
        [self.colorListAdapter refreshWith:item.colorset];
        [self.colorListAdapter selectItem:[item.colorset indexOfObject:item.selectedColor]];
    }
}

#pragma mark - BEColorListAdapterDelegate
- (void)colorListAdapter:(BEColorListAdapter *)adapter didSelectedAt:(NSInteger)index {
    BEEffectItem *selectItem = self.item.selectChild;
    if (selectItem == nil) {
        return;
    }
    [self be_updateItemColor:selectItem withIndex:index];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BEEffectButtonItemSelectNotification
     object:nil
     userInfo:@{BEEffectNotificationUserInfoKey: selectItem}];
}

#pragma mark - private
- (void)be_updateItemColor:(BEEffectItem *)selectItem withIndex:(NSInteger)index {
    if (index < 0 || index >= selectItem.colorset.count) {
        NSLog(@"invalid index %ld in %@", (long)index, selectItem.colorset);
        return;
    }
    
    BEEffectColorItem *color = selectItem.colorset[index];
    
    BEComposerNodeModel *model = selectItem.model;
    if (model == nil || model.keyArray.count != selectItem.intensityArray.count) {
        NSLog(@"invalid model and intensity array");
        return;
    }
    
    for (int i = 0; i < model.keyArray.count; ++i) {
        if ([model.keyArray[i] isEqualToString:@"R"]) {
            selectItem.intensityArray[i] = [NSNumber numberWithFloat:color.red];
        } else if ([model.keyArray[i] isEqualToString:@"G"]) {
            selectItem.intensityArray[i] = [NSNumber numberWithFloat:color.green];
        } else if ([model.keyArray[i] isEqualToString:@"B"]) {
            selectItem.intensityArray[i] = [NSNumber numberWithFloat:color.blue];
        }
    }
    selectItem.selectedColor = color;
}

@end
