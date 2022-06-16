//
//  BEStickerTransformCell.m
//  BEEffect
//
//  Created by bytedance on 2022/1/20.
//

#import "BEStickerTransformCell.h"
#import "Masonry.h"

@implementation BEStickerTransformCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.itemImg];
        [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.itemImg.layer.cornerRadius = 2.5;
        self.itemImg.layer.masksToBounds = YES;
    }
    return self;
}

- (UIImageView *)itemImg {
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] init];
    }
    return _itemImg;
}

- (void)setTransformPage:(BEStickerTransformPage *)transformPage {
    self.itemImg.image = [UIImage imageNamed:transformPage.logo];
}

@end
