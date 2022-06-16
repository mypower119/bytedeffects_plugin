//
//  BETabStickerPickerView.m
//  BEEffect
//
//  Created by qun on 2021/10/22.
//

#import "BETabStickerPickerView.h"
#import "BEStickerPickerCell.h"
#import "BECategoryView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "Masonry.h"

@interface BETabStickerPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BEEffectSwitchTabViewDelegate, BEStickerPickerViewDelegate>

@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) BECategoryView *categoryView;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredIdentifier;
@property (nonatomic, strong) NSArray<BEStickerGroup *> *groups;
@property (nonatomic, strong) NSIndexPath *selectTabIndex;
@property (nonatomic, strong) NSIndexPath *selectTabContentIndex;

@end

@implementation BETabStickerPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.categoryView];
        
        [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _registeredIdentifier = [NSMutableSet set];
        
        _selectTabIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        _selectTabContentIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)setGroups:(NSArray<BEStickerGroup *> *)groups {
    _groups = groups;
    
    NSMutableArray<NSString *> *titles = [NSMutableArray array];
    for (BEStickerGroup *group in groups) {
        [titles addObject:group.title];
    }
    [self.categoryView setIndicators:titles];
    [self.cv reloadData];
}

- (void)setSelectItem:(BEStickerItem *)selectItem {
    for (int i = 0; i < _groups.count; ++i) {
        BEStickerGroup *group = _groups[i];
        for (int j = 0; j < group.items.count; ++j) {
            BEStickerItem *item = group.items[j];
            if (item == selectItem) {
                [self setSelectTabIndex:[NSIndexPath indexPathForRow:i inSection:0] withTabContentIndex:[NSIndexPath indexPathForRow:j inSection:0]];
            }
        }
    }
}

- (void)setSelectTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath {
    if (_selectTabIndex.row != tabIndexPath.row) {
        UICollectionViewCell *cell = [self.cv cellForItemAtIndexPath:_selectTabIndex];
        if (cell == nil) {
            [self.cv reloadItemsAtIndexPaths:[NSArray arrayWithObjects:_selectTabIndex, nil]];
        } else if ([cell isKindOfClass:[BEStickerPickerCell class]]) {
            [[(BEStickerPickerCell *)cell pickerView] setSelectIndex:0];
        }
    }
    
    UICollectionViewCell *cell = [self.cv cellForItemAtIndexPath:tabIndexPath];
    if (cell == nil) {
        [self.cv reloadItemsAtIndexPaths:[NSArray arrayWithObjects:tabIndexPath, nil]];
    } else if ([cell isKindOfClass:[BEStickerPickerCell class]]) {
        [[(BEStickerPickerCell *)cell pickerView] setSelectIndex:contentIndexPath.row];
    }
    
    _selectTabIndex = tabIndexPath;
    _selectTabContentIndex = contentIndexPath;
}

- (void)refreshTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath {
    UICollectionViewCell *cell = [self.cv cellForItemAtIndexPath:tabIndexPath];
    if (cell == nil) {
        [self.cv reloadItemsAtIndexPaths:[NSArray arrayWithObjects:tabIndexPath, nil]];
    } else if ([cell isKindOfClass:[BEStickerPickerCell class]]) {
        [[(BEStickerPickerCell *)cell pickerView] refreshIndexPath:contentIndexPath];
    }
    for (int i=0; i<self.groups.count; i++) {
        BEStickerGroup *groupsItem = self.groups[i];
        for (int j=0; j<groupsItem.items.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [[(BEStickerPickerCell *)cell pickerView] refreshIndexPath:indexPath];
        }
    }
}

#pragma mark - UICollectionViewData	Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.groups.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //  {zh} 这个 CollectionView 不需要进行 cell 的复用，所以每一个 cell 都有一个单独的 identifier  {en} This CollectionView does not require cell reuse, so each cell has a separate identifier
    NSString *identifier = [[BEStickerPickerCell be_identifier] stringByAppendingFormat:@"_%ld", indexPath.row];
    if (![self.registeredIdentifier containsObject:identifier]) {
        [collectionView registerClass:[BEStickerPickerCell class] forCellWithReuseIdentifier:identifier];
    }
    
    BEStickerGroup *group = self.groups[indexPath.row];
    BEStickerPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.pickerView.group = group;
    cell.pickerView.delegate = self;
    [cell.pickerView setSelectIndex:indexPath.row == _selectTabIndex.row ? _selectTabContentIndex.row : 0];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - BEEffectSwitchTabViewDelegate
- (void)switchTabDidSelectedAtIndex:(NSInteger)index {
    [self.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - BEStickerPickerViewDelegate
- (BOOL)pickerView:(BEStickerPickerView *)view willSelectItem:(BEStickerItem *)item atIndexPath:(NSIndexPath *)indexPath {
    return [self.delegate tabPickerView:self willSelectItem:item atTabIndex:[NSIndexPath indexPathForRow:[self.groups indexOfObject:view.group] inSection:0] withContentIndex:indexPath];
}

#pragma mark - getter
- (BECategoryView *)categoryView {
    if (_categoryView) {
        return _categoryView;
    }
    
    BECategoryView *categoryView = [BECategoryView new];
    categoryView.tabDelegate = self;
    categoryView.contentView = self.cv;
    _categoryView = categoryView;
    return _categoryView;
}

- (UICollectionView *)cv {
    if (_cv) {
        return _cv;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    contentCollectionView.showsVerticalScrollIndicator = NO;
    contentCollectionView.pagingEnabled = YES;
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    _cv = contentCollectionView;
    return _cv;
}

@end
