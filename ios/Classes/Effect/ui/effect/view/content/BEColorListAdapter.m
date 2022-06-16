//
//  BEColorListAdapter.m
//  BEEffect
//
//  Created by qun on 2021/8/30.
//

#import "BEColorListAdapter.h"
#import "BEColorItemCell.h"
#import "UICollectionViewCell+BEAdd.h"
#import "Masonry.h"

@interface BEColorListAdapter () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UIView *placeholder;
@property (nonatomic, strong) NSArray<BEEffectColorItem *> *colorset;

@end

@implementation BEColorListAdapter

@synthesize collectionView = _collectionView;

- (instancetype)initWithColorset:(NSArray<BEEffectColorItem *> *)colorset {
    self = [super init];
    if (self) {
        self.colorset = colorset;
    }
    return self;
}

- (void)refreshWith:(NSArray<BEEffectColorItem *> *)colorset {
    self.colorset = colorset;
    [self.collectionView reloadData];
    
    CGFloat width = (self.colorset.count * 24) + ((self.colorset.count - 1) * 28);
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerY.centerX.equalTo(self.placeholder);
        make.width.mas_equalTo(width);
    }];
}

- (void)selectItem:(NSInteger)index {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)addToContainer:(UIView *)container placeholder:(UIView *)placeholder {
    if (container == nil) {
        return;
    }
    
    _placeholder = placeholder;
    [container addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(placeholder);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorset.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEColorItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEColorItemCell be_identifier] forIndexPath:indexPath];
    cell.color = self.colorset[indexPath.row].color;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate colorListAdapter:self didSelectedAt:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(24, 24);
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [UICollectionViewFlowLayout new];
        fl.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        fl.minimumLineSpacing = 28;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        [_collectionView registerClass:[BEColorItemCell class] forCellWithReuseIdentifier:[BEColorItemCell be_identifier]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
