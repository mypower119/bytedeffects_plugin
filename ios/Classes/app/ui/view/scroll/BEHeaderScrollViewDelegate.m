//
//  BEHeaderScrollViewDelegate.m
//  app
//
//  Created by qun on 2021/9/29.
//

#import "BEHeaderScrollViewDelegate.h"
#import "BEHeaderScrollViewHeader.h"
#import <objc/runtime.h>

static NSString *HEADER_SCROLL_VIEW_HEADER_ID = @"header_scroll_view_header";

@interface BEHeaderScrollViewDelegate () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    BOOL _keepHeight;
    CGFloat _lastContentOffsetY;
    
    BOOL _registerHeaderView;
}

@end

@implementation BEHeaderScrollViewDelegate

@synthesize headerHeight = _headerHeight;

+ (void)swizzleMethods {static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethods:[self class] originalSelector:@selector(numberOfSectionsInCollectionView:) swizzledSelector:@selector(be_numberOfSectionsInCollectionView:)];
        [self swizzleMethods:[self class] originalSelector:@selector(collectionView:numberOfItemsInSection:) swizzledSelector:@selector(be_collectionView:numberOfItemsInSection:)];
        [self swizzleMethods:[self class] originalSelector:@selector(collectionView:cellForItemAtIndexPath:) swizzledSelector:@selector(be_collectionView:cellForItemAtIndexPath:)];
        [self swizzleMethods:[self class] originalSelector:@selector(collectionView:didSelectItemAtIndexPath:) swizzledSelector:@selector(be_collectionView:didSelectItemAtIndexPath:)];
        
        [self swizzleMethods:[self class] originalSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:) swizzledSelector:@selector(be_collectionView:viewForSupplementaryElementOfKind:atIndexPath:)];
        [self swizzleMethods:[self class] originalSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:) swizzledSelector:@selector(be_collectionView:layout:referenceSizeForHeaderInSection:)];
        [self swizzleMethods:[self class] originalSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:) swizzledSelector:@selector(be_collectionView:layout:referenceSizeForFooterInSection:)];
        
        [self swizzleMethods:[self class] originalSelector:@selector(scrollViewWillBeginDragging:) swizzledSelector:@selector(be_scrollViewWillBeginDragging:)];
        [self swizzleMethods:[self class] originalSelector:@selector(scrollViewDidEndDragging:willDecelerate:) swizzledSelector:@selector(be_scrollViewDidEndDragging:willDecelerate:)];
        [self swizzleMethods:[self class] originalSelector:@selector(scrollViewDidEndDecelerating:) swizzledSelector:@selector(be_scrollViewDidEndDecelerating:)];
        [self swizzleMethods:[self class] originalSelector:@selector(scrollViewDidScroll:) swizzledSelector:@selector(be_scrollViewDidScroll:)];
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keepHeight = YES;
        _registerHeaderView = NO;
    }
    return self;
}

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    
    [self.collectionView addSubview:headerView];
    headerView.layer.zPosition = CGFLOAT_MAX;
    self.headerHeight = headerView.bounds.size.height;
}

#pragma mark - swizzled methods
- (NSInteger)be_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self be_numberOfSectionsInCollectionView:collectionView] + 1;
}

- (NSInteger)be_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return [self be_collectionView:collectionView numberOfItemsInSection:section-1];
}

- (__kindof UICollectionViewCell *)be_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    
    return [self be_collectionView:collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
}

- (UICollectionReusableView *)be_collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            if (!_registerHeaderView) {
                [collectionView registerClass:[BEHeaderScrollViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_SCROLL_VIEW_HEADER_ID];
                _registerHeaderView = YES;
            }
            
            BEHeaderScrollViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_SCROLL_VIEW_HEADER_ID forIndexPath:indexPath];
            return header;
        } else {
            return nil;
        }
    }
    
    return [self be_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
}

- (CGSize)be_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView.bounds.size;
    }
    
    return [self be_collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section-1];
}

- (CGSize)be_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    
    return [self be_collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section-1];
}

- (void)be_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    [self be_collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
}

- (void)be_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _keepHeight = NO;
    _lastContentOffsetY = scrollView.contentOffset.y;
    
    [self be_scrollViewWillBeginDragging:scrollView];
}

- (void)be_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _keepHeight = !decelerate;
    
    [self be_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)be_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _keepHeight = YES;
    
    [self be_scrollViewDidEndDecelerating:scrollView];
}

- (void)be_scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_keepHeight) {
        self.headerHeight = _headerHeight;
    } else {
        CGFloat detalY = [self detalY];
        if (detalY > 0) {
            // drag up
            if (_headerHeight > _minHeaderHeight) {
                self.headerHeight = MAX(_minHeaderHeight, _headerHeight - detalY);
            } else {
                self.headerHeight = _minHeaderHeight;
            }
        } else {
            // drag down
            CGFloat preferHeight = [self preferHeaderHeight];
            if (_headerHeight < _maxHeaderHeight && preferHeight > _minHeaderHeight) {
                self.headerHeight = preferHeight;
            } else {
                self.headerHeight = _headerHeight;
            }
        }
        
        _lastContentOffsetY = scrollView.contentOffset.y;
    }
    
    [self be_scrollViewDidScroll:scrollView];
}

#pragma mark - public
- (CGFloat)offsetYWithSection:(NSInteger)section {
    UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section+1]];
    
    CGFloat offsetY = attr.frame.origin.y - self.headerHeight - 55;
    if (offsetY < self.minContentOffsetY) {
        offsetY = self.minContentOffsetY;
    }
    offsetY = MIN(offsetY, self.maxContentOffsetY);
    return offsetY;
}

- (NSArray<NSIndexPath *> *)realVisiableItems:(NSArray<NSIndexPath *> *)items {
    NSMutableArray *arr = [NSMutableArray array];
    CGFloat headerHeight = self.headerHeight;
    CGFloat contentOffset = self.collectionView.contentOffset.y;
    for (NSIndexPath *path in items) {
        UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        CGFloat offsetY = attr.frame.origin.y - contentOffset - headerHeight + 55;
        if (offsetY > 0) {
            [arr addObject:[NSIndexPath indexPathForRow:path.row inSection:path.section-1]];
        }
    }
    return [arr copy];
}

#pragma mark - getter & setter
- (void)setHeaderHeight:(CGFloat)height {
    _headerHeight = height;
    NSInteger offsetY = self.collectionView.contentOffset.y;
    _headerView.frame = CGRectMake(0, offsetY + height - _headerView.bounds.size.height, _headerView.bounds.size.width, _headerView.bounds.size.height);
}

- (CGFloat)headerHeight {
    NSInteger offsetY = self.collectionView.contentOffset.y;
    return _headerView.frame.origin.y + _headerView.bounds.size.height - offsetY;
}

- (CGFloat)preferHeaderHeight {
    NSInteger offsetY = self.collectionView.contentOffset.y;
    return _headerView.bounds.size.height - offsetY;
}

- (CGFloat)minContentOffsetY {
    return (self.maxHeaderHeight - self.headerHeight);
}

- (CGFloat)maxContentOffsetY {
    return self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
}

- (CGFloat)detalY {
    return self.collectionView.contentOffset.y - _lastContentOffsetY;
}

+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
     
    //class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        //origMethod and swizMethod already exist
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

@end
