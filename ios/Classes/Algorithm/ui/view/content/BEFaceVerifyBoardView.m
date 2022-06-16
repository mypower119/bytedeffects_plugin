//
//  BEFaceVerifyBoardView.m
//  Algorithm
//
//  Created by qun on 2021/6/1.
//

#import "BEFaceVerifyBoardView.h"
#import "BESelectableButton.h"
#import "BELightUpSelectableView.h"
#import "Masonry.h"
#import "Common.h"

@interface BEFaceVerifyBoardView () <BESelectableButtonDelegate>

@property (nonatomic, strong) BETitleBoardView *titleBoardView;
@property (nonatomic, strong) UIView *vContent;
@property (nonatomic, strong) BESelectableButton *btnClose;
@property (nonatomic, strong) BESelectableButton *btnPicker;

@end

@implementation BEFaceVerifyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:self.titleBoardView];
        self.titleBoardView.boardContentView = self.vContent;
        
//        [self.vContent addSubview:self.btnClose];
        [self.vContent addSubview:self.btnPicker];
        
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.btnPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 60));
            make.center.equalTo(self.vContent);
        }];
//        NSArray *arr = [NSArray arrayWithObjects:self.btnClose, self.btnPicker, nil];
//        [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
//                      withFixedItemLength:60
//                              leadSpacing:100
//                              tailSpacing:100];
//        [arr mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.vContent);
//            make.width.mas_equalTo(80);
//            make.height.mas_equalTo(60);
//        }];
    }
    return self;
}

- (void)setClosed:(BOOL)closed {
    self.btnClose.isSelected = closed;
}

- (void)setDelegate:(id<BEFaceVerifyBoardViewDelegate>)delegate {
    _delegate = delegate;
    
    self.titleBoardView.delegate = delegate;
}

#pragma mark - BESelectableButtonDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    if (button == self.btnClose) {
        BOOL selected = !self.btnClose.isSelected;
        self.btnClose.isSelected = selected;
        [self.delegate faceVerifyView:self didTapClose:button selected:selected];
    } else {
        [self.delegate faceVerifyView:self didTapImagePicker:button];
    }
}

#pragma mark - getter
- (BESelectableButton *)btnClose {
    if (_btnClose) {
        return _btnClose;
    }
    
    _btnClose = [[BESelectableButton alloc]
                 initWithSelectableConfig:
                   [BELightUpSelectableConfig
                    initWithUnselectImage:@"ic_close_highlight"
                    imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    _btnClose.title = NSLocalizedString(@"close", nil);
    _btnClose.delegate = self;
    return _btnClose;
}

- (BESelectableButton *)btnPicker {
    if (_btnPicker) {
        return _btnPicker;
    }
    
    _btnPicker = [[BESelectableButton alloc]
                  initWithSelectableConfig:
                    [BELightUpSelectableConfig
                     initWithUnselectImage:@"ic_upload_normal"
                     imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    _btnPicker.title = NSLocalizedString(@"upload_title", nil);
    _btnPicker.delegate = self;
    return _btnPicker;
}

- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [BETitleBoardView new];
    [_titleBoardView updateBoardTitle:NSLocalizedString(@"feature_face_verify", nil)];
    return _titleBoardView;
}

- (UIView *)vContent {
    if (_vContent) {
        return _vContent;
    }
    _vContent = [UIView new];
    return _vContent;
}

@end
