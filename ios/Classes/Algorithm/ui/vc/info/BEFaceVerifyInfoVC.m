//
//  BEFaceVerifyInfoVC.m
//  Algorithm
//
//  Created by qun on 2021/6/1.
//

#import "BEFaceVerifyInfoVC.h"
#import "BEPropertyTextView.h"
#import "Masonry.h"
#import "Common.h"

static float SIMILARITY_THRESTHOD = 67.6;
@interface BEFaceVerifyInfoVC ()

@property (nonatomic, strong) BEPropertyTextView *ptvSimilarity;
@property (nonatomic, strong) BEPropertyTextView *ptvCostTime;
@property (nonatomic, strong) UILabel *lTip;
@property (nonatomic, strong) UIImageView *iv;

@end

@implementation BEFaceVerifyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.ptvSimilarity];
    [self.view addSubview:self.ptvCostTime];
    [self.view addSubview:self.lTip];
    [self.view addSubview:self.iv];
    
    [self.ptvSimilarity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-ALGORITHM_INFO_LEFT_MARGIN);
        make.top.equalTo(self.view).offset(ALGORITHM_INFO_TOP_MARGIN);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    [self.ptvCostTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.ptvSimilarity);
        make.top.equalTo(self.ptvSimilarity.mas_bottom);
    }];
    [self.lTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.width.height.equalTo(self.ptvSimilarity);
        make.top.equalTo(self.ptvCostTime.mas_bottom);
    }];
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-5);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT + BEF_RESET_BUTTON_BOTTOM_MARGIN));
        make.size.mas_equalTo(CGSizeMake(100, 150));
    }];
    self.view.userInteractionEnabled = NO;
}

- (void)updateFaceVerifyInfo:(double)similarity time:(long)time {
    self.ptvSimilarity.value = [NSString stringWithFormat:@"%.2f", similarity];
    self.ptvCostTime.value = [NSString stringWithFormat:@"%ldms", time];
    
    NSString *info = similarity > SIMILARITY_THRESTHOD ? NSLocalizedString(@"face_verify_same_face", nil) : NSLocalizedString(@"face_verify_not_same_face", nil);
    self.lTip.text = info;
}

- (void)clearFaceVerifyInfo {
    self.ptvSimilarity.value = [NSString stringWithFormat:@"%.2f", 0.f];
    self.ptvCostTime.value = [NSString stringWithFormat:@"%ldms", 0L];
    self.lTip.text = @"";
}

- (void)setSelectedImage:(UIImage *)image {
    self.iv.image = image;
}

- (void)setSelectedImageHidden:(BOOL)hidden {
    self.iv.hidden = hidden;
}

#pragma mark - getter
- (BEPropertyTextView *)ptvSimilarity {
    if (_ptvSimilarity) {
        return _ptvSimilarity;
    }
    
    _ptvSimilarity = [BEPropertyTextView new];
    _ptvSimilarity.title = NSLocalizedString(@"similarity", nil);
    _ptvSimilarity.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    return _ptvSimilarity;
}

- (BEPropertyTextView *)ptvCostTime {
    if (_ptvCostTime) {
        return _ptvCostTime;
    }
    
    _ptvCostTime = [BEPropertyTextView new];
    _ptvCostTime.title = NSLocalizedString(@"cost", nil);
    _ptvCostTime.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    return _ptvCostTime;
}

- (UILabel *)lTip {
    if (_lTip) {
        return _lTip;
    }
    
    _lTip = [UILabel new];
    _lTip.textColor = [UIColor whiteColor];
    _lTip.font = [UIFont systemFontOfSize:13];
    _lTip.textAlignment = NSTextAlignmentCenter;
    _lTip.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    return _lTip;
}

- (UIImageView *)iv {
    if (_iv) {
        return _iv;
    }
    
    _iv = [UIImageView new];
    _iv.contentMode = UIViewContentModeScaleAspectFit;
    return _iv;
}

@end
