//
//  BEAlgorithmScrollableButtonView.m
//  Algorithm
//
//  Created by qun on 2021/6/8.
//

#import "BEAlgorithmScrollableButtonView.h"
#import "BESelectableCell.h"
#import "BELightUpSelectableView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "Masonry.h"
#import "Common.h"

@interface BEAlgorithmScrollableButtonView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *cv;

- (double)preferWidth;

@end

@implementation BEAlgorithmScrollableButtonView

- (void)setItem:(BEAlgorithmItem *)item {
    [super setItemWithoutUI:item];
    
    [self addSubview:self.cv];
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self);
        if (self.preferWidth >= self.frame.size.width) {
            make.width.equalTo(self);
        } else {
            make.width.mas_equalTo(self.preferWidth);
        }
    }];
}

- (void)selectItem:(NSInteger)index {
    [self.cv selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)unselectItem:(NSInteger)index {
    [self.cv deselectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEAlgorithmItem *item = self.items[indexPath.row];
    BESelectableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BESelectableCell be_identifier] forIndexPath:indexPath];
    
    [cell setSelectableConfig:[BELightUpSelectableConfig
                               initWithUnselectImage:item.selectImg
                               imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    cell.selectableButton.title = NSLocalizedString(item.title, nil);
    cell.useCellSelectedState = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectSet containsObject:self.items[indexPath.row].key]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        });
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self openItem:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self closeItem:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(66));
}

#pragma mark - getter
- (UICollectionView *)cv {
    if (_cv) {
        return _cv;
    }
    UICollectionViewFlowLayout *fl = [UICollectionViewFlowLayout new];
    fl.minimumLineSpacing = BEF_DESIGN_SIZE(20);
    fl.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    fl.minimumLineSpacing = 10;
    _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
    [_cv registerClass:[BESelectableCell class] forCellWithReuseIdentifier:[BESelectableCell be_identifier]];
    _cv.backgroundColor = [UIColor clearColor];
    _cv.showsHorizontalScrollIndicator = NO;
    _cv.showsVerticalScrollIndicator = NO;
    _cv.allowsMultipleSelection = YES;
    _cv.dataSource = self;
    _cv.delegate = self;
    return _cv;
}

- (double)preferWidth {
    NSUInteger count = self.items.count;
    return count * 80 + (count - 1) * 10;
}

@end
