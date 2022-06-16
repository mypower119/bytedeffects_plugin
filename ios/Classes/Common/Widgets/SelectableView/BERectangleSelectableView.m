//
//  BERectangleSelectableView.m
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#import "BERectangleSelectableView.h"
#import "Masonry.h"
#import <SDWebImage/SDWebImage.h>

static CGFloat const BERectangleSelectableViewPadding = 2.f;

@implementation BERectangleSelectableConfig

@synthesize imageSize = _imageSize;

+ (instancetype)initWithImageName:(NSString *)imageName imageSize:(CGSize)imageSize {
    BERectangleSelectableConfig *config = [[self alloc] init];
    config.imageName = imageName;
    config.imageSize = imageSize;
    return config;
}

- (BERectangleSelectableView *)generateView {
    BERectangleSelectableView *v = [[BERectangleSelectableView alloc] init];
    if ([self.imageName containsString:@"http://"] || [self.imageName containsString:@"https://"]) {
        [v.iv sd_setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:[UIImage imageNamed:@"ic_placeholder"] options:SDWebImageRetryFailed];
    } else {
        v.iv.image = [UIImage imageNamed:self.imageName];
    }
    return v;
}

@end

@interface BERectangleSelectableView ()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation BERectangleSelectableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.borderLayer];
        [self addSubview:self.iv];
        
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self).offset(-1.5 * BERectangleSelectableViewPadding);
            make.leading.top.equalTo(self).offset(1.5 * BERectangleSelectableViewPadding);
            make.width.height.mas_equalTo(60);
        }];
        self.iv.layer.masksToBounds = YES;
        self.iv.layer.cornerRadius = 2;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    [super setIsSelected:isSelected];
    
    self.borderLayer.hidden = !isSelected;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.borderLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark getter
- (UIImageView *)iv {
    if (!_iv) {
        _iv = [UIImageView new];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
    }
    return _iv;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.frame = self.bounds;
        _borderLayer.contents = (id)[[UIImage imageNamed:@"ic_select_border"] CGImage];
        _borderLayer.hidden = YES;
    }
    return _borderLayer;
}

@end
