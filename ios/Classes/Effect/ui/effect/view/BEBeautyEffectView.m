//
//  BEBeautyEffectView.m
//  Effect
//
//  Created by qun on 2021/5/23.
//

#import "BEBeautyEffectView.h"
#import "BECategoryView.h"
#import "BEFilterViewCell.h"
#import "BEBeautyFaceCell.h"
#import "BEBeautyHairColorCell.h"
#import "UICollectionViewCell+BEAdd.h"
#import "BEBoardBottomView.h"
#import "BEDeviceInfoHelper.h"
#import "Masonry.h"
#import "BEColorFaceBeautyViewController.h"
#import "UIView+BEAdd.h"
#import "Common.h"
#import "Effect.h"

@interface BEBeautyEffectView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BEEffectSwitchTabViewDelegate>

@property (nonatomic, strong) BETextSliderView *textSlider;
@property (nonatomic, strong) BECategoryView *categoryView;
@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) BEBoardBottomView *boardBottomView;
@property (nonatomic, strong) UIView *vBoard;
@property (nonatomic, strong) BEFaceBeautyViewController *vcMakeupOption;

@property (nonatomic, strong) NSArray<BEEffectCategoryModel *> *categories;

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, assign) BOOL textSliderHidden;

@end

@implementation BEBeautyEffectView

- (NSMutableArray *)faceBeautyViewArray {
    if (_faceBeautyViewArray == nil) {
        _faceBeautyViewArray = [[NSMutableArray alloc] init];
    }
    return _faceBeautyViewArray;
}
- (void)hideTextSlider {
    self.textSlider.hidden = YES;
    self.textSliderHidden = YES;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat BOTTOM_HEIGHT = BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_HEIGHT);
        CGFloat BOTTOM_BOTTOM_MARGIN = BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_BOTTOM_MARGIN);
        CGFloat TOP_HEIGHT = BEF_DESIGN_SIZE(BEF_SWITCH_TAB_HEIGHT);
        CGFloat TEXT_SLIDE_BOTTOM_MARGIN = BEF_DESIGN_SIZE(BEF_SLIDE_BOTTOM_MARGIN);
        CGFloat TEXT_SLIDE_HEIGHT = BEF_DESIGN_SIZE(BEF_SLIDE_HEIGHT);
        
        [self addSubview:self.textSlider];
        [self addSubview:self.vBoard];
        [self addSubview:self.categoryView];
        [self addSubview:self.boardBottomView];
        
        _colorView = [[UIView alloc] init];
        _colorView.hidden = YES;
        [self addSubview:_colorView];
        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(70);
            make.right.mas_equalTo(-70);
            make.top.mas_equalTo(25);
            make.height.mas_equalTo(50);
        }];
        
        [self.textSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.height.mas_equalTo(TEXT_SLIDE_HEIGHT);
            make.leading.equalTo(self).offset(50);
            make.trailing.equalTo(self).offset(-50);
            make.centerX.equalTo(self);
        }];
        
        [self.boardBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(BOTTOM_HEIGHT);
            make.bottom.equalTo(self).offset(-BOTTOM_BOTTOM_MARGIN);
        }];
        [self.vBoard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(self.frame.size.height+100);
            make.top.equalTo(self.textSlider.mas_bottom).offset(TEXT_SLIDE_BOTTOM_MARGIN);
        }];
        [self.categoryView.switchTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(TOP_HEIGHT);
        }];
        
        [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.boardBottomView.mas_top);
            make.top.equalTo(self.vBoard);
        }];

        [self.vBoard be_roundRect:UIRectCornerTopLeft|UIRectCornerTopRight withSize:CGSizeMake(BEF_DESIGN_SIZE(7), BEF_DESIGN_SIZE(7))];
    }
    return self;
}

#pragma mark - public

- (void)refreshUI {
    if ([self.titleType isEqualToString:BEEffectAr_hair_color]) {
       
    }
    else {
        [self.cv reloadData];
    }
    //  {zh} 两种逻辑，1. 当二级菜单打开，并且正在展示，动画消失  {en} Two kinds of logic, 1. When the secondary menu is opened and is being displayed, the animation disappears
    //  {zh} 2. 当二级菜单打开，但整个面板关闭，直接消失  {en} 2. When the secondary menu is opened, but the entire panel is closed, it disappears directly
    if (_vcMakeupOption && [_vcMakeupOption parentViewController]) {
        [self hideOption:self.superview != nil];
    }
}

