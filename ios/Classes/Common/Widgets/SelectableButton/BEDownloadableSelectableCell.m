//
//  BEDownloadableSelectableCell.m
//  BECommon
//
//  Created by qun on 2021/12/10.
//

#import "BEDownloadableSelectableCell.h"
#import "Masonry.h"
#import "Common.h"

@interface BEDownloadableSelectableCell ()

@end

@implementation BEDownloadableSelectableCell

@synthesize selectableButton = _selectableButton;
@synthesize downloadView = _downloadView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.downloadView];
        
        [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(BEF_DESIGN_SIZE(12), BEF_DESIGN_SIZE(12)));
        }];
    }
    return self;
}

- (void)setSelectableConfig:(id<BESelectableConfig>)selectableConfig {
    _selectableConfig = selectableConfig;
    
    if (_selectableButton) {
        [_selectableButton removeFromSuperview];
    }
    
    _selectableButton = [[BESelectableButton alloc] initWithSelectableConfig:selectableConfig];
    
    [self.contentView insertSubview:_selectableButton atIndex:0];
    [_selectableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.downloadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(BEF_DESIGN_SIZE(12), BEF_DESIGN_SIZE(12)));
        make.leading.mas_equalTo(self).offset(selectableConfig.imageSize.width - BEF_DESIGN_SIZE(12) - 4);
        make.top.mas_equalTo(self).offset(selectableConfig.imageSize.height - BEF_DESIGN_SIZE(12) - 4);
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

- (BEDownloadView *)downloadView {
    if (_downloadView) {
        return _downloadView;
    }
    
    _downloadView = [BEDownloadView new];
    _downloadView.downloadImage = [UIImage imageNamed:@"ic_to_download"];
    return _downloadView;
}

@end
