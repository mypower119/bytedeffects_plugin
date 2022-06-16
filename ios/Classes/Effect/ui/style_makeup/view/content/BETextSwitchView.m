//
//  BETextSwithView.m
//  Effect
//
//  Created by qun on 2021/5/26.
//

#import "BETextSwitchView.h"
#import "Masonry.h"

@interface BETextSwitchView () <BETextSwitchItemViewDelegate>

@property (nonatomic, strong) NSMutableArray<BETextSwitchItemView *> *itemViews;

@end

@implementation BETextSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemViews = [NSMutableArray array];
    }
    return self;
}

- (void)setItems:(NSArray<BETextSwitchItem *> *)items {
    _items = items;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemViews removeAllObjects];
    
    UIView *last = nil;
    for (BETextSwitchItem *item in items) {
        BETextSwitchItemView *v = [self itemView:item];
        [self.itemViews addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(last == nil ? self : last.mas_trailing).offset(last == nil ? 0 : 16);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(item.minTextWidth + 8);
        }];
        last = v;
    }
    
//    UIView *last = nil;
//    for (UIView *v in self.itemViews) {
//        [v mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(last == nil ? self : last.mas_trailing).offset(last == nil ? 0 : 16);
//            make.bottom.equalTo(self);
//            make.width.mas_equalTo(
//        }];
//    }
//    [self.itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
//                                withFixedSpacing:BEF_DESIGN_SIZE(10)
//                                     leadSpacing:0
//                                     tailSpacing:0];
//    [self.itemViews mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//    }];
    
    self.selectItem = self.items[0];
}

- (void)setSelectItem:(BETextSwitchItem *)selectItem {
    if (self.selectItem != nil) {
        NSInteger oldSelect = [self.items indexOfObject:self.selectItem];
        self.itemViews[oldSelect].selected = NO;
    }
    _selectItem = selectItem;
    
    NSInteger idx = [self.items indexOfObject:selectItem];
    self.itemViews[idx].selected = YES;
}

#pragma mark - BETextSwitchItemViewDelegate
- (void)textSwitchItemView:(BETextSwitchItemView *)view didSelect:(BETextSwitchItem *)item {
    self.selectItem = item;
    [self.delegate textSwitchItemView:view didSelect:item];
}

#pragma mark - getter
- (BETextSwitchItemView *)itemView:(BETextSwitchItem *)item {
    BETextSwitchItemView *v = [[BETextSwitchItemView alloc] init];
    v.item = item;
    v.delegate = self;
    return v;
}

@end
