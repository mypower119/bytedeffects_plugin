//
//  BEEffectConfig.m
//  Effect
//
//  Created by qun on 2021/5/23.
//

#import "BEEffectConfig.h"
#import "BEBaseBarView.h"

NSString *const EFFECT_CONFIG_KEY = @"EFFECT_CONFIG_KEY";

@implementation BEEffectBeautyConfigItem

- (instancetype)initWithTitle:(NSString *)title type:(BEEffectType)type {
    if (self = [super init]) {
        self.title = title;
        self.effecType = type;
    }
    return self;
}

@end

@implementation BEEffectConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showBoard = YES;
        _showResetButton = YES;
        _showCompareButton = YES;
        _effectType = BEEffectTypeLite;
        _topBarMode = BEBaseBarAll;
    }
    return self;
}

- (BOOL)isAutoTest {
    return _composerNodes != nil;
}

#pragma mark getter
+ (BEEffectConfig * (^)(void))newInstance {
    return ^id() {
        return [[BEEffectConfig alloc] init];
    };
}

- (BEEffectConfig * (^)(BEEffectType))effectTypeW {
    return ^id(BEEffectType effectType) {
        self.effectType = effectType;
        return self;
    };
}

- (BEEffectConfig * (^)(NSInteger))topBarModeW {
    return ^id(NSInteger mode) {
        self.topBarMode = mode;
        return self;
    };
}

- (BEEffectConfig *(^)(id))titleW {
    return ^id(NSString *config) {
        self.title = config;
        return self;
    };
}

- (BEEffectConfig * (^)(id))stickerConfigW {
    return ^id(BEStickerConfig *config) {
        self.stickerConfig = config;
        return self;
    };
}

- (BEEffectConfig * (^)(BOOL, BOOL))showResetAndCompareW {
    return ^id(BOOL showReset, BOOL showCompare) {
        self.showResetButton = showReset;
        self.showCompareButton = showCompare;
        return self;
    };
}

@end
