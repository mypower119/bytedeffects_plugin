//
//  BEAlgorithmUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmUI.h"

@interface BEBaseAlgorithmUI() {
    
}

@end

@implementation BEBaseAlgorithmUI

- (void)initUI:(id<BEAlgorithmInfoProvider>)provider {
    self.provider = provider;
    
    [self initView];
    [self initCallback];
}

- (void)onItemEvent:(BEAlgorithmItem *)item flag:(BOOL)flag {
    [self onEvent:item.key flag:flag];
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    CHECK_ARGS_AVAILABLE(2, self.provider, self.provider.algorithmTask)
    [self.provider.algorithmTask setConfig:key p:[NSNumber numberWithBool:flag]];
}

- (void)initView {}
- (void)initCallback {}
- (BEAlgorithmItem *)algorithmItem {
    return nil;
}

- (id<BEAlgorithmUIGenerator>)algorithmGenerator {
    return nil;
}

- (void)onReceiveResult:(id)result {
    
}

@end
