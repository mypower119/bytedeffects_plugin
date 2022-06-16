//
//  BEMattingStickerView.m
//  Effect
//
//  Created by qun on 2021/5/27.
//

#import "BEMattingStickerView.h"
#import "BESelectableButton.h"
#import "BELightUpSelectableView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEMattingStickerView () <BESelectableButtonDelegate>

@property (nonatomic, strong) BETitleBoardView *titleBoardView;
@property (nonatomic, strong) BESelectableButton *bvClose;
@property (nonatomic, strong) BESelectableButton *bvUpload;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation BEMattingStickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self.contentView addSubview:self.bvClose];
        [self.contentView addSubview:self.bvUpload];
        [self addSubview:self.titleBoardView];
        
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.bvUpload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 60));
        }];
//        NSArray<UIView *> *arr = [NSArray arrayWithObjects:self.bvClose, self.bvUpload, nil];
//        [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
//                      withFixedItemLength:60
//                              leadSpacing:100
//                              tailSpacing:100];
//        [arr mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(65);
//            make.centerY.equalTo(self.contentView);
//        }];
    }
    return self;
}

- (void)setDelegate:(id<BEMattingStickerViewDelegate>)delegate {
    _delegate = delegate;
    
    self.titleBoardView.delegate = delegate;
}

#pragma mark - BESelectableButtonDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    if (button == self.bvClose) {
        button.isSelected = !button.isSelected;
        [self.delegate mattingStickerView:self didTapClose:button selected:self.bvClose.isSelected];
    } else {
        [self.delegate mattingStickerView:self didTapUplaod:button selected:self.bvClose.isSelected];
    }
}

#pragma mark - getter
- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [[BETitleBoardView alloc] init];
    _titleBoardView.boardContentView = self.contentView;
    [_titleBoardView updateBoardTitle:NSLocalizedString(@"sticker_matting_bg", nil)];
    return _titleBoardView;
}

- (UIView *)contentView {
    if (_contentView) {
        return _contentView;
    }
    
    _contentView = [[UIView alloc] init];
    return _contentView;
}

- (BESelectableButton *)bvClose {
    if (_bvClose) {
        return _bvClose;
    }
    
    _bvClose = [[BESelectableButton alloc]
                initWithSelectableConfig:
                  [BELightUpSelectableConfig
                   initWithUnselectImage:@"iconCloseButtonSelected"
                   imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    _bvClose.title = NSLocalizedString(@"close", nil);
    _bvClose.delegate = self;
    return _bvClose;
}

- (BESelectableButton *)bvUpload {
    if (_bvUpload) {
        return _bvUpload;
    }
    
    _bvUpload = [[BESelectableButton alloc]
                 initWithSelectableConfig:
                   [BELightUpSelectableConfig
                    initWithUnselectImage:@"ic_upload"
                    imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    _bvUpload.title = NSLocalizedString(@"upload_image", nil);
    _bvUpload.delegate = self;
    return _bvUpload;
}

@end
