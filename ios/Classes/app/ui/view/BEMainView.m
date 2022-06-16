//
//  BEMainView.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEMainView.h"
#import "Masonry.h"

static CGFloat BANNER_HEIGHT = 200;
static CGFloat TAB_HEIGHT = 60;
static CGFloat TOP_TOP = 40;
static CGFloat TOP_HEIGHT = 16;

@interface BEMainView ()

/// 顶部搜索栏，已隐藏
@property (nonatomic, strong) BETopBarView *vTopBar;

/// banner 栏
@property (nonatomic, strong) UIView *vBanner;

/// 各模块 tab 栏
@property (nonatomic, strong) UIView *vTabBar;

/// 功能列表栏
@property (nonatomic, readonly) UICollectionView *cvFeatures;

/// 装配 cvFeatures 的适配器
@property (nonatomic, strong) BEMainCVAdapter *adapter;

/// 在 cvFeatures 中充当 header 的角色，内含 vBanner vTabBar
@property (nonatomic, strong) UIView *headerView;

@end

@implementation BEMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        
        [self.headerView addSubview:self.vBanner];
        [self.headerView addSubview:self.vTabBar];
        
        [self.vBanner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.headerView).offset(16);
            make.trailing.equalTo(self.headerView).offset(-16);
            make.top.equalTo(self.headerView);
            make.height.mas_equalTo(BANNER_HEIGHT);
        }];
        
        [self.vTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.width.equalTo(self.headerView);
            make.top.equalTo(self.vBanner.mas_bottom);
            make.height.mas_equalTo(TAB_HEIGHT);
        }];
        
        [self addSubview:self.vTopBar];
        [self addSubview:self.cvFeatures];
        
        self.vTopBar.alpha = 0;
        [self.vTopBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.width.equalTo(self);
            make.top.equalTo(self).with.offset(TOP_TOP);
            make.height.mas_equalTo(TOP_HEIGHT);
        }];
        
        [self.cvFeatures mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.top.equalTo(self.vTopBar.mas_bottom);
        }];
        
//        [self addSubview:self.vTopBar];
//        [self addSubview:self.sv];
//        [self.sv addSubview:self.cvFeatures];
//        [self.sv addSubview:self.vTabBar];
//        [self.sv addSubview:self.vBanner];
        
//        self.vTopBar.alpha = 0;
//        [self.vTopBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.width.equalTo(self);
//            make.top.equalTo(self).with.offset(TOP_TOP);
//            make.height.mas_equalTo(TOP_HEIGHT);
//        }];
        
//        [self.sv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.bottom.equalTo(self);
//            make.top.equalTo(self.vTopBar.mas_bottom);
//            make.bottom.equalTo(self.cvFeatures.mas_bottom);
//        }];
        
//        [self.cvFeatures mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.equalTo(self);
//            make.top.equalTo(self);
//            make.bottom.equalTo(self);
//        }];
    }
    return self;
}

- (void)setDelegate:(id<BEMainDelegate>)delegate {
    _delegate = delegate;
    
    self.adapter.delegate = delegate;
    self.vTopBar.delegate = delegate;
}

#pragma mark - setter
- (void)setFeatureItems:(NSArray<BEFeatureGroup *> *)featureItems {
    _featureItems = featureItems;
    self.adapter.featureItems = featureItems;
}

#pragma mark - getter
- (BETopBarView *)vTopBar {
    if (_vTopBar == nil) {
        BETopBarView *v = [BETopBarView new];
        _vTopBar = v;
        return v;
    }
    return _vTopBar;
}

- (UIView *)vBanner {
    if (_vBanner == nil) {
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"banner"];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.cornerRadius = 4;
        iv.clipsToBounds = YES;
        _vBanner = iv;
    }
    return _vBanner;
}

- (UIView *)vTabBar {
    if (_vTabBar == nil) {
        _vTabBar = self.adapter.tabView;
        _vTabBar.backgroundColor = [UIColor whiteColor];
        _vTabBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _vTabBar.layer.shadowOpacity = 0.1f;
        _vTabBar.layer.shadowRadius = 2.f;
        _vTabBar.layer.shadowOffset = CGSizeMake(0, 3.f);
    }
    return _vTabBar;
}

- (BEMainCVAdapter *)adapter {
    if (_adapter == nil) {
        BEMainCVAdapter *adapter = [[BEMainCVAdapter alloc] init];
        adapter.headerView = self.headerView;
        adapter.minHeaderHeight = TAB_HEIGHT;
        adapter.maxHeaderHeight = TAB_HEIGHT + BANNER_HEIGHT;
        _adapter = adapter;
    }
    return _adapter;
}

- (UICollectionView *)cvFeatures {
    return self.adapter.collectionView;
}

- (UIView *)headerView {
    if (_headerView) {
        return _headerView;
    }
    
    _headerView = [UIView new];
    _headerView.frame = CGRectMake(0, 0, self.frame.size.width, TAB_HEIGHT + BANNER_HEIGHT);
    _headerView.backgroundColor = [UIColor whiteColor];
    return _headerView;
}

//- (UIScrollView *)sv {
//    if (_sv == nil) {
//        BENestedScrollParentDelegate *sv = [[BENestedScrollParentDelegate alloc] init];
//        sv.showsVerticalScrollIndicator = NO;
//        sv.child = self.adapter;
//        sv.dragCriticalY = BANNER_HEIGHT;
//        [(BENestedScrollChildDelegate *)self.adapter setParent:sv];
//        _sv = sv;
//    }
//    return _sv;
//}

@end
