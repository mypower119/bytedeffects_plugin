//
//  BESingleSwitchView.m
//  Common
//
//  Created by qun on 2021/6/6.
//

#import "BESingleSwitchView.h"
#import "Masonry.h"
#import "Common.h"

@implementation BESingleSwitchConfig

- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn {
    if (self = [super init]) {
        _title = title;
        _isOn = isOn;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn key:(NSString *)key {
    self = [[BESingleSwitchConfig alloc] initWithTitle:title isOn:isOn];
    if (self) {
        self.key = key;
    }
    return self;
}

@end
@interface BESingleSwitchView ()

@property (nonatomic, strong) UILabel *lTitle;
@property (nonatomic, strong) UISwitch *sSwitch;

@end

@implementation BESingleSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lTitle];
        [self addSubview:self.sSwitch];
        
        [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leadingMargin.mas_equalTo(16);
        }];
        
        [self.sSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailingMargin.mas_equalTo(-16);
        }];
    }
    return self;
}

- (void)setConfig:(BESingleSwitchConfig *)config {
    _config = config;
    
    self.lTitle.text = NSLocalizedString(config.title, nil);
    [self setIsOn:config.isOn];
}

- (void)setIsOn:(BOOL)isOn {
    self.sSwitch.on = isOn;
    self.config.isOn = isOn;
}

- (BOOL)isOn {
    return self.sSwitch.isOn;
}

- (void)singleSwitchChanged {
    self.config.isOn = self.sSwitch.isOn;
    [self.delegate switchView:self isOn:self.sSwitch.isOn];
}

#pragma mark - getter
- (UILabel *)lTitle {
    if (_lTitle) {
        return _lTitle;
    }
    
    _lTitle = [UILabel new];
    _lTitle.textColor = [UIColor whiteColor];
    _lTitle.font = [UIFont systemFontOfSize:13];
    return _lTitle;
}

- (UISwitch *)sSwitch {
    if (_sSwitch) {
        return _sSwitch;
    }
    
    _sSwitch = [UISwitch new];
    [_sSwitch addTarget:self action:@selector(singleSwitchChanged) forControlEvents:UIControlEventValueChanged];
    _sSwitch.onTintColor = BEColorWithRGBHex(0x1664FF);
//    _sSwitch.tintColor = [UIColor colorWithWhite:1 alpha:0.85];
    _sSwitch.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    _sSwitch.layer.cornerRadius = 16;
    return _sSwitch;
}

@end
