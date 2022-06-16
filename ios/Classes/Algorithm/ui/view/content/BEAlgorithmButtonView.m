//
//  BEAlgorithmButtonView.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEAlgorithmButtonView.h"
#import "BESelectableButton.h"
#import "BELightUpSelectableView.h"
#import "Masonry.h"
#import "Toast.h"
#import "Common.h"

@interface BEAlgorithmButtonView () <BESelectableButtonDelegate> {
}

@property (nonatomic, strong) NSArray<BESelectableButton *> *contentViews;

@end

@implementation BEAlgorithmButtonView

@synthesize selectSet = _selectSet;

- (void)setItem:(BEAlgorithmItem *)item {
    _item = item;
    for (BESelectableButton *view in self.contentViews) {
        [self addSubview:view];
    }
    
    if (self.contentViews.count == 1) {
        [self.contentViews[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(BEF_DESIGN_SIZE(60));
            make.height.mas_equalTo(BEF_DESIGN_SIZE(66));
            make.center.equalTo(self);
        }];
    } else {
        [self.contentViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                                       withFixedSpacing:0
                                            leadSpacing:30
                                            tailSpacing:30];
        [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(68);
            make.centerY.equalTo(self);
        }];
    }
}

#pragma mark - public
- (void)setItemWithoutUI:(BEAlgorithmItem *)item {
    _item = item;
}

- (BOOL)openItem:(NSInteger)index {
    BEAlgorithmItem *item = self.items[index];
    
    if (item.dependency != nil) {
        for (BEAlgorithmKey *key in item.dependency) {
            if (![self.selectSet containsObject:key]) {
                [self makeToast:NSLocalizedString(item.dependencyToast, nil)];
                return NO;
            }
        }
    }
    
    [self selectItem:index];
    [self.selectSet addObject:item.key];
    [self.delegate algorithmButtonView:self onItem:item selected:YES];
    return YES;
}

- (void)closeItem:(NSInteger)index {
    BEAlgorithmItem *item = self.items[index];
    
    for (int i = 0; i < self.items.count; i++) {
        BEAlgorithmItem *ci = self.items[i];
        if ([self.selectSet containsObject:ci.key] && ci.dependency != nil && [ci.dependency containsObject:item.key]) {
            [self closeItem:i];
        }
    }
    
    [self unselectItem:index];
    [self.selectSet removeObject:item.key];
    [self.delegate algorithmButtonView:self onItem:item selected:NO];
}

- (void)selectItem:(NSInteger)index {
    self.contentViews[index].isSelected = YES;
}

- (void)unselectItem:(NSInteger)index {
    self.contentViews[index].isSelected = NO;
}

#pragma mark - BESelectableButtonDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    NSUInteger position = [self.contentViews indexOfObject:button];
    BOOL selected = !button.isSelected;
    
    if (selected) {
        [self openItem:position];
    } else {
        [self closeItem:position];
    }
}

#pragma mark - getter
- (NSArray<BEAlgorithmItem *> *)items {
    if ([self.item isKindOfClass:[BEAlgorithmItemGroup class]]) {
        return [(BEAlgorithmItemGroup *)self.item items];
    } else {
        return [NSArray arrayWithObject:self.item];
    }
}

- (NSMutableSet<BEAlgorithmKey *> *)selectSet {
    if (_selectSet) {
        return _selectSet;
    }
    
    _selectSet = [NSMutableSet set];
    return _selectSet;
}

- (NSArray<BESelectableButton *> *)contentViews {
    if (_contentViews == nil) {
        NSMutableArray<BESelectableButton *> *array = [NSMutableArray array];
        for (BEAlgorithmItem *item in self.items) {
            BESelectableButton *view =
                [[BESelectableButton alloc]
                 initWithSelectableConfig:[BELightUpSelectableConfig initWithUnselectImage:item.selectImg
                                                                               imageSize:CGSizeMake(BEF_DESIGN_SIZE(36), BEF_DESIGN_SIZE(36))]];
            view.title = NSLocalizedString(item.title, nil);
            view.isPointOn = NO;
            view.delegate = self;
            [array addObject:view];
            
            if ([self.selectSet containsObject:item.key]) {
                view.isSelected = YES;
            }
            else {
                view.isSelected = NO;
            }
        }
        _contentViews = array;
    }
    return _contentViews;
}

@end
