//
//  BEBeautyEffectVC.m
//  Effect
//
//  Created by qun on 2021/5/23.
//

#import "BEBeautyEffectVC.h"
#import "BEBeautyEffectView.h"
#import "BEEffectDataManager.h"
#import "BEDeviceInfoHelper.h"
#import "BEFaceBeautyViewController.h"
#import "BEColorFaceBeautyViewController.h"
#import "Masonry.h"
#import "Effect.h"

static NSString *const EFFECT_TYPE_KEY = @"effect_type";
static NSString *const EFFECT_DEFAULT_KEY = @"effect_default";
static NSString *const EFFECT_PERFORMANCE_KEY = @"effect_performance";

@interface BEBeautyEffectVC () <BEBeautyEffectDelegate, BEFaceBeautyViewControllerDelegate>

@property (nonatomic, strong) BEBeautyEffectView *beautyBoardView;
@property (nonatomic, strong) NSArray *popoverConfigs;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, BEFaceBeautyViewController *> *vcMakeupOptionMap;
@property (nonatomic, strong) NSMutableSet<BEEffectItem *> *selectNodes;
@property (nonatomic, strong) BEEffectItem *currentItem;
@property (nonatomic, assign) BOOL currentIsFilter;
@property (nonatomic, strong) NSString *filterPath;
@property (nonatomic, assign) float filterIntensity;
@property (nonatomic, assign) BOOL closeFilter;

@end

@implementation BEBeautyEffectVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectNodes = [NSMutableSet set];
        _vcMakeupOptionMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeObserver];
}

#pragma mark - notification

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onItemSelect:)
                                                 name:BEEffectButtonItemSelectNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFilterSelect:)
                                                 name:BEEffectFilterDidChangeNotification
                                               object:nil];
    
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onFilterSelect:(NSNotification *)aNote {
    BEFilterItem *filter = aNote.userInfo[BEEffectNotificationUserInfoKey];
    self.filterPath = filter.filterPath;
    self.filterIntensity = [[self.dataManager defaultIntensity:BETypeFilter][0] floatValue];
    if (self.filterPath == nil || [self.filterPath isEqualToString:@""]) {
        self.filterIntensity = 0.f;
    }
    [self.beautyBoardView updateProgress:self.filterIntensity];
    
    [self.manager setFilterPath:filter.filterPath];
    [self.manager setFilterIntensity:self.filterIntensity];
    
    [self.tipManager showBubble:filter.tipTitle desc:filter.tipDesc duration:2];
}

- (void)onItemSelect:(NSNotification *)aNote {
    // if aNote is nil means that we call this method directly for reset/recover, so we should skip
    // item check and update all items' intensity
    BEEffectItem *item = nil;
    if (aNote != nil) {
        item = aNote.userInfo[BEEffectNotificationUserInfoKey];
        
        self.currentItem = item;
        [self.tipManager showBubble:item.tipTitle desc:@"" duration:2];
        [self.beautyBoardView updateProgressWithItem:item];
        if (item.children != nil) {
//            高度不一致时使用
//            [self.effectBaseView updateButtomMargin:BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_BOTTOM_MARGIN + BEF_BOARD_CONTENT_HEIGHT + BEF_SWITCH_TAB_HEIGHT + BEF_BOARD_BOTTOM_HEIGHT)+20+70 delay:0.1];
            [self.beautyBoardView showOption:[self be_makeupOptionVC:item] withAnimation:YES];
            return;
        }
    }
    
    // generate nodes from selectNodes
    NSMutableSet<NSString *> *set = [NSMutableSet set];
    NSMutableArray<BEEffectItem *> *items = [NSMutableArray array];
    for (BEEffectItem *item in self.selectNodes) {
        if (item.model != nil && ![set containsObject:item.model.path]) {
            [set addObject:item.model.path];
            [items addObject:item];
        }
    }
    // do updateComposerNode
    [self updateComposerNode:[items copy]];
    
    // do updateComposerNodeIntensity
    if (item != nil) {
        // close all children of item's parent
        if (item.ID == BETypeClose) {
            NSArray<BEEffectItem *> *allChildren = item.parent.allChildren;
            for (BEEffectItem *child in allChildren) {
                if (child.model != nil) {
                    [self updateComposerNodeIntensity:child];
                }
            }
        }
        // update current item's intensity
        if (item.model != nil) {
            [self updateComposerNodeIntensity:item];
        }
    } else {
        // update all items' intensity
        for (BEEffectItem *item in self.selectNodes) {
            [self updateComposerNodeIntensity:item];
        }
    }
    if (item.type == BETypeHairColor) {
        NSDictionary *param;
        param = [self.dataManager hairDyeFullColor:item.model.keyArray[0] ItemColor:item.selectedColor];
        
        if ([self.dataManager hairDyeFullIndex:item.model.keyArray[0]] == BEEffectPart_6) {
            [self.manager sethairColorByPart:BEEffectPart_1 r:[[NSString stringWithFormat:@"%@",[param objectForKey:@"r"]] floatValue] g:[[NSString stringWithFormat:@"%@",[param objectForKey:@"g"]] floatValue] b:[[NSString stringWithFormat:@"%@",[param objectForKey:@"b"]] floatValue] a:[[NSString stringWithFormat:@"%@",[param objectForKey:@"a"]] floatValue]];
            [self.manager sethairColorByPart:BEEffectPart_2 r:[[NSString stringWithFormat:@"%@",[param objectForKey:@"r"]] floatValue] g:[[NSString stringWithFormat:@"%@",[param objectForKey:@"g"]] floatValue] b:[[NSString stringWithFormat:@"%@",[param objectForKey:@"b"]] floatValue] a:[[NSString stringWithFormat:@"%@",[param objectForKey:@"a"]] floatValue]];
            [self.manager sethairColorByPart:BEEffectPart_3 r:[[NSString stringWithFormat:@"%@",[param objectForKey:@"r"]] floatValue] g:[[NSString stringWithFormat:@"%@",[param objectForKey:@"g"]] floatValue] b:[[NSString stringWithFormat:@"%@",[param objectForKey:@"b"]] floatValue] a:[[NSString stringWithFormat:@"%@",[param objectForKey:@"a"]] floatValue]];
            [self.manager sethairColorByPart:BEEffectPart_4 r:[[NSString stringWithFormat:@"%@",[param objectForKey:@"r"]] floatValue] g:[[NSString stringWithFormat:@"%@",[param objectForKey:@"g"]] floatValue] b:[[NSString stringWithFormat:@"%@",[param objectForKey:@"b"]] floatValue] a:[[NSString stringWithFormat:@"%@",[param objectForKey:@"a"]] floatValue]];
            
        }
        else {
            [self.manager sethairColorByPart:[self.dataManager hairDyeFullIndex:item.model.keyArray[0]] r:[[NSString stringWithFormat:@"%@",[param objectForKey:@"r"]] floatValue] g:[[NSString stringWithFormat:@"%@",[param objectForKey:@"g"]] floatValue] b:[[NSString stringWithFormat:@"%@",[param objectForKey:@"b"]] floatValue] a:[[NSString stringWithFormat:@"%@",[param objectForKey:@"a"]] floatValue]];
        }
    }
}

