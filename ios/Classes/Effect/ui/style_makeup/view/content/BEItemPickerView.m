//
//  BEItemPickerView.m
//  Effect
//
//  Created by qun on 2021/5/27.
//

#import "BEItemPickerView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "BEIconItemCell.h"
#import "BESelectableCell.h"
#import "BERectangleSelectableView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEItemPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *cv;

@property (nonatomic, strong) NSArray<BEEffectItem *> *items;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation BEItemPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cv];
        [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.centerY.equalTo(self);
            make.height.mas_equalTo(BEF_DESIGN_SIZE(97));
        }];
        
        _selectIndex = 0;
    }
    return self;
}

- (void)setSelectItem:(BEEffectItem *)selectItem {
    NSInteger index = 0;
    if ([self.items containsObject:selectItem]) {
        index = [self.items indexOfObject:selectItem];
    }
    
    if (index != _selectIndex) {
        [self.cv deselectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:NO];
    }
    
    _selectIndex = index;
    [self.cv selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setItems:(NSArray<BEEffectItem *> *)items {
    _items = items;
    
    [self.cv reloadData];
    
    if (_selectIndex < 0 || _selectIndex > self.items.count -1) {
        _selectIndex = 0;
    }
    [self setSelectItem:self.items[_selectIndex]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEEffectItem *sticker = self.items[indexPath.row];
    BESelectableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BESelectableCell be_identifier] forIndexPath:indexPath];
    cell.selectableConfig = [BERectangleSelectableConfig initWithImageName:sticker.selectImg imageSize:CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(66))];
    cell.useCellSelectedState = YES;
    cell.selectableButton.title = sticker.title;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(97));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    BEEffectItem *item = self.items[indexPath.row];
    [self.delegate pickerView:self didSelectItem:item];
    
}


#pragma mark - getter
- (UICollectionView *)cv {
    if (_cv) {
        return _cv;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = BEF_DESIGN_SIZE(12);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, BEF_DESIGN_SIZE(12), 0, BEF_DESIGN_SIZE(12));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    contentCollectionView.showsVerticalScrollIndicator = NO;
    contentCollectionView.pagingEnabled = NO;
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    [contentCollectionView registerClass:[BESelectableCell class] forCellWithReuseIdentifier:[BESelectableCell be_identifier]];
    _cv = contentCollectionView;
    return _cv;
}

@end
