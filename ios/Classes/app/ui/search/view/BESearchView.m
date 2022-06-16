//
//  BESearchView.m
//  app
//
//  Created by qun on 2021/6/10.
//

#import "BESearchView.h"
#import "BESearchHistoryAdapter.h"
#import "BESearchResultAdapter.h"
#import "Masonry.h"
#import "Common.h"

@interface BESearchView ()

@property (nonatomic, strong) BESearchLayoutView *searchView;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UILabel *lSearchHistory;
@property (nonatomic, strong) UIButton *btnClearHistory;
@property (nonatomic, strong) BESearchHistoryAdapter *historyAdapter;
@property (nonatomic, strong) BESearchResultAdapter *resultAdapter;

@end

@implementation BESearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchView];
        [self addSubview:self.btnCancel];
        [self addSubview:self.lSearchHistory];
        [self addSubview:self.btnClearHistory];
        
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailingMargin.mas_equalTo(-16);
            make.centerY.equalTo(self.searchView);
        }];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.mas_equalTo(16);
            make.leadingMargin.mas_equalTo(16);
            make.trailing.equalTo(self.btnCancel.mas_leading).offset(-16);
            make.height.mas_equalTo(44);
        }];
        
        [self.lSearchHistory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leadingMargin.mas_equalTo(16);
            make.top.equalTo(self.searchView.mas_bottom).offset(16);
        }];
        [self.btnClearHistory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lSearchHistory);
            make.trailingMargin.mas_equalTo(-16);
        }];
    }
    return self;
}

- (void)setDelegate:(id<BESearchViewDelegate>)delegate {
    _delegate = delegate;
    
    self.searchView.delegate = delegate;
}

- (void)searchViewDidTap:(UIView *)sender {
    if (sender == self.btnCancel) {
        [self.delegate searchView:self didTapCancel:sender];
    }
}

#pragma mark - getter
- (BESearchLayoutView *)searchView {
    if (_searchView) {
        return _searchView;
    }
    
    _searchView = [BESearchLayoutView new];
    _searchView.tfSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"please_input_text_to_search", nil) attributes:@{NSForegroundColorAttributeName: BEColorWithRGBHex(0xC9CDD4)}];
    return _searchView;
}

- (UIButton *)btnCancel {
    if (_btnCancel) {
        return _btnCancel;
    }
    
    _btnCancel = [UIButton new];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnCancel setTitleColor:BEColorWithRGBHex(0x165DFF) forState:UIControlStateNormal];
    [_btnCancel setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(searchViewDidTap:) forControlEvents:UIControlEventTouchUpInside];
    return _btnCancel;
}

- (UILabel *)lSearchHistory {
    if (_lSearchHistory) {
        return _lSearchHistory;
    }
    
    _lSearchHistory = [UILabel new];
    _lSearchHistory.text = NSLocalizedString(@"search_history", nil);
    _lSearchHistory.font = [UIFont boldSystemFontOfSize:14];
    _lSearchHistory.textColor = BEColorWithRGBHex(0x86909C);
    return _lSearchHistory;
}

- (UIButton *)btnClearHistory {
    if (_btnClearHistory) {
        return _btnClearHistory;
    }
    
    _btnClearHistory = [UIButton new];
    [_btnClearHistory setTitle:NSLocalizedString(@"clear_history", nil) forState:UIControlStateNormal];
    [_btnClearHistory setTitleColor:BEColorWithRGBHex(0x86909C) forState:UIControlStateNormal];
    _btnClearHistory.titleLabel.font = [UIFont systemFontOfSize:10];
    [_btnClearHistory addTarget:self action:@selector(searchViewDidTap:) forControlEvents:UIControlEventTouchUpInside];
    return _btnClearHistory;
}

@end
