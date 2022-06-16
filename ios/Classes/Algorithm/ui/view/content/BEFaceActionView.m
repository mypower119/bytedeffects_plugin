//
//  BEFaceActionView.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEFaceActionView.h"
#import <Masonry/Masonry.h>
#import "BEMainTabCell.h"
#import "NSArray+BEAdd.h"
#import "BETextSizeUtils.h"

@interface BEFaceActionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation BEFaceActionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    [self.collectionView reloadData];
}

- (void)setIndex:(NSInteger)index selected:(BOOL)selected {
    if (selected) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEMainTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEMainTabCell be_identifier] forIndexPath:indexPath];
    cell.textScrollable = YES;
    [cell renderWithTitle:[self.items be_objectAtIndex:indexPath.row]];
    [cell setTitleLabelFont:[UIFont systemFontOfSize:13]];
    cell.hightlightTextColor = self.hightlightTextColor;
    cell.normalTextColor = self.normalTextColor;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    return cell;
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 3;
        flowLayout.minimumInteritemSpacing = 0.1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[BEMainTabCell class] forCellWithReuseIdentifier:[BEMainTabCell be_identifier]];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(38, 23);
}

@end
