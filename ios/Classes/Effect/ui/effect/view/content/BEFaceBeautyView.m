//
//  BEFaceBeautyView.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "BEFaceBeautyView.h"

#import "Masonry.h"

#import "BESelectableCell.h"
#import "BELightUpSelectableView.h"
#import "BERectangleSelectableView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "BECollectionViewFlowLayout.h"
#import "BEEffectResponseModel.h"
#import "Effect.h"
#import "Common.h"

@interface BEFaceBeautyView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) BEEffectItem *item;
@property (nonatomic, strong, readonly) NSArray<BEEffectItem *> *items;
@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@end


@implementation BEFaceBeautyView

#pragma mark - public
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cv];
        [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.centerY.equalTo(self);
            make.height.mas_equalTo(BEF_DESIGN_SIZE(66));
        }];
    }
    return self;
}

- (void)setTitleType:(NSString *)titleType {
    _titleType = titleType;
    if ([titleType isEqualToString:BEEffectAr_hair_color] || [titleType isEqualToString:BEEffectAr_try_lipstick]) {
        [self.cv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(BEF_DESIGN_SIZE(97));
            make.leading.trailing.equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
        
    }
}

- (void)setItem:(BEEffectItem *)item {
    _item = item;
    
    [self.cv reloadData];
    [self resetSelect];
}

- (void)resetSelect {
    if (self.selectIndex != nil) {
        [self.cv deselectItemAtIndexPath:self.selectIndex animated:NO];
    }
    int selectIndex = 0;
    for (int i = 0; i < self.items.count; i++) {
        if (self.items[i] == self.item.selectChild) {
            selectIndex = i;
        }
    }
    self.selectIndex = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    [self.cv selectItemAtIndexPath:self.selectIndex animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
}

- (void)cleanSelect {
    self.selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.item.selectChild = nil;
    [self.cv reloadData];
    [self.cv selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.delegate onItemClean:YES];
}

- (void)hiddenColorListAdapter:(BOOL)isHidden {
    [self.delegate onItemClean:isHidden];
}

- (void)onClose {
    self.item.selectChild = nil;
    [self.cv reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex != indexPath) {
        [self.cv deselectItemAtIndexPath:self.selectIndex animated:NO];
    }
    self.selectIndex = indexPath;
    [self.delegate onItemSelect:self.items[indexPath.row]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titleType isEqualToString:BEEffectAr_hair_color] || [self.titleType isEqualToString:BEEffectAr_try_lipstick]) {
        return CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(97));
    }
    return CGSizeMake(BEF_DESIGN_SIZE(60), BEF_DESIGN_SIZE(60));
}

#pragma mark - UICollectionViewDataSource
-(NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEEffectItem *item = self.items[indexPath.row];
    BESelectableCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:[BESelectableCell be_identifier] forIndexPath:indexPath];
    if ([self.titleType isEqualToString:BEEffectAr_hair_color] || [self.titleType isEqualToString:BEEffectAr_try_lipstick]) {
        [c setSelectableConfig:[BERectangleSelectableConfig
                                   initWithImageName:item.selectImg imageSize:CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(66))]];
    }
    else {
        [c setSelectableConfig:[BELightUpSelectableConfig
                                initWithUnselectImage:item.selectImg
                                imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
        item.cell = c;
        [item updateState];
    }
    if ([self.titleType isEqualToString:BEEffectAr_hair_color]) {
        item.cell = c;
    }
    c.selectableButton.title = item.title;
    c.useCellSelectedState = YES;
    

    return c;
}

#pragma mark - getter
- (UICollectionView *)cv {
    if (!_cv) {
        UICollectionViewFlowLayout *fl = [BECollectionViewFlowLayout new];
        fl.sectionInset = UIEdgeInsetsMake(0, BEF_DESIGN_SIZE(16), 0, BEF_DESIGN_SIZE(16));
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        fl.minimumLineSpacing = BEF_DESIGN_SIZE(20);
//        fl.minimumInteritemSpacing = BEF_DESIGN_SIZE(120);
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        [_cv registerClass:[BESelectableCell class] forCellWithReuseIdentifier:[BESelectableCell be_identifier]];
        _cv.backgroundColor = [UIColor clearColor];
        _cv.showsHorizontalScrollIndicator = NO;
        _cv.showsVerticalScrollIndicator = NO;
        _cv.allowsMultipleSelection = NO;
        _cv.dataSource = self;
        _cv.delegate = self;
    }
    return _cv;
}

- (NSArray<BEEffectItem *> *)items {
    if (self.item.children) {
        return self.item.children;
    }
    return [NSArray arrayWithObject:self.item];
}

@end
