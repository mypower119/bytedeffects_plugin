// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <UIKit/UIKit.h>

@interface BESwitchIndicatorLineStyle : NSObject

@property (nonatomic, assign) NSInteger bottomMargin;
@property (nonatomic, assign) CGFloat widthRatio;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;

@end

@protocol BEEffectSwitchTabViewDelegate <NSObject>

- (void)switchTabDidSelectedAtIndex:(NSInteger)index;

@end
@interface BEEffectSwitchTabView: UIView <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<BEEffectSwitchTabViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, assign) float proportion;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSDictionary *categoryNameDict;
@property (nonatomic, strong) UIView *indicatorLine;
@property (nonatomic, strong) BESwitchIndicatorLineStyle *indicatorLineStyle;

@property (nonatomic, strong) UIColor *hightlightTextColor;
@property (nonatomic, strong) UIColor *normalTextColor;

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;


- (instancetype)initWithTitles:(NSArray *)categories;
- (void)refreshWithTitles:(NSArray *)categories;

@end












