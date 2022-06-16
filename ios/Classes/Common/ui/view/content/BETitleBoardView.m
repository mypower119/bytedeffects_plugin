//
//  BETitleBoardView.m
//  Effect
//
//  Created by qun on 2021/5/27.
//

#import "BETitleBoardView.h"
#import "BEDeviceInfoHelper.h"
#import "UIView+BEAdd.h"
#import "Masonry.h"
#import "Common.h"

@interface BETitleBoardView ()

@property (nonatomic, strong) UILabel *lTitle;
@property (nonatomic, strong) UIView *vBorder;
@property (nonatomic, strong) BEBoardBottomView *boardBottomView;

@end

@implementation BETitleBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat BOTTOM_HEIGHT = BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_HEIGHT);
        CGFloat BOTTOM_BOTTOM_MARGIN = BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_BOTTOM_MARGIN);
        CGFloat TITLE_HEIGHT = BEF_DESIGN_SIZE(BEF_SWITCH_TAB_HEIGHT);
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:self.lTitle];
        [self addSubview:self.vBorder];
        [self addSubview:self.boardBottomView];
        
        [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self);
            make.height.mas_equalTo(BEF_DESIGN_SIZE(TITLE_HEIGHT));
        }];
        
        [self.vBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.lTitle.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.boardBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(BOTTOM_HEIGHT);
            make.bottom.equalTo(self).offset(-BOTTOM_BOTTOM_MARGIN);
        }];
    }
    return self;
}

- (void)setBoardContentView:(UIView *)boardContentView {
    if (self.boardContentView != nil) {
        [self.boardContentView removeFromSuperview];
    }
    
    _boardContentView = boardContentView;
    [self addSubview:boardContentView];
    [boardContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.vBorder.mas_bottom);
        make.bottom.equalTo(self.boardBottomView.mas_top);
    }];
}

- (void)updateBoardTitle:(NSString *)title {
    self.lTitle.text = title;
}

- (void)setDelegate:(id<BETitleBoardViewDelegate>)delegate {
    self.boardBottomView.delegate = delegate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self be_roundRect:UIRectCornerTopLeft|UIRectCornerTopRight withSize:CGSizeMake(BEF_DESIGN_SIZE(7), BEF_DESIGN_SIZE(7))];
}

#pragma mark - getter
- (UILabel *)lTitle {
    if (_lTitle) {
        return _lTitle;
    }
    
    _lTitle = [UILabel new];
    _lTitle.textColor = [UIColor whiteColor];
    _lTitle.font = [UIFont systemFontOfSize:15];
    _lTitle.textAlignment = NSTextAlignmentCenter;
    return _lTitle;
}

- (UIView *)vBorder {
    if (_vBorder) {
        return _vBorder;
    }
    
    _vBorder = [UIView new];
    _vBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    return _vBorder;
}

- (BEBoardBottomView *)boardBottomView {
    if (_boardBottomView) {
        return _boardBottomView;
    }
    
    _boardBottomView = [[BEBoardBottomView alloc] init];
    return _boardBottomView;
}

@end
