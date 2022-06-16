//
//  BETopBarView.m
//  app
//
//  Created by qun on 2021/6/3.
//

#import "BETopBarView.h"
#import "BESearchLayoutView.h"
#import "Masonry.h"
#import "Common.h"

@interface BETopBarView ()

@property (nonatomic, strong) UIButton *btnQRScan;
@property (nonatomic, strong) BESearchLayoutView *searchView;

@end

@implementation BETopBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchView];
        [self addSubview:self.btnQRScan];
        
        [self.btnQRScan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.trailing.equalTo(self).offset(-16);
            make.centerY.equalTo(self);
        }];
        
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(16);
            make.trailing.equalTo(self.btnQRScan.mas_leading).offset(-20);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
        }];
    }
    return self;
}

- (void)topBarDidTap:(NSObject *)sender {
    if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        [self.delegate topBarView:self didTapSearch:self.searchView];
    } else if (sender == self.btnQRScan) {
        [self.delegate topBarView:self didTapQRScan:self.btnQRScan];
    }
}

#pragma mark - getter
- (BESearchLayoutView *)searchView {
    if (_searchView) {
        return _searchView;
    }
    
    _searchView = [BESearchLayoutView new];
    _searchView.tfSearch.enabled = NO;
    _searchView.tfSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"feature_beauty", nil) attributes:@{NSForegroundColorAttributeName: BEColorWithRGBHex(0xC9CDD4)}];
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topBarDidTap:)];
    [_searchView addGestureRecognizer:gr];
    return _searchView;
}

- (UIButton *)btnQRScan {
    if (_btnQRScan) {
        return _btnQRScan;
    }
    
    _btnQRScan = [UIButton new];
    [_btnQRScan setImage:[UIImage imageNamed:@"ic_qrscan"] forState:UIControlStateNormal];
    [_btnQRScan addTarget:self action:@selector(topBarDidTap:) forControlEvents:UIControlEventTouchUpInside];
    return _btnQRScan;
}

@end
