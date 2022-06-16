// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import "BEModernFilterPickerView.h"

#import <Masonry/Masonry.h>

#import "BEEffectResponseModel.h"
#import "BEDeviceInfoHelper.h"
#import "BESelectableCell.h"
#import "BERectangleSelectableView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "Common.h"

@interface BEModernFilterPickerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray <BEFilterItem *> *filters;
@property (nonatomic, copy) NSArray <BEEffectItem *> *lipsticks;
@property (nonatomic, weak) NSIndexPath* currentSelectedCellIndexPath;
@end

@implementation BEModernFilterPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(BEF_DESIGN_SIZE(97));
            make.leading.trailing.equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - public
- (void)refreshWithFilters:(NSArray<BEFilterItem *> *)filters {
    self.filters = filters;
    
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setAllCellsUnSelected{
    if (_currentSelectedCellIndexPath){
        [self.collectionView deselectItemAtIndexPath:_currentSelectedCellIndexPath animated:false];
    }
    _currentSelectedCellIndexPath = nil;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setSelectItem:(NSString *)filterPath {
    NSInteger index = 0;
    if (filterPath == nil || [filterPath isEqualToString:@""]) {
        index = 0;
    } else {
        for (int i = 0; i < self.filters.count; i++) {
            if ([filterPath isEqualToString:self.filters[i].filterPath]) {
                index = i;
                break;
            }
        }
    }
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEFilterItem *filter = self.filters[indexPath.row];
    BESelectableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BESelectableCell be_identifier] forIndexPath:indexPath];
    [cell setSelectableConfig:[BERectangleSelectableConfig
                               initWithImageName:filter.imageName imageSize:CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(66))]];
    cell.useCellSelectedState = YES;
    cell.selectableButton.title = filter.title;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentSelectedCellIndexPath = indexPath;
    if ([self.delegate respondsToSelector:@selector(filterPicker:didSelectFilter:)]) {
        [self.delegate filterPicker:self didSelectFilter:self.filters[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(97));
}


#pragma mark - getter && setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = BEF_DESIGN_SIZE(14);
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, BEF_DESIGN_SIZE(13), 0, BEF_DESIGN_SIZE(13));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[BESelectableCell class] forCellWithReuseIdentifier:[BESelectableCell be_identifier]];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}


@end