- (void)setDelegate:(id<BEBeautyEffectDelegate>)delegate {
    _delegate = delegate;
    self.textSlider.delegate = delegate;
    self.boardBottomView.delegate = delegate;
    
    if ([self.titleType isEqualToString:BEEffectAr_try_lipstick]) {
        self.categories = self.delegate.dataManager.effectCategoryModelLipstickArray;
    } else if ([self.titleType isEqualToString:BEEffectAr_hair_color]) {
        self.categories = self.delegate.dataManager.effectCategoryModelHairColorArray;
    } else {
        self.categories = self.delegate.dataManager.effectCategoryModelArray;
    }
    
    NSMutableArray<NSString *> *titles = [NSMutableArray array];
    for (BEEffectCategoryModel *model in self.categories) {
        [titles addObject:model.title];
    }
    [self.categoryView setIndicators:titles];
    [self.cv reloadData];
}

- (void)setTitleType:(NSString *)titleType {
    _titleType = titleType;
}

- (void)updateProgress:(float)progress {
    if (self.textSliderHidden) {
        return;
    }
    self.textSlider.hidden = NO;
    self.textSlider.progress = progress;
}

- (void)updateProgressWithItem:(BEEffectItem *)item {
    if (self.textSliderHidden) {
        return;
    }
    NSArray<NSNumber *> *intensityArray = item.validIntensity;
    
    self.textSlider.negativeable = item.availableItem.enableNegative;
    
    if (intensityArray == nil) {
        self.textSlider.progress = 0.f;
    }
    
    if (intensityArray.count >= 1) {
        self.textSlider.progress = [intensityArray[0] floatValue];
    }
    
    self.textSlider.hidden = !item.showIntensityBar;
}

- (void)showOption:(BEFaceBeautyViewController *)optionVC withAnimation:(BOOL)animation {

    optionVC.view.alpha = 0;
    self.vcMakeupOption = optionVC;
    self.categoryView.switchTabView.alpha = 0;
    self.vcMakeupOption.beautyView.alpha = 0;
    self.vcMakeupOption.view.alpha = 0;
    [self.vcMakeupOption showPlaceholder:NO];
    optionVC.placeholderView = self.categoryView.switchTabView;
    [optionVC addToView:self];

    if (animation) {
        
        [optionVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cv.mas_bottom);
            make.left.right.equalTo(self.cv);
            make.height.equalTo(self.cv);
        }];
        [optionVC showPlaceholder:NO];
        [optionVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.cv);
        }];
//        [self layoutIfNeeded];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.categoryView.switchTabView.alpha = 0;
            self.cv.alpha = 0;
            //    高度不一致时使用
//            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN+70), [UIScreen mainScreen].bounds.size.width, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN+70));
            //    高度一致使用
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN), [UIScreen mainScreen].bounds.size.width, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN));
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.vcMakeupOption.beautyView.alpha = 1;
            self.vcMakeupOption.view.alpha = 1;
            [self.vcMakeupOption showPlaceholder:YES];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [optionVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.cv);
        }];
        [optionVC showPlaceholder:YES];
    }
}

- (void)hideOption:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.vcMakeupOption showPlaceholder:NO];
            [self.vcMakeupOption.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom);
                make.left.right.equalTo(self.cv);
            }];
            self.vcMakeupOption.view.alpha = 0;
            self.vcMakeupOption.beautyView.alpha = 0;
            self.categoryView.switchTabView.alpha = 1;
            self.cv.alpha = 1;
            [self.vcMakeupOption removeFromView];
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN), [UIScreen mainScreen].bounds.size.width, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_SLIDE_HEIGHT + BEF_SLIDE_BOTTOM_MARGIN));
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.vcMakeupOption showPlaceholder:NO];
        [self.vcMakeupOption removeFromView];
        self.categoryView.switchTabView.alpha = 1;
        self.cv.alpha = 1;
    }
}

