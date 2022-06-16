//
//  BEActionView.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/16.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"

#import "BEActionView.h"
#import "BEMainTabCell.h"

@interface BEActionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat _cellWidth;
    CGFloat _cellHeight;
}

@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, assign) NSInteger col;

@end


@implementation BEActionView

#pragma mark - init

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles column:(NSInteger)col frame:(CGRect)frame{
    if (self = [super init]) {
        self.titles = titles;
        self.col = col;
        _cellWidth = frame.size.width / col;
        _cellHeight = frame.size.height;
        
        [self addSubview:self.cv];
        [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - public
- (void)clearSelect {
    for (int i = 0; i < self.titles.count; i++) {
        [self.cv deselectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
    }
}

- (void)setSelect:(NSInteger)select {
    [self.cv selectItemAtIndexPath:[NSIndexPath indexPathForRow:select inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEMainTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEMainTabCell be_identifier] forIndexPath:indexPath];
    [cell renderWithTitle:self.titles[indexPath.row]];
    [cell setTitleLabelFont:[UIFont systemFontOfSize:13]];
    cell.backgroundColor = [UIColor clearColor];
    cell.hightlightTextColor = self.highlightTextColor;
    cell.normalTextColor = self.normalTextColor;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_cellWidth, _cellHeight);
}

#pragma mark - getter
- (UICollectionView *)cv {
    if (!_cv) {
        UICollectionViewFlowLayout *fl = [UICollectionViewFlowLayout new];
        fl.minimumLineSpacing = 2;
        fl.minimumInteritemSpacing = 0;
        fl.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _cv.backgroundColor = [UIColor clearColor];
        [_cv registerClass:[BEMainTabCell class] forCellWithReuseIdentifier:[BEMainTabCell be_identifier]];
        _cv.showsHorizontalScrollIndicator = NO;
        _cv.showsVerticalScrollIndicator = NO;
        _cv.dataSource = self;
        _cv.delegate = self;
        _cv.allowsMultipleSelection = YES;
    }
    return _cv;
}

@end
