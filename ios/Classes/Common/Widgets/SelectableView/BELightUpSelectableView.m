//
//  BELightUpSelectableView.m
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#import "BELightUpSelectableView.h"
#import "Masonry.h"

@implementation BELightUpSelectableConfig
@synthesize imageSize = _imageSize;

+ (instancetype)initWithUnselectImage:(NSString *)unselectImage imageSize:(CGSize)imageSize {
    BELightUpSelectableConfig *config = [self new];
//    config.selectedImageName = selectImage;
    config.unselectedImageName = unselectImage;
    config.imageSize = imageSize;
    return config;
}

- (BELightUpSelectableView *)generateView {
    BELightUpSelectableView *v = [[BELightUpSelectableView alloc] init];
//    v.selectedImageName = self.selectedImageName;
    v.unselectedImageName = self.unselectedImageName;
    return v;
}

@end

@interface BELightUpSelectableView ()

@property (nonatomic, strong) UIImageView *iv;

@end

@implementation BELightUpSelectableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iv];
        
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self);
            make.leading.top.equalTo(self);
        }];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    [super setIsSelected:isSelected];

    self.iv.alpha = isSelected ? 1 : 0.5;
}

//- (void)setSelectedImageName:(NSString *)selectedImageName {
//    _selectedImageName = selectedImageName;
//    
//    if (self.isSelected) {
//        self.iv.image = [UIImage imageNamed:selectedImageName];
//    }
//}

- (void)setUnselectedImageName:(NSString *)unselectedImageName {
    _unselectedImageName = unselectedImageName;
    
    if (!self.isSelected) {
        self.iv.image = [UIImage imageNamed:unselectedImageName];
    }
}

#pragma mark - getter
- (UIImageView *)iv {
    if (!_iv) {
        _iv = [UIImageView new];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
    }
    return _iv;
}

@end
