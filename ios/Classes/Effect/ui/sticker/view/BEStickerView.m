//
//  BEStickerView.m
//  BEEffect
//
//  Created by qun on 2021/10/22.
//

#import "BEStickerView.h"
#import "BEBoardBottomView.h"
#import "BETabStickerPickerView.h"
#import "BEDeviceInfoHelper.h"
#import "UIView+BEAdd.h"
#import "Masonry.h"
#import "Common.h"

@interface BEStickerView ()

@property (nonatomic, strong) BEBoardBottomView *boardBottomView;
@property (nonatomic, strong) BETabStickerPickerView *stickerView;

@end

@implementation BEStickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:self.stickerView];
        [self addSubview:self.boardBottomView];
        
        CGFloat BOARD_BOTTOM_HEIGHT = BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_HEIGHT);
        CGFloat BOARD_BOTTOM_MARGIN = BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_BOTTOM_MARGIN);
        
        [self.boardBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(BOARD_BOTTOM_HEIGHT);
            make.bottom.equalTo(self).offset(-BOARD_BOTTOM_MARGIN);
        }];
        
        [self.stickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self);
            make.bottom.equalTo(self.boardBottomView.mas_top);
        }];
    }
    return self;
}

- (void)setGroups:(NSArray<BEStickerGroup *> *)groups {
    [self.stickerView setGroups:groups];
}

- (void)setDelegate:(id<BEStickerViewDelegate>)delegate {
    self.stickerView.delegate = delegate;
    self.boardBottomView.delegate = delegate;
}

- (void)setSelectItem:(BEStickerItem *)selectItem {
    self.stickerView.selectItem = selectItem;
}

- (void)setSelectTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath {
    [self.stickerView setSelectTabIndex:tabIndexPath withTabContentIndex:contentIndexPath];
}

- (void)refreshTabIndex:(NSIndexPath *)tabIndexPath withTabContentIndex:(NSIndexPath *)contentIndexPath {
    [self.stickerView refreshTabIndex:tabIndexPath withTabContentIndex:contentIndexPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self be_roundRect:UIRectCornerTopLeft|UIRectCornerTopRight withSize:CGSizeMake(BEF_DESIGN_SIZE(7), BEF_DESIGN_SIZE(7))];
}

#pragma mark - getter
- (BEBoardBottomView *)boardBottomView {
    if (_boardBottomView) {
        return _boardBottomView;
    }
    
    _boardBottomView = [[BEBoardBottomView alloc] init];
    return _boardBottomView;
}

- (BETabStickerPickerView *)stickerView {
    if (_stickerView) {
        return _stickerView;
    }
    _stickerView = [[BETabStickerPickerView alloc] init];
    return _stickerView;
}

@end
