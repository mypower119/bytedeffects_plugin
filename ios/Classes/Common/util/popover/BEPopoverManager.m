//
//  BEPopoverManager.m
//  Common
//
//  Created by qun on 2021/6/7.
//

#import "BEPopoverManager.h"
#import "Masonry.h"

@interface BEPopoverManager () <BESwitchItemViewDelegate, BESingleSwitchViewDelegate>

@property (nonatomic, strong) NSArray<UIView *> *views;
@property (nonatomic, strong) NSArray<UIView *> *borders;

@end

@implementation BEPopoverManager
@synthesize contentView = _contentView;

#pragma mark - BESwitchItemViewDelegate
- (void)switchItemView:(BESwitchItemView *)view didSelect:(NSInteger)index {
    BESwitchItemConfig *config = view.config;
    [self.delegate popover:self configDidChange:config key:config.key];
}

#pragma mark - BESingleSwitchViewDelegate
- (void)switchView:(BESingleSwitchView *)view isOn:(BOOL)isOn {
    BESingleSwitchConfig *config = view.config;
    [self.delegate popover:self configDidChange:config key:config.key];
}

#pragma mark - getter
- (UIView *)contentView {
    if (_contentView) {
        return _contentView;
    }
    
    UIView *container = [UIView new];
    NSArray<UIView *> *views = self.views;
    NSArray<UIView *> *borders = self.borders;
    for (UIView *view in views) {
        [container addSubview:view];
    }
    for (UIView *border in borders) {
        [container addSubview:border];
    }
    if (views.count > 1) {
        [views mas_distributeViewsAlongAxis:MASAxisTypeVertical
                           withFixedSpacing:0
                                leadSpacing:0
                                tailSpacing:0];
        [views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(container);
        }];
        
        for (int i = 0; i < borders.count; i++) {
            [borders[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(container);
                make.height.mas_equalTo(1);
                make.top.equalTo(views[i].mas_bottom).offset(-0.5);
            }];
        }
    } else if (views.count == 1) {
        [views[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(container);
            make.top.equalTo(container).offset(0);
        }];
    }
    _contentView = container;
    return _contentView;
}

- (NSArray<UIView *> *)views {
    if (_views) {
        return _views;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSObject *config in self.configs) {
        if ([config isKindOfClass:[BESingleSwitchConfig class]]) {
            BESingleSwitchConfig *c = (BESingleSwitchConfig *)config;
            BESingleSwitchView *v = [BESingleSwitchView new];
            v.delegate = self;
            v.config = c;
            [arr addObject:v];
        } else if ([config isKindOfClass:[BESwitchItemConfig class]]) {
            BESwitchItemConfig *c = (BESwitchItemConfig *)config;
            BESwitchItemView *v = [BESwitchItemView new];
            v.delegate = self;
            v.config = c;
            [arr addObject:v];
        }
    }
    _views = [arr copy];
    return _views;
}

- (NSArray<UIView *> *)borders {
    if (_borders) {
        return _borders;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.configs.count - 1; i++) {
        UIView *border = [UIView new];
        border.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        [arr addObject:border];
    }
    _borders = arr;
    return _borders;
}

@end
