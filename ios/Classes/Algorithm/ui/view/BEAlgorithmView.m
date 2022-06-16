//
//  BEAlgorithmView.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEAlgorithmView.h"
#import "BEAlgorithmScrollableButtonView.h"
#import "Masonry.h"

@interface BEAlgorithmView () {
    BEAlgorithmButtonView *_buttonView;
}

@property (nonatomic, strong) BETitleBoardView *titleBoardView;

@end

@implementation BEAlgorithmView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        [self addSubview:self.titleBoardView];
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setItem:(BEAlgorithmItem *)item selectSet:(NSMutableSet<BEAlgorithmKey *> *)selectSet {
    BEAlgorithmButtonView *buttonView = [self buttonView:item];
    buttonView.selectSet = selectSet;
    buttonView.item = item;
    buttonView.delegate = self.delegate;
    self.titleBoardView.boardContentView = buttonView;
    [self.titleBoardView updateBoardTitle:NSLocalizedString(item.title, nil)];
}

- (void)setContentView:(UIView *)contentView title:(NSString *)title {
    self.titleBoardView.boardContentView = contentView;
    [self.titleBoardView updateBoardTitle:title];
}

- (void)setDelegate:(id<BEAlgorithmViewDelegate>)delegate {
    _delegate = delegate;
    
    self.titleBoardView.delegate = delegate;
}

#pragma mark - getter
- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [BETitleBoardView new];
    return _titleBoardView;
}

- (BEAlgorithmButtonView *)buttonView:(BEAlgorithmItem *)item {
    if (_buttonView) {
        return _buttonView;
    }
    
    if ([item isKindOfClass:[BEAlgorithmItemGroup class]] && [(BEAlgorithmItemGroup *)item scrollable]) {
        _buttonView = [BEAlgorithmScrollableButtonView new];
    } else {
        _buttonView = [BEAlgorithmButtonView new];
    }
    
    return _buttonView;
}

@end
