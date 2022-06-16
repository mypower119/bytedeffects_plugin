//
//  BELensView.m
//  Lens
//
//  Created by wangliu on 2021/6/2.
//


#import "BELensView.h"
#import "BELightUpSelectableView.h"
#import "Masonry.h"
#import "Common.h"

@interface BELensView ()

@property (nonatomic, strong) BETitleBoardView *titleBoardView;
@property (nonatomic, strong) BESelectableButton *buttonView;
@property (nonatomic, strong) UIView *contanier;

@end

@implementation BELensView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        [self addSubview:self.titleBoardView];
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.titleBoardView.boardContentView = self.contanier;
        
        [self.contanier addSubview:self.buttonView];
        
        [self.buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(BEF_DESIGN_SIZE(66), BEF_DESIGN_SIZE(66)));
            make.center.equalTo(self.contanier);
        }];
    }
    return self;
}

- (void)setItem:(BEButtonItem *)item {
    [self.titleBoardView updateBoardTitle:NSLocalizedString(item.title, nil)];
    
    [self.buttonView setSelectableConfig:[BELightUpSelectableConfig
                                          initWithUnselectImage:item.selectImg
                                          imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
    self.buttonView.title = NSLocalizedString(item.title, nil);
}

- (void)setIsOpen:(BOOL)isOpen {
    self.buttonView.isSelected = isOpen;
}

- (BOOL)isOpen {
    return self.buttonView.isSelected;
}

- (void)setDelegate:(id<BELensViewDelegate>)delegate {
    _delegate = delegate;
    
    self.titleBoardView.delegate = delegate;
    self.buttonView.delegate = delegate;
}

#pragma mark - getter
- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [BETitleBoardView new];
    return _titleBoardView;
}

- (UIView *)contanier {
    if (_contanier) {
        return _contanier;
    }
    
    _contanier = [UIView new];
    return _contanier;
}

- (BESelectableButton *)buttonView {
    if (_buttonView) {
        return _buttonView;
    }
    
    _buttonView = [BESelectableButton new];
    return _buttonView;
}

@end
