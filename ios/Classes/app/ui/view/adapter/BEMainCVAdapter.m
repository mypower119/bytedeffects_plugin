//
//  BEMainCVAdapter.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEMainCVAdapter.h"
#import "BEMainCVCell.h"
#import "BEMainCVHeader.h"
#import "BEMainCVVersionFooter.h"
#import "UICollectionViewCell+BEAdd.h"
#import "Common.h"

static NSString * const reuseIdentifierHeader = @"be_header";
static NSString * const reuseIdentifierFooter = @"be_footer_version";
static NSInteger LINE_INTERVAL = 2;

@interface BEMainCVAdapter () <BEEffectSwitchTabViewDelegate>

@property (nonatomic) BOOL shouldIgnoreTabAnimation;

@end

@implementation BEMainCVAdapter

@synthesize collectionView = _cv;
@synthesize tabView = _tabView;

+ (void)load {
    [self swizzleMethods];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.featureItems.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.featureItems[section].children.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEMainCVItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEMainCVItemCell be_identifier] forIndexPath:indexPath];
    BEFeatureItem *item = self.featureItems[indexPath.section].children[indexPath.row];
    [cell updateTitle:item.title icon:item.icon];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        //  {zh} header 为每一个功能的标题  {en} Header is the title of each function
        BEMainCVHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        if (indexPath.section > 0) {
            [header updateWithTitle:self.featureItems[indexPath.section-1].title];
        }
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        //  {zh} footer 仅有最后一个，用于展示 version  {en} Only the last footer, for display version
        BEMainCVVersionFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter forIndexPath:indexPath];
        [footer updateWithVersion:[@"V" stringByAppendingString: SDK_CHEAT_APP_VERSION]];
        return footer;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [collectionView bounds].size;
    return CGSizeMake((size.width - LINE_INTERVAL - 0) / 2, 52);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = [collectionView bounds].size;
    return CGSizeMake(size.width, 55);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section < self.featureItems.count - 1) {
        return CGSizeZero;
    }
    CGSize size = [collectionView bounds].size;
    return CGSizeMake(size.width, 200);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BEFeatureItem *item = self.featureItems[indexPath.section].children[indexPath.row];
    [self.delegate didClickItem:item];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.shouldIgnoreTabAnimation = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.shouldIgnoreTabAnimation = decelerate;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.shouldIgnoreTabAnimation = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.shouldIgnoreTabAnimation) {
        return;
    }
    NSInteger minSection = NSIntegerMax;
    NSArray<NSIndexPath *> *indexPath = [self realVisiableItems:[self.collectionView indexPathsForVisibleItems]];
    for (NSIndexPath *i in indexPath) {
        if (i.section < minSection) {
            minSection = i.section;
        }
    }
    [self.tabView selectItemAtIndex:minSection animated:YES];
}

#pragma mark - BEEffectSwitchTabViewDelegate
- (void)switchTabDidSelectedAtIndex:(NSInteger)index {
    if (self.shouldIgnoreTabAnimation) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat offsetY = [self offsetYWithSection:index];
        self.collectionView.contentOffset = CGPointMake(0, offsetY);
    } completion:nil];
}

#pragma mark - setter
- (void)setFeatureItems:(NSArray<BEFeatureGroup *> *)featureItems {
    _featureItems = featureItems;
    [self.collectionView reloadData];
    [self.tabView refreshWithTitles:[self tabTitle]];
    [self.tabView selectItemAtIndex:0 animated:NO];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (_cv == nil) {
        UICollectionViewFlowLayout *fl = [UICollectionViewFlowLayout new];
        fl.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        fl.scrollDirection = UICollectionViewScrollDirectionVertical;
        fl.minimumLineSpacing = LINE_INTERVAL;
        fl.minimumInteritemSpacing = LINE_INTERVAL;
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        [_cv registerClass:[BEMainCVTitleCell class] forCellWithReuseIdentifier:[BEMainCVTitleCell be_identifier]];
        [_cv registerClass:[BEMainCVItemCell class] forCellWithReuseIdentifier:[BEMainCVItemCell be_identifier]];
        [_cv registerClass:[BEMainCVHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
        [_cv registerClass:[BEMainCVVersionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter];
        _cv.backgroundColor = [UIColor clearColor];
        _cv.showsHorizontalScrollIndicator = NO;
        _cv.showsVerticalScrollIndicator = NO;
        _cv.allowsMultipleSelection = NO;
        _cv.dataSource = self;
        _cv.delegate = self;
        _cv.backgroundColor = BEColorWithRGBHex(0xF4F5F7);
        _cv.bounces = NO;
    }
    return _cv;
}

- (BEEffectSwitchTabView *)tabView {
    if (!_tabView) {
        _tabView = [[BEEffectSwitchTabView alloc] initWithTitles:@[]];
        _tabView.delegate = self;
        _tabView.normalTextColor = BEColorWithRGBHex(0x86909C);
        _tabView.hightlightTextColor = BEColorWithRGBHex(0x1D2129);
        
        BESwitchIndicatorLineStyle *style = [BESwitchIndicatorLineStyle new];
        style.height = 3;
        style.widthRatio = 1.f/3;
        style.bottomMargin = 8;
        style.cornerRadius = 1.5;
        style.backgroundColor = BEColorWithRGBHex(0x1664FF);
        _tabView.indicatorLineStyle = style;
    }
    return _tabView;
}

- (NSArray *)tabTitle {
    NSMutableArray *arr = [NSMutableArray array];
    for (BEFeatureGroup *group in self.featureItems) {
        [arr addObject:NSLocalizedString(group.title, nil)];
    }
    return arr;
}

@end
