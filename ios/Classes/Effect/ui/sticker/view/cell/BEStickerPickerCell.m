//
//  BEStickerPickerCell.m
//  Effect
//
//  Created by qun on 2021/5/25.
//

#import "BEStickerPickerCell.h"
#import "Masonry.h"

@interface BEStickerPickerCell ()

@end

@implementation BEStickerPickerCell

@synthesize pickerView = _pickerView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pickerView];
        
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - getter
- (BEStickerPickerView *)pickerView {
    if (_pickerView) {
        return _pickerView;
    }
    
    _pickerView = [[BEStickerPickerView alloc] init];
    return _pickerView;
}

@end
