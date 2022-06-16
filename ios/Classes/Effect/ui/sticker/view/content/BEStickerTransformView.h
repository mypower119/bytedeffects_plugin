//
//  BEStickTransformView.h
//  BEEffect
//
//  Created by bytedance on 2022/1/19.
//

#import <UIKit/UIKit.h>
#import "BEStickerItem.h"

NS_ASSUME_NONNULL_BEGIN

@class BEStickerTransformView;
@protocol BEStickerTransformViewDelegate <NSObject>

- (void)stickerTransformView:(NSString *)img;

@end

@interface BEStickerTransformView : UIView
//数据源
@property (nonatomic, strong) NSMutableArray<BEStickerTransformPage *> *imgArray;
@property (nonatomic, strong) UIColor *viewColor;//view颜色
@property (nonatomic, assign) NSInteger viewRadius;//view圆角
@property (nonatomic, assign) NSInteger superViewWidth;//父控制器宽度
@property (nonatomic, assign) NSInteger collectionViewLeft;//UICollectionView距左
@property (nonatomic, assign) NSInteger edgeTop;//UICollectionView上边距
@property (nonatomic, assign) NSInteger edgeLeft;//UICollectionView左边距
@property (nonatomic, assign) NSInteger edgeBottom;//UICollectionView下边距
@property (nonatomic, assign) NSInteger edgeRight;//UICollectionView右边距
@property (nonatomic, assign) NSInteger minimumLineSpacing;//UICollectionView左右间距
@property (nonatomic, assign) NSInteger itemWidth;//UICollectionView  item宽度
@property (nonatomic, assign) NSInteger itemHeight;//UICollectionView  item高度
@property (nonatomic, assign) NSInteger addBtnWidth;//addBtn宽度
@property (nonatomic, assign) NSInteger addBtnHeight;//addBtn高度
@property (nonatomic, assign) BOOL deleteAddBtn;//addBtn宽度
@property (nonatomic, weak) id<BEStickerTransformViewDelegate> delegate;

//初始化view
- (void)initStickerTransformView;

- (void)showStickerTransformView;
- (void)hideStickerTransformView;

@end

NS_ASSUME_NONNULL_END
