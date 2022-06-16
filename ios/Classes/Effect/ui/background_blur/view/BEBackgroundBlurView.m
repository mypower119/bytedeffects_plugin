//
//  BEBackgroundBlurView.m
//  Effect
//
//  Created by qun on 2021/5/27.
//

#import "BEBackgroundBlurView.h"
#import "BELightUpSelectableView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEBackgroundBlurView () <BESelectableButtonDelegate>

@property (nonatomic, strong) BETitleBoardView *titleBoardView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation BEBackgroundBlurView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleBoardView];
        
        [self.contentView addSubview:self.bvBackgroundBlur];
        
        [self.bvBackgroundBlur mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 60));
        }];
        
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    self.effectOn = YES;
    return self;
}

- (void)setDelegate:(id<BEBackgroundBlurViewDelegate>)delegate {
    _delegate = delegate;
    
    self.titleBoardView.delegate = delegate;
}

#pragma mark - getter
- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [[BETitleBoardView alloc] init];
    _titleBoardView.boardContentView = self.contentView;
    [_titleBoardView updateBoardTitle:NSLocalizedString(@"sticker_blur_bg", nil)];
    return _titleBoardView;
}

- (UIView *)contentView {
    if (_contentView) {
        return _contentView;
    }
    
    _contentView = [[UIView alloc] init];
    return _contentView;
}

- (BESelectableButton *)bvBackgroundBlur {
    if (_bvBackgroundBlur) {
        return _bvBackgroundBlur;
    }
    
    _bvBackgroundBlur = [[BESelectableButton alloc]
                         initWithSelectableConfig:
                           [BELightUpSelectableConfig
                            initWithUnselectImage:@"ic_background_blur_highlight"
                            imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    _bvBackgroundBlur.title = NSLocalizedString(@"sticker_blur_bg", nil);
    _bvBackgroundBlur.isSelected = YES;
    _bvBackgroundBlur.delegate = self;
    return _bvBackgroundBlur;
}

#pragma mark - BESelectableButtonDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    if (button == self.bvBackgroundBlur) {
        self.effectOn = !self.effectOn;
        [self.bvBackgroundBlur setIsSelected:self.effectOn];
        [self.delegate BackgroundBlurView:self selected:self.effectOn];
    }
}

@end
