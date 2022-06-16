//
//  BEStickerTransformView.m
//  BEEffect
//
//  Created by bytedance on 2022/1/19.
//

#import "BEStickerTransformView.h"
#import "UICollectionViewCell+BEAdd.h"
#import "BECollectionViewFlowLayout.h"
#import "BEStickerTransformCell.h"
#import "Masonry.h"
#import "Common.h"

#define BE_TransformView_Width self.imgArray.count*(_itemWidth?:48)+(self.imgArray.count>0?self.imgArray.count-1:0)*(_minimumLineSpacing?:BEF_DESIGN_SIZE(10))+(self.deleteAddBtn?0:52)+(self.collectionViewLeft?:8)+(self.edgeRight?:8)

@interface BEStickerTransformView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation BEStickerTransformView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.viewColor?:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.viewRadius?:5;
    }
    return self;
}

- (void)initStickerTransformView {
    
    if (self.imgArray.count<1) {
        self.imgArray = [[NSMutableArray alloc] init];
        [self.imgArray removeAllObjects];
        for (int i=0; i<3; i++) {
            BEStickerTransformPage *transformPage = [[BEStickerTransformPage alloc] init];
            transformPage.logo = [NSString stringWithFormat:@"example_%d",i];
            transformPage.materialImg = [NSString stringWithFormat:@"example_%d",i];
            [self.imgArray addObject:transformPage];
        }
    }
    
    if (BE_TransformView_Width>(self.superViewWidth?:[UIScreen mainScreen].bounds.size.width-76)) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (self.superViewWidth?:[UIScreen mainScreen].bounds.size.width-76), self.frame.size.height);
    }
    else{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BE_TransformView_Width, self.frame.size.height);
    }
    [self addSubview:self.addBtn];
    self.addBtn.hidden = self.deleteAddBtn;
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deleteAddBtn ? 0 : 8);
        make.width.mas_equalTo(self.deleteAddBtn ? 0 : self.addBtnWidth?:44);
        make.height.mas_equalTo(self.addBtnHeight?:48);
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.cv];
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.height.equalTo(self);
        make.left.equalTo(self.addBtn.mas_right).offset(self.collectionViewLeft?:8);
    }];
}

- (void)photoBtnClick:(UIButton *)sender{
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BEStickerTransformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BEStickerTransformCell be_identifier] forIndexPath:indexPath];
    cell.transformPage = self.imgArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.itemWidth?:48, self.itemHeight?:48);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BEStickerTransformPage *transformPage = self.imgArray[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(stickerTransformView:)]) {
        [self.delegate stickerTransformView:transformPage.materialImg];
    }
}

- (void)addBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(stickerTransformView:)]) {
        [self.delegate stickerTransformView:@"addPhoto"];
    }
}
#pragma mark - setter
- (void)setImgArray:(NSMutableArray<BEStickerTransformPage *> *)imgArray {
    _imgArray = imgArray;
}

#pragma mark - getter
- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"icon_jia"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UICollectionView *)cv {
    if (_cv) {
        return _cv;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = _minimumLineSpacing?:BEF_DESIGN_SIZE(10);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(_edgeTop?:0, _edgeLeft?:0, _edgeBottom?:0, _edgeRight?:8);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    contentCollectionView.backgroundColor = [UIColor clearColor];
    contentCollectionView.showsHorizontalScrollIndicator = NO;
    contentCollectionView.showsVerticalScrollIndicator = NO;
    contentCollectionView.pagingEnabled = NO;
    contentCollectionView.dataSource = self;
    contentCollectionView.delegate = self;
    [contentCollectionView registerClass:[BEStickerTransformCell class] forCellWithReuseIdentifier:[BEStickerTransformCell be_identifier]];
    _cv = contentCollectionView;
    return _cv;
}

- (void)showStickerTransformView {
    [UIView animateWithDuration:0.2 delay:0.015 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame = CGRectMake(self.frame.origin.x, [UIScreen mainScreen].bounds.size.height-BEF_FACE_CLUSTER_BOARD_HEIGHT-64, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideStickerTransformView {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, [UIScreen mainScreen].bounds.size.height-BEF_BOARD_BOTTOM_BOTTOM_MARGIN-BEF_BOARD_BOTTOM_HEIGHT-BEF_SWITCH_TAB_HEIGHT-64, self.frame.size.width, self.frame.size.height);
    }];
}

@end
