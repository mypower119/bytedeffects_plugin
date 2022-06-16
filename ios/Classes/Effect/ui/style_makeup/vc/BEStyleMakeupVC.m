//
//  BEStyleMakeupVC.m
//  Effect
//
//  Created by qun on 2021/5/25.
//

#import "BEStyleMakeupVC.h"
#import "BEStyleMakeupView.h"
#import "BEDeviceInfoHelper.h"
#import "CommonSize.h"

@interface BEStyleMakeupVC () <BEStyleMakeupViewDelegate>

@property (nonatomic, strong) BEStyleMakeupView *styleMakeupView;
@property (nonatomic, assign) NSInteger textSwitchIndex;
@property (nonatomic, strong) BEEffectItem *currentItem;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *items;

@end

@implementation BEStyleMakeupVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)refreshEffect {
    [super refreshEffect];
    
    if (self.currentItem != nil) {
        [self.manager appendComposerNodes:@[self.currentItem.model.path] withTags:@[self.currentItem.model.tag]];
        
        [self updateComposerNodeIntensity:self.currentItem];
    }
}

- (void)resetToDefaultEffect:(NSArray<BEEffectItem *> *)items {
    [super resetToDefaultEffect:items];
    
    self.currentItem = nil;
    [self.styleMakeupView setSelectItem:nil];
    [self.styleMakeupView updateSlideProgress:0.f];
}

#pragma mark - BEItemPickerViewDelegate
- (void)pickerView:(BEItemPickerView *)view didSelectItem:(BEEffectItem *)item {
    [self.tipManager showBubble:item.tipTitle desc:item.tipDesc duration:2];
    
    if (self.currentItem == item) {
        return;
    }
    
    BEEffectItem *oldItem = self.currentItem;

    if (oldItem != nil && oldItem.model != nil) {
        [self lockSDK];
        [self.manager removeComposerNodes:@[oldItem.model.path]];
        [self unlockSDK];
    }
//
//    [oldItem reset];
//
    if (item.model == nil) {
        //  {zh} 关闭按钮直接重置为默认美颜并归零滑杆  {en} Close button directly reset to default beauty and zero slider
        [self.styleMakeupView updateSlideProgress:0.f];
        self.currentItem = nil;
        return;
    }
    self.currentItem = item;
    
    //  {zh} 更新默认强度  {en} Update default strength
    float intensityArrayIndex = self.currentItem.intensityArray[1].floatValue;
    if (intensityArrayIndex == 0) {
        item.intensityArray = [self.dataManager defaultIntensity:item.ID];
    }
    
    //  {zh} 更新滑杆  {en} Update slider
    [self.styleMakeupView updateSlideProgress:[self.currentItem.intensityArray[self.textSwitchIndex] floatValue]];
    
    //  {zh} SDK 调用，考虑到有可能有默认美颜，所以此处不能用 set，要用 append  {en} SDK call, considering that there may be a default beauty, so you can't use set here, use append
    [self lockSDK];
    [self.manager appendComposerNodes:@[item.model.path] withTags:@[item.model.tag]];
    [self unlockSDK];
    [self updateComposerNodeIntensity:item];
}

#pragma mark - BEBoardBottomDelegate
- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    [self hideBottomView:self.styleMakeupView showBoard:YES];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    [self baseView:nil didTapRecord:nil];
}

#pragma mark - BETextSliderViewDelegate
- (void)progressDidChange:(BETextSliderView *)sender progress:(CGFloat)progress {
    if (self.currentItem == nil) {
        return;
    }
    
    if (self.textSwitchIndex >= self.currentItem.model.keyArray.count || self.textSwitchIndex < 0) {
        NSLog(@"invalid text switch index: %ld", self.textSwitchIndex);
        return;
    }
    self.currentItem.intensityArray[self.textSwitchIndex] = [NSNumber numberWithFloat:progress];
    [self updateComposerNodeIntensity:self.currentItem];
}

#pragma mark - BETextSwitchItemViewDelegate
- (void)textSwitchItemView:(BETextSwitchItemView *)view didSelect:(BETextSwitchItem *)item {
    self.textSwitchIndex = [self.dataManager.styleMakeupSwitchItems indexOfObject:item];
    
    [self.styleMakeupView updateSlideProgress:[self.currentItem.intensityArray[self.textSwitchIndex] floatValue]];
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    [self showBottomView:self.styleMakeupView target:self.view];
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.styleMakeupView.superview != nil) {
        [self hideBottomView:self.styleMakeupView showBoard:YES];
    }
#pragma mark 动态调整面板高度 测试
//    static BOOL expand;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        expand = NO;
//    });
//    expand = !expand;
//    [self updateBottomView:self.styleMakeupView withSize:CGSizeMake(0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN + (expand ? BEF_SLIDE_HEIGHT * 2 : 0)))];
//    [self.effectBaseView updateButtomMargin:BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN + (expand ? BEF_SLIDE_HEIGHT * 2 : 0))];
}

#pragma mark - getter
- (BEStyleMakeupView *)styleMakeupView {
    if (_styleMakeupView) {
        return _styleMakeupView;
    }
    
    _styleMakeupView = [[BEStyleMakeupView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN))];
    _styleMakeupView.delegate = self;
    _styleMakeupView.item = [self.dataManager buttonItem:BETypeStyleMakeup];
    _styleMakeupView.switchTextItems = self.dataManager.styleMakeupSwitchItems;
    return _styleMakeupView;
}

@end
