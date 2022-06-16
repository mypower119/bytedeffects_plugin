//
//  BEStyleMakeupView.m
//  Effect
//
//  Created by qun on 2021/5/26.
//

#import "BEStyleMakeupView.h"
#import "Masonry.h"
#import "Common.h"

static CGFloat SWITCH_ITEM_INTERVAL = 16;

@interface BEStyleMakeupView ()

@property (nonatomic, strong) BETextSliderView *textSlider;
@property (nonatomic, strong) BEItemPickerView *pickerView;
@property (nonatomic, strong) BETextSwitchView *switchView;
@property (nonatomic, strong) BETitleBoardView *titleBoardView;
@property (nonatomic, strong) UIView *vBoard;

@end

@implementation BEStyleMakeupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat TEXT_SLIDE_HEIGHT = BEF_DESIGN_SIZE(BEF_SLIDE_HEIGHT);
        CGFloat TEXT_SLIDE_BOTTOM_MARGIN = BEF_DESIGN_SIZE(BEF_SLIDE_BOTTOM_MARGIN);
        
        [self addSubview:self.switchView];
        [self addSubview:self.textSlider];
        [self addSubview:self.titleBoardView];
        
        [self.textSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.mas_equalTo(TEXT_SLIDE_HEIGHT);
            make.leading.equalTo(self.switchView.mas_trailing).offset(10);
            make.trailing.equalTo(self).offset(-50);
        }];
        
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.height.mas_equalTo(55);
            make.width.mas_equalTo(90);
            make.bottom.equalTo(self.textSlider).offset(-4);
        }];
        
        [self.titleBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.top.equalTo(self.textSlider.mas_bottom).offset(TEXT_SLIDE_BOTTOM_MARGIN);
        }];
        
    }
    return self;
}

- (void)setItem:(BEEffectItem *)item {
    [self.titleBoardView updateBoardTitle:item.title];
    [self.pickerView setItems:item.children];
}

- (void)setSelectItem:(BEEffectItem *)item {
    [self.pickerView setSelectItem:item];
}

- (void)setSwitchTextItems:(NSArray<BETextSwitchItem *> *)switchTextItems {
    self.switchView.items = switchTextItems;
    
    CGFloat totalWidth = 0.f;
    for (BETextSwitchItem *item in switchTextItems) {
        totalWidth += item.minTextWidth + 8;
    }
    totalWidth += SWITCH_ITEM_INTERVAL * (switchTextItems.count - 1);
    [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(totalWidth);
        make.leading.equalTo(self).offset(10);
        make.height.mas_equalTo(55);
        make.bottom.equalTo(self.textSlider).offset(-4);
    }];
}

- (void)setDelegate:(id<BEStyleMakeupViewDelegate>)delegate {
    self.switchView.delegate = delegate;
    self.pickerView.delegate = delegate;
    self.textSlider.delegate = delegate;
    self.titleBoardView.delegate = delegate;
}

- (void)updateSlideProgress:(float)progress {
    self.textSlider.progress = progress;
}

//  {zh} BEStyleMakeupView 本身不拦截事件，将其透传到自己的下一层去  {en} BEStyleMakeupView itself does not block events, passing them through to its next level
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (v == self) {
        return nil;
    }
    return v;
}

#pragma mark - getter
- (BETextSwitchView *)switchView {
    if (_switchView) {
        return _switchView;
    }
    
    _switchView = [BETextSwitchView new];
    return _switchView;
}

- (BEItemPickerView *)pickerView {
    if (_pickerView) {
        return _pickerView;
    }
    
    _pickerView = [[BEItemPickerView alloc] init];
    return _pickerView;
}

- (BETitleBoardView *)titleBoardView {
    if (_titleBoardView) {
        return _titleBoardView;
    }
    
    _titleBoardView = [[BETitleBoardView alloc] init];
    _titleBoardView.boardContentView = self.pickerView;
    return _titleBoardView;
}

- (BETextSliderView *)textSlider {
    if (!_textSlider) {
        _textSlider = [[BETextSliderView alloc] init];
        _textSlider.backgroundColor = [UIColor clearColor];
        _textSlider.lineHeight = 2.5;
        _textSlider.textOffset = 25;
        _textSlider.animationTime = 250;
    }
    return _textSlider;
}

- (UIView *)vBoard {
    if (_vBoard) {
        return _vBoard;
    }
    
    _vBoard = [UIView new];
    _vBoard.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    return _vBoard;
}

@end
