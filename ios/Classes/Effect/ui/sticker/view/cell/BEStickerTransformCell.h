//
//  BEStickerTransformCell.h
//  BEEffect
//
//  Created by bytedance on 2022/1/20.
//

#import <UIKit/UIKit.h>
#import "BEStickerItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BEStickerTransformCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) BEStickerTransformPage *transformPage;

@end

NS_ASSUME_NONNULL_END
