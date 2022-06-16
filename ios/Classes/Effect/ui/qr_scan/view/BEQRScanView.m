//
//  BEQRScanView.m
//  Effect
//
//  Created by qun on 2021/6/3.
//

#import "BEQRScanView.h"
#import "BEScanView.h"
#import "Masonry.h"
#import "CommonSize.h"

@interface BEQRScanView ()

@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UIView *vTopBar;
@property (nonatomic, strong) BEScanView *scanView;
@property (nonatomic, strong) UILabel *lTip;
@property (nonatomic, strong) BETextSliderView *sliderView;

@end

@implementation BEQRScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat TOP_BUTTON_WIDTH = BEF_DESIGN_SIZE(BEF_TOP_BUTTON_WIDTH);
        CGFloat TOP_HEIGHT = BEF_DESIGN_SIZE(44);
        
        [self addSubview:self.scanView];
        [self addSubview:self.vTopBar];
        [self addSubview:self.btnBack];
        [self addSubview:self.lTip];
        
        [self.vTopBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(TOP_HEIGHT);
            make.top.equalTo(self).offset(BEDeviceInfoHelper.statusBarHeight);
        }];
        [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(TOP_BUTTON_WIDTH);
            make.leadingMargin.mas_equalTo(30);
            make.centerY.equalTo(self.vTopBar);
        }];
        
        [self.lTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(self.frame.size.height / 3 * 2 + 16);
        }];
    }
    return self;
}

- (void)hideQRView:(BOOL)hidden {
    self.scanView.hidden = hidden;
    self.lTip.hidden = hidden;
}

- (void)hideSliderView:(BOOL)hidden defaultProgress:(CGFloat)progress {
    if (hidden) {
        if (_sliderView) {
            [_sliderView removeFromSuperview];
        }
    } else {
        self.sliderView.progress = progress;
        [self addSubview:self.sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.leading.equalTo(self).offset(75);
            make.trailing.equalTo(self).offset(-75);
            make.height.mas_equalTo(200);
            make.bottom.equalTo(self).offset(BEDeviceInfoHelper.isIPhoneXSeries ? -85 : -44);
        }];
    }
}

- (void)qrScanDidTap:(UIView *)sender {
    [self.delegate qrScanView:self didTapBack:sender];
}

//  {zh} BEQRScanView 本身不拦截事件，将其透传到自己的下一层去  {en} BEQRScanView itself does not block events, pass them through to its next level
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (v == self) {
        return nil;
    }
    return v;
}

- (void)setDelegate:(id<BEQRScanViewDelegate>)delegate {
    _delegate = delegate;
    if (_sliderView) {
        _sliderView.delegate = delegate;
    }
}

#pragma mark - getter
- (UIButton *)btnBack {
    if (_btnBack) {
        return _btnBack;
    }
    
    _btnBack = [UIButton new];
    [_btnBack setImage:[UIImage imageNamed:@"ic_arrow_left"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(qrScanDidTap:) forControlEvents:UIControlEventTouchUpInside];
    return _btnBack;
}

- (BEScanView *)scanView {
    if (_scanView) {
        return _scanView;
    }
    
    int length = self.frame.size.height / 3;
    int x = (self.frame.size.width - length) / 2;
    int y = (self.frame.size.height - length) / 2;
    int width = length;
    int height = length;
    _scanView = [[BEScanView alloc] initWithFrame:self.frame qrRect:CGRectMake(x, y, width, height)];
    
    return _scanView;
}

- (UIView *)vTopBar {
    if (_vTopBar) {
        return _vTopBar;
    }
    
    UILabel *l = [UILabel new];
    l.text = NSLocalizedString(@"feature_qr_scan", nil);
    l.font = [UIFont systemFontOfSize:16];
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    _vTopBar = l;
    return _vTopBar;
}

- (UILabel *)lTip {
    if (_lTip) {
        return _lTip;
    }
    
    _lTip = [UILabel new];
    _lTip.text = NSLocalizedString(@"scan_qr_code", nil);
    _lTip.font = [UIFont systemFontOfSize:15];
    _lTip.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    return _lTip;
}

- (BETextSliderView *)sliderView {
    if (_sliderView) {
        return _sliderView;
    }
    
    _sliderView = [[BETextSliderView alloc] init];
    _sliderView.delegate = self.delegate;
    _sliderView.backgroundColor = [UIColor clearColor];
    return _sliderView;
}

@end
