//
//  BENewStickerPickerView.m
//  BEEffect
//
//  Created by qun on 2021/10/22.
//

#import "BEStickerPickerView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "BEDownloadableSelectableCell.h"
#import "BERectangleSelectableView.h"
#import "BERemoteResource.h"
#import "BECollectionViewFlowLayout.h"
#import "Masonry.h"
#import "Common.h"

@interface BEStickerPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSArray<BEStickerItem *> *items;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation BEStickerPickerView

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

- (void)setSelectItem:(BEStickerItem *)selectItem {
    NSInteger index = 0;
    if ([self.items containsObject:selectItem]) {
        index = [self.items indexOfObject:selectItem];
    }
    
    [self setSelectIndex:index];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (_selectIndex != selectIndex) {
        BEDownloadableSelectableCell *cell = (BEDownloadableSelectableCell *)[self.cv cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
        if (cell) {
            cell.selectableButton.isSelected = NO;
        } else {
            [self.cv reloadData];
        }
    }
    
    BEDownloadableSelectableCell *cell = (BEDownloadableSelectableCell *)[self.cv cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
    if (cell) {
        cell.selectableButton.isSelected = YES;
    } else {
        [self.cv reloadData];
    }
    
    _selectIndex = selectIndex;
}

- (void)setItems:(NSArray<BEStickerItem *> *)items {
    _items = items;
    
    [self.cv reloadData];
    
    if (_selectIndex < 0 || _selectIndex > self.items.count -1) {
        _selectIndex = 0;
    }
    [self setSelectItem:items[_selectIndex]];
}

- (void)setGroup:(BEStickerGroup *)group {
    _group = group;
    [self setItems:group.items];
}

- (void)refreshIndexPath:(NSIndexPath *)indexPath {
    BEDownloadableSelectableCell *cell = (BEDownloadableSelectableCell *)[self.cv cellForItemAtIndexPath:indexPath];
    if (cell) {
        BEStickerItem *sticker = self.items[indexPath.row];
        if ([sticker.resource isKindOfClass:[BERemoteResource class]]) {
            BERemoteResourceState state = [(BERemoteResource *)sticker.resource state];
            if (state == BERemoteResourceStateRemote) {
                [cell.downloadView setState:BEDownloadViewStateInit];
            } else if (state == BERemoteResourceStateDownloading) {
                [cell.downloadView setState:BEDownloadViewStateDownloading];
                [cell.downloadView setDownloadProgress:[[(BERemoteResource *)sticker.resource downloadProgress] fractionCompleted]];
            } else {
                [cell.downloadView setState:BEDownloadViewStateDownloaded];
            }
        } else {
            [cell.downloadView setState:BEDownloadViewStateDownloaded];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEStickerItem *sticker = self.items[indexPath.row];
    BEDownloadableSelectableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEDownloadableSelectableCell be_identifier] forIndexPath:indexPath];
    [cell setSelectableConfig:[BERectangleSelectableConfig initWithImageName:sticker.icon imageSize:CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(66))]];
    cell.useCellSelectedState = NO;
    cell.selectableButton.title = sticker.title;
    cell.selectableButton.isSelected = _selectIndex == indexPath.row;
    if ([sticker.resource isKindOfClass:[BERemoteResource class]]) {
        BERemoteResourceState state = [(BERemoteResource *)sticker.resource state];
        if (state == BERemoteResourceStateRemote) {
            [cell.downloadView setState:BEDownloadViewStateInit];
        } else if (state == BERemoteResourceStateDownloading) {
            [cell.downloadView setState:BEDownloadViewStateDownloading];
            [cell.downloadView setDownloadProgress:[[(BERemoteResource *)sticker.resource downloadProgress] fractionCompleted]];
        } else {
            [cell.downloadView setState:BEDownloadViewStateDownloaded];
        }
    } else {
        [cell.downloadView setState:BEDownloadViewStateDownloaded];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(97));
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BEStickerItem *item = self.items[indexPath.row];
    return [self.delegate pickerView:self willSelectItem:item atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectIndex:indexPath.row];
}


#pragma mark - getter
- (UICollectionView *)cv {
    if (_cv) {
        return _cv;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[BECollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = BEF_DESIGN_SIZE(12);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    contentCollectionView.showsVerticalScrollIndicator = NO;
    contentCollectionView.pagingEnabled = NO;
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    [contentCollectionView registerClass:[BEDownloadableSelectableCell class] forCellWithReuseIdentifier:[BEDownloadableSelectableCell be_identifier]];
    _cv = contentCollectionView;
    return _cv;
}

@end
