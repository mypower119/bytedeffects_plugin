//
//  BEFeatureConfig.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEFeatureConfig.h"

@implementation BEFeatureConfig

#pragma mark getter

+ (BEFeatureConfig *(^)(void))newInstance {
    return ^id() {
        return [[BEFeatureConfig alloc] init];
    };
}

- (BEFeatureConfig *(^)(id))videoSourceConfigW {
    return ^id(BEVideoSourceConfig *config) {
        self.videoSourceConfig = config;
        return self;
    };
}

- (BEFeatureConfig *(^)(id))effectConfigW {
    return ^id(BEEffectConfig *config) {
        self.effectConfig = config;
        return self;
    };
}

- (BEFeatureConfig *(^)(id))algorithmConfigW {
    return ^id(BEAlgorithmConfig *config) {
        self.algorithmConfig = config;
        return self;
    };
}

- (BEFeatureConfig *(^)(id))lensConfigW {
    return ^id(BELensConfig *config) {
        self.lensConfig = config;
        return self;
    };
}

- (BEFeatureConfig *(^)(__unsafe_unretained Class))classW {
    return ^id(Class cls) {
        self.viewControllerClass = cls;
        return self;
    };
}

@end
