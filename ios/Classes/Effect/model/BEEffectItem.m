//
//  BEButtonItemModel.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "BEEffectItem.h"

@interface BEEffectItem ()

@property (nonatomic, readonly) BOOL hasIntensity;

@end

@implementation BEEffectItem


+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model {
    BEEffectItem *item = [[self alloc] initWithSelectImg:selectImg unselectImg:unselectImg title:title desc:desc];
    item.ID = ID;
    item.model = model;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model showIntensityBar:(BOOL)showIntensityBar {
    BEEffectItem *item = [[self alloc] initWithSelectImg:selectImg unselectImg:unselectImg title:title desc:desc];
    item.ID = ID;
    item.model = model;
    item.showIntensityBar = showIntensityBar;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc model:model];
    item.tipTitle = tipTitle;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle colorset:(NSArray *)colorset {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc model:model];
    item.tipTitle = tipTitle;
    item.colorset = colorset;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle colorset:(NSArray *)colorset type:(BEEffectTpye)type {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc model:model];
    item.tipTitle = tipTitle;
    item.colorset = colorset;
    item.type = type;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle showIntensityBar:(BOOL)showIntensityBar {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc model:model];
    item.tipTitle = tipTitle;
    item.showIntensityBar = showIntensityBar;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle showIntensityBar:(BOOL)showIntensityBar type:(BEEffectTpye)type {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc model:model];
    item.tipTitle = tipTitle;
    item.showIntensityBar = showIntensityBar;
    item.type = type;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model enableNegative:(BOOL)enableNegative {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc model:model];
    item.enableNegative = enableNegative;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children {
    BEEffectItem *item = [[self alloc] initWithSelectImg:selectImg unselectImg:unselectImg title:title desc:desc];
    item.ID = ID;
    item.children = children;
    for (BEEffectItem *i in children) {
        i.parent = item;
    }
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc children:children];
    item.enableMultiSelect = enableMultiSelect;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect colorset:(NSArray *)colorset {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc children:children];
    item.enableMultiSelect = enableMultiSelect;
    item.colorset = colorset;
    return item;
}

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect showIntensityBar:(BOOL)showIntensityBar {
    BEEffectItem *item = [self initWithID:ID selectImg:selectImg unselectImg:unselectImg title:title desc:desc children:children];
    item.enableMultiSelect = enableMultiSelect;
    item.showIntensityBar = showIntensityBar;
    return item;
}

+ (instancetype)initWithId:(BEEffectNode)ID {
    BEEffectItem *item = [[self alloc] initWithSelectImg:nil unselectImg:nil title:nil desc:nil];
    item.ID = ID;
    return item;
}

+ (instancetype)initWithId:(BEEffectNode)ID children:(NSArray<BEEffectItem *> *)children {
    BEEffectItem *item = [[self alloc] initWithSelectImg:nil unselectImg:nil title:nil desc:nil];
    item.ID = ID;
    item.children = children;
    for (BEEffectItem *i in children) {
        i.parent = item;
    }
    return item;
}

+ (instancetype)initWithId:(BEEffectNode)ID children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect {
    BEEffectItem *item = [self initWithId:ID children:children];
    item.enableMultiSelect = enableMultiSelect;
    return item;
}

- (instancetype)initWithSelectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc {
    if (self = [super init]) {
        self.selectImg = selectImg;
        self.unselectImg = unselectImg;
        self.title = title;
        self.desc = desc;
        self.enableMultiSelect = YES;
        self.enableNegative = NO;
        self.reuseChildrenIntensity = YES;
        self.showIntensityBar = YES;
    }
    return self;
}

- (void)updateState {
    if (_cell) {
        if ([_cell isKindOfClass:[BESelectableCell class]] && (self.parent == nil || self.parent.enableMultiSelect)) {
            BOOL hasIntensity = self.hasIntensity;
            _cell.selectableButton.isPointOn = hasIntensity;
        }
        
        if (self.parent != nil) {
            [self.parent updateState];
        }
    }
}

- (void)reset {
    self.selectChild = nil;
    self.selectedColor = nil;
    if (self.model != nil) {
        _intensityArray = [NSMutableArray arrayWithCapacity:self.model.keyArray.count];
        for (int i = 0; i < self.model.keyArray.count; i++) {
            [_intensityArray addObject:[NSNumber numberWithFloat: self.enableNegative ? 0.5 : 0]];
        }
    }
    if (self.children != nil) {
        for (BEEffectItem *child in self.children) {
            [child reset];
        }
    }
}

- (NSArray<BEEffectItem *> *)allChildren {
    NSMutableArray<BEEffectItem *> *all = [NSMutableArray array];
    if (self.children != nil) {
        for (BEEffectItem *child in self.children) {
            [all addObject:child];
            [all addObjectsFromArray:child.allChildren];
        }
    }
    return [all copy];
}

- (BOOL)hasIntensity {
    BOOL hasIntensity = NO;
    if (self.model != nil) {
        for (NSNumber *intensity in self.intensityArray) {
            float inte = [intensity floatValue];
            if (self.enableNegative ? inte != 0.5 : inte > 0) {
                hasIntensity = YES;
                break;
            }
        }
    } else if (self.availableItem.model != nil) {
        return self.availableItem.hasIntensity;
    } else if (self.children != nil) {
        for (BEEffectItem *child in self.children) {
            hasIntensity |= child.hasIntensity;
        }
    }
    return hasIntensity;
}

#pragma mark - setter & getter
- (void)setModel:(BEComposerNodeModel *)model {
    _model = model;
    [self reset];
}

- (void)setEnableNegative:(BOOL)enableNegative {
    _enableNegative = enableNegative;
    [self reset];
}

- (NSArray<NSNumber *> *)validIntensity {
    if (self.selectChild == nil) {
        return self.intensityArray;
    } else {
        return self.selectChild.validIntensity;
    }
}

- (BEEffectItem *)availableItem {
    if (self.children == nil) {
        return self.model == nil ? nil : self;
    }
    return self.selectChild != nil ? self.selectChild.availableItem : nil;
}
@end