#pragma mark - public
- (void)resetToDefaultEffect:(NSArray<BEEffectItem *> *)items {
    [super resetToDefaultEffect:items];
    
    self.closeFilter = YES;
    self.filterPath = nil;
    
    [self.selectNodes removeAllObjects];
    [self.selectNodes addObjectsFromArray:items];
    
    if ([self.selectNodes.allObjects containsObject:self.currentItem]) {
        [self.beautyBoardView updateProgressWithItem:self.currentItem];
    } else {
        self.currentItem = nil;
        [self.beautyBoardView updateProgress:0.f];
    }
    
    if (_beautyBoardView) {
        [_beautyBoardView refreshUI];
    }
}

#pragma mark - BEBeautyEffectDelegate
- (void)progressDidChange:(BETextSliderView *)sender progress:(CGFloat)progress {
    float value = progress;
    int index = 0;
    
    if (self.currentIsFilter) {
        [self.manager setFilterIntensity:value];
        _filterIntensity = value;
        return;
    }
    
    BEEffectItem *item = self.currentItem;
    
    if (item.availableItem == nil) {
        return;
    }
    
    if (item.availableItem.model.keyArray == nil || item.availableItem.model.keyArray.count == 0) {
        NSLog(@"invalid key array");
        return;
    }
    
    item.availableItem.intensityArray[index] = [NSNumber numberWithFloat:value];
    [item updateState];
    
    [self updateComposerNodeIntensity:item.availableItem];
}

- (void)tabDidChanged:(BEEffectCategoryModel *)model {
    self.currentIsFilter = model.type == BETypeFilter;
    if (self.currentIsFilter) {
        [self.beautyBoardView updateProgress:self.filterIntensity];
    } else {
        self.currentItem = [self.dataManager buttonItem:model.type];
        [self.beautyBoardView updateProgressWithItem:self.currentItem];
    }
}

- (void)didClickOptionBack:(UIView *)sender {
    [self.beautyBoardView hideOption:YES];
}

- (void)refreshEffect {
    if (self.defaultEffectOn) {
        NSMutableArray *effectArr = [NSMutableArray new];
        for (BEEffectItem *item in self.selectNodes) {
            [effectArr addObject:item];
        }
        [self updateComposerNode:effectArr];
        for (BEEffectItem *item in effectArr) {
            [self updateComposerNodeIntensity:item];
        }
    } else {
        NSMutableArray *effectArr = [NSMutableArray new];
        for (BEEffectItem *item in self.selectNodes) {
            if (item.ID == BETypeMakeupLip) {
                [effectArr addObject:item];
            }
            if (item.ID == BETypeStyleHairColorA || item.ID == BETypeStyleHairColorB || item.ID == BETypeStyleHairColorC || item.ID == BETypeStyleHairColorD) {
                [effectArr addObject:item];
            }
            if (item.ID == BETypeMakeupHair) {
                [effectArr addObject:item];
            }
        }
        [self updateComposerNode:effectArr];
    }
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    [self showBottomView:self.beautyBoardView target:self.view];
}