//  {zh} BEBeautyEffectView 本身不拦截事件，将其透传到自己的下一层去  {en} BEBeautyEffectView itself does not intercept events, passing them through to its next level
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (v == self) {
        return nil;
    }
    return v;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.vBoard be_roundRect:UIRectCornerTopLeft|UIRectCornerTopRight withSize:CGSizeMake(BEF_DESIGN_SIZE(7), BEF_DESIGN_SIZE(7))];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEEffectCategoryModel *model = self.categories[indexPath.row];
    UICollectionViewCell *cell = nil;
    if (model.type == BETypeFilter) {
        BEEffecFiltersCollectionViewCell *filterCell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEEffecFiltersCollectionViewCell be_identifier] forIndexPath:indexPath];
        [filterCell.vc setDataManager:self.delegate.dataManager];
        if (self.delegate.closeFilter) {
            [filterCell.vc setAllCellsUnSelected];
            self.delegate.closeFilter = NO;
        } else {
            [filterCell.vc setSelectItem:self.delegate.filterPath];
        }
        cell = filterCell;
    } else {
        
        if ([self.titleType isEqualToString:BEEffectAr_hair_color]) {
            BEBeautyHairColorCell *beautyCell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEBeautyHairColorCell be_identifier] forIndexPath:indexPath];
            beautyCell.colorVc.titleType = self.titleType;
            self.colorView.hidden = NO;
            [beautyCell.colorVc setItem:[self.delegate.dataManager buttonItem:model.type]];
            [beautyCell.colorVc setSelectNodes:self.delegate.selectNodes dataManager:self.delegate.dataManager];
            [beautyCell.colorVc setRemoveTitlePlaceholderView:self.colorView];
            [beautyCell.colorVc showPlaceholder:YES];
            [beautyCell.colorVc faceBeautyViewArray:self.faceBeautyViewArray];
            cell = beautyCell;
        }
        else {
            BEEffectFaceBeautyViewCell *beautyCell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEEffectFaceBeautyViewCell be_identifier] forIndexPath:indexPath];
            beautyCell.vc.titleType = self.titleType;
            [beautyCell.vc setItem:[self.delegate.dataManager buttonItem:model.type]];
            [beautyCell.vc setSelectNodes:self.delegate.selectNodes dataManager:self.delegate.dataManager];
            if ([self.titleType isEqualToString:BEEffectAr_try_lipstick]) {
                [beautyCell.vc faceBeautyViewArray:self.faceBeautyViewArray];
            }
            cell = beautyCell;
        }
        
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout


#pragma mark - BEEffectSwitchTabViewDelegate
- (void)switchTabDidSelectedAtIndex:(NSInteger)index {
    BEEffectCategoryModel *model = self.categories[index];
    if (model.type == BETypeStyleHairDyeFull) {
        for (int i=0; i<self.faceBeautyViewArray.count; i++) {
            BEFaceBeautyView *view = self.faceBeautyViewArray[i];
            [view hiddenColorListAdapter:YES];
        }
    }
    else {
        for (int i=0; i<self.faceBeautyViewArray.count; i++) {
            BEFaceBeautyView *view = self.faceBeautyViewArray[i];
            [view hiddenColorListAdapter:NO];
        }
    }
    [self.delegate tabDidChanged:model];
    [self.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - getter
- (BECategoryView *)categoryView {
    if (_categoryView == nil) {
        BECategoryView *categoryView = [BECategoryView new];
        categoryView.tabDelegate = self;
        categoryView.contentView = self.cv;
        _categoryView = categoryView;
    }
    return _categoryView;
}

- (UICollectionView *)cv {
    if (_cv == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        contentCollectionView.backgroundColor = [UIColor clearColor];
        contentCollectionView.showsHorizontalScrollIndicator = NO;
        contentCollectionView.showsVerticalScrollIndicator = NO;
        contentCollectionView.pagingEnabled = YES;
        contentCollectionView.dataSource = self;
        contentCollectionView.delegate = self;
        [contentCollectionView registerClass:[BEEffecFiltersCollectionViewCell class] forCellWithReuseIdentifier:[BEEffecFiltersCollectionViewCell be_identifier]];
        [contentCollectionView registerClass:[BEEffectFaceBeautyViewCell class] forCellWithReuseIdentifier:[BEEffectFaceBeautyViewCell be_identifier]];
        [contentCollectionView registerClass:[BEBeautyHairColorCell class] forCellWithReuseIdentifier:[BEBeautyHairColorCell be_identifier]];
        _cv = contentCollectionView;
    }
    return _cv;
}

- (BEBoardBottomView *)boardBottomView {
    if (_boardBottomView == nil) {
        _boardBottomView = [[BEBoardBottomView alloc] init];
        _boardBottomView.delegate = self.delegate;
    }
    return _boardBottomView;
}

- (BETextSliderView *)textSlider {
    if (!_textSlider) {
        _textSlider = [BETextSliderView new];
        _textSlider.backgroundColor = [UIColor clearColor];
        _textSlider.lineHeight = 2.5;
        _textSlider.textOffset = 25;
        _textSlider.animationTime = 250;
    }
    return _textSlider;
}

- (UIView *)vBoard {
    if (_vBoard == nil) {
        _vBoard = [[UIView alloc] init];
        _vBoard.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
    }
    return _vBoard;
}

@end
