//
//  BEIconItemCell.m
//  Effect
//
//  Created by qun on 2021/5/25.
//

#import "BEIconItemCell.h"
#import "Masonry.h"
#import <SDWebImage/SDWebImage.h>

static CGFloat const BEModernFilterCellContentPadding = 2.f;

@interface BEIconItemCell ()

@property (nonatomic, strong) UIImageView *ivBorder;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
@property (nonatomic, strong) BEDownloadView *dv;

@end

@implementation BEIconItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.borderLayer];
        [self addSubview:self.iv];
        [self addSubview:self.dv];
        
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self).offset(-2 * BEModernFilterCellContentPadding);
            make.leading.top.equalTo(self).offset(2 * BEModernFilterCellContentPadding);
        }];
        
        [self.dv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.trailing.bottom.equalTo(self).with.offset(-2 * BEModernFilterCellContentPadding - 2);
        }];
        
        _useCellSelectedState = NO;
    }
    return self;
}

- (void)setUseCellSelectedState:(BOOL)useCellSelectedState {
    _useCellSelectedState = useCellSelectedState;
    if (useCellSelectedState) {
        [self setIsSelected:self.selected];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (_useCellSelectedState) {
        [self setIsSelected:selected];
    }
}

- (void)setIsSelected:(BOOL)selected {
    self.borderLayer.hidden = !selected;
    [self setNeedsDisplay];
}

- (void)updateWithIcon:(NSString *)iconName {
    if ([iconName containsString:@"http://"] || [iconName containsString:@"https://"]) {
        [self.iv sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"ic_placeholder"] options:SDWebImageRetryFailed];
    } else {
        self.iv.image = [UIImage imageNamed:iconName];
    }
}

- (void)setDownloadState:(BEDownloadViewState)state {
    _dv.hidden = NO;
    self.dv.state = state;
}

- (void)setDownloadProgress:(CGFloat)progress {
    self.dv.downloadProgress = progress;
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

- (BEDownloadView *)dv {
    if (_dv) {
        return _dv;
    }
    
    _dv = [BEDownloadView new];
    _dv.downloadImage = [UIImage imageNamed:@"ic_to_download"];
    _dv.hidden = YES;
    return _dv;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.frame = self.contentView.bounds;
        _borderLayer.contents = (id)[[UIImage imageNamed:@"ic_select_border"] CGImage];
        _borderLayer.hidden = YES;
    }
    return _borderLayer;
}

@end
