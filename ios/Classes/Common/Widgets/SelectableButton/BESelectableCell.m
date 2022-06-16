//
//  BESelectableCell.m
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#import "BESelectableCell.h"
#import "Masonry.h"

@interface BESelectableCell ()

@end

@implementation BESelectableCell

@synthesize selectableButton = _selectableButton;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setSelectableConfig:(id<BESelectableConfig>)selectableConfig {
    _selectableConfig = selectableConfig;
    
    if (_selectableButton) {
        [_selectableButton removeFromSuperview];
    }
    
    _selectableButton = [[BESelectableButton alloc] initWithSelectableConfig:selectableConfig];
    [self.contentView addSubview:_selectableButton];
    [_selectableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (_useCellSelectedState) {
        self.selectableButton.isSelected = selected;
    }
}

- (void)setUseCellSelectedState:(BOOL)useCellSelectState {
    _useCellSelectedState = useCellSelectState;
    
    if (useCellSelectState) {
        self.selectableButton.isSelected = self.selected;
    }
}

#pragma mark - getter
- (BESelectableButton *)selectableButton {
    if (_selectableButton) {
        return _selectableButton;
    }
    
    _selectableButton = [[BESelectableButton alloc] initWithSelectableConfig:_selectableConfig];
    return _selectableButton;
}

@end
