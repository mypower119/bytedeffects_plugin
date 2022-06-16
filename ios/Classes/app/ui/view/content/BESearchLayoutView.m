//
//  BESearchView.m
//  app
//
//  Created by qun on 2021/6/3.
//

#import "BESearchLayoutView.h"
#import "Masonry.h"
#import "Common.h"

@interface BESearchLayoutView ()

@property (nonatomic, strong) UIImageView *ivSearch;

@end

@implementation BESearchLayoutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BEColorWithRGBHex(0xF2F3F8);
        self.layer.cornerRadius = 5.f;
        
        [self addSubview:self.ivSearch];
        [self addSubview:self.tfSearch];
        
        [self.ivSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.leading.equalTo(self).offset(14);
            make.centerY.equalTo(self);
        }];
        
        [self.tfSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.ivSearch.mas_trailing).offset(10);
            make.trailing.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)setEditEnable:(BOOL)editEnable {
    self.tfSearch.enabled = editEnable;
}

- (BOOL)editEnable {
    return self.tfSearch.enabled;
}

- (void)searchTextFieldDidChanged:(UITextField *)sender {
    [self.delegate searchView:self searchDidChanged:sender.text];
}

#pragma mark - getter
- (UIImageView *)ivSearch {
    if (_ivSearch) {
        return _ivSearch;
    }
    
    _ivSearch = [UIImageView new];
    _ivSearch.image = [UIImage imageNamed:@"ic_search"];
    return _ivSearch;
}

- (UITextField *)tfSearch {
    if (_tfSearch) {
        return _tfSearch;
    }
    
    _tfSearch = [UITextField new];
    _tfSearch.textColor = BEColorWithRGBHex(0x1D2129);
    _tfSearch.font = [UIFont systemFontOfSize:14];
    [_tfSearch addTarget:self action:@selector(searchTextFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    return _tfSearch;
}

@end
