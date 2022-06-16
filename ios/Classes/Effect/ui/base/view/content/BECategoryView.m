//
//  BECategoryView.m
//  BytedEffects
//
//  Created by QunZhang on 2019/10/10.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"

#import "BECategoryView.h"
#import "BEEffectSwitchTabView.h"
#import "Common.h"

@interface BECategoryView () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) BEEffectSwitchTabView *tabView;
@property (nonatomic, strong) UILabel *vBorder;
@property(nonatomic, assign) BOOL shouldIgnoreAnimation;

@end

@implementation BECategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat TAB_HEIGHT = BEF_DESIGN_SIZE(BEF_SWITCH_TAB_HEIGHT);
        
        [self addSubview:self.tabView];
        [self addSubview:self.vBorder];
        
        [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(TAB_HEIGHT);
        }];
        
        [self.vBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.tabView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

#pragma mark - public
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.tabView selectItemAtIndex:index animated:animated];
}

- (BEEffectSwitchTabView *)switchTabView {
    return self.tabView;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentView.bounds.size;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger wouldSelectIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (self.tabView.selectedIndex != wouldSelectIndex) {
        [self.tabView selectItemAtIndex:wouldSelectIndex animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSInteger wouldSelectIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (self.tabView.selectedIndex != wouldSelectIndex) {
            [self.tabView selectItemAtIndex:wouldSelectIndex animated:YES];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.shouldIgnoreAnimation = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.shouldIgnoreAnimation) {
        return;
    }
    CGFloat offsetX = self.contentView.contentOffset.x;
    CGFloat proportion = offsetX / self.contentView.frame.size.width;
    self.tabView.proportion = proportion;
}

#pragma mark - getter
- (BEEffectSwitchTabView *)tabView {
    if (!_tabView) {
        _tabView = [[BEEffectSwitchTabView alloc] initWithTitles:@[]];
        _tabView.delegate = self.tabDelegate;
        _tabView.normalTextColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
        _tabView.hightlightTextColor = [UIColor whiteColor];
        [self.contentView invalidateIntrinsicContentSize];
        [self.contentView layoutIfNeeded];
    }
    return _tabView;
}

#pragma mark - setter
- (void)setTabDelegate:(id<BEEffectSwitchTabViewDelegate>)tabDelegate {
    _tabDelegate = tabDelegate;
    self.tabView.delegate = tabDelegate;
}

- (void)setIndicators:(NSArray *)titles {
    [self.tabView refreshWithTitles: titles];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabView selectItemAtIndex:0 animated:NO];
    });
}


- (void)setContentView:(UICollectionView *)contentView {
    if (_contentView == contentView) {
        return;
    }
    if (_contentView != nil) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    contentView.delegate = self;
    [self addSubview:contentView];
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.vBorder.mas_bottom);
    }];
}

- (UILabel *)vBorder {
    if (_vBorder) {
        return _vBorder;
    }
    
    _vBorder = [UILabel new];
    _vBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    return _vBorder;
}

@end