- (void)baseView:(BEBaseBarView *)view didTapSetting:(UIView *)sender {
    [self showPopoverViewWithConfigs:self.popoverConfigs anchor:sender];
}

- (void)baseView:(BEBaseBarView *)view didTapReset:(UIView *)sender {
    [self BEEffectVCResetClean];
    [self resetToDefaultEffect:self.defaultEffectOn ? self.dataManager.buttonItemArrayWithDefaultIntensity : @[]];
}
- (void)BEEffectVCResetClean {
    for (int i=0; i<self.beautyBoardView.faceBeautyViewArray.count; i++) {
        BEFaceBeautyView *view = self.beautyBoardView.faceBeautyViewArray[i];
        [view cleanSelect];
    }
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.beautyBoardView.superview != nil) {
        [self hideBottomView:self.beautyBoardView showBoard:YES];
    }
}

#pragma mark - BEPopoverManagerDelegate
- (void)popover:(BEPopoverManager *)manager configDidChange:(NSObject *)config key:(NSString *)key {
    
    if (key == EFFECT_DEFAULT_KEY) {
        //  {zh} 默认美颜  {en} Default Beauty
        BESingleSwitchConfig *cf = (BESingleSwitchConfig *)config;
        self.defaultEffectOn = cf.isOn;
        [self refreshEffect];
    } else if (key == EFFECT_PERFORMANCE_KEY) {
        //  {zh} 性能  {en} Performance
        BESingleSwitchConfig *cf = (BESingleSwitchConfig *)config;
        [self showProfile:cf.isOn];
    }
}

#pragma mark - BEBoardBottomDelegate
- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    [self hideBottomView:self.beautyBoardView showBoard:YES];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    [self baseView:nil didTapRecord:nil];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapReset:(UIView *)sender {
    [self BEEffectVCResetClean];
    [self resetToDefaultEffect:self.defaultEffectOn ? self.dataManager.buttonItemArrayWithDefaultIntensity : @[]];
}

#pragma mark - BEFaceBeautyViewControllerDelegate
- (void)faceBeautyViewController:(BEFaceBeautyViewController *)vc didClickBack:(UIView *)sender {
    [self.effectBaseView updateButtomMargin:BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_BOTTOM_MARGIN + BEF_BOARD_CONTENT_HEIGHT + BEF_SWITCH_TAB_HEIGHT + BEF_BOARD_BOTTOM_HEIGHT)+20 delay:0];
    [self.beautyBoardView hideOption:YES];
}

#pragma mark - getter
- (BEBeautyEffectView *)beautyBoardView {
    if (_beautyBoardView == nil) {
        _beautyBoardView = [[BEBeautyEffectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN))];
        _beautyBoardView.titleType = self.effectConfig.title;
        if ([self.effectConfig.title isEqualToString:BEEffectAr_try_lipstick] || [self.effectConfig.title isEqualToString:BEEffectAr_hair_color]) {
            [_beautyBoardView hideTextSlider];
        }
        _beautyBoardView.delegate = self;
        
    }
    return _beautyBoardView;
}

- (NSArray *)popoverConfigs {
    if (_popoverConfigs) {
        return _popoverConfigs;
    }
    if ([self.effectConfig.title isEqualToString:BEEffectAr_try_lipstick] || [self.effectConfig.title isEqualToString:BEEffectAr_hair_color] ) {
        _popoverConfigs = @[
            [[BESingleSwitchConfig alloc] initWithTitle:@"default_effect" isOn:YES key:EFFECT_DEFAULT_KEY],
            [[BESingleSwitchConfig alloc]
             initWithTitle:@"profile" isOn:NO key:EFFECT_PERFORMANCE_KEY],
        ];
    }
    else {
        _popoverConfigs = @[
            [[BESingleSwitchConfig alloc]
             initWithTitle:@"profile" isOn:NO key:EFFECT_PERFORMANCE_KEY],
        ];
    }
    return _popoverConfigs;
}

- (BEFaceBeautyViewController *)be_makeupOptionVC:(BEEffectItem *)item {
    BEEffectNode type = item.ID;
    BEFaceBeautyViewController *vc = [self.vcMakeupOptionMap objectForKey:@(type)];
    if (vc == nil) {
        if (item.colorset != nil) {
            vc = [[BEColorFaceBeautyViewController alloc] init];
        } else {
            vc = [[BEFaceBeautyViewController alloc] init];
        }
        vc.delegate = self;
        [vc setSelectNodes:self.selectNodes dataManager:self.dataManager];
        vc.view.frame = CGRectMake(0, 1000, 0, 0);
        [self.vcMakeupOptionMap setObject:vc forKey:@(type)];
    }
    [vc setItem:item];
    return vc;
}

@end
