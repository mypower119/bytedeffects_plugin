//
//  BELightClsUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BELightClsUI.h"
#import "BELightClsInfoVC.h"
#import "BELightClsAlgorithmTask.h"

@interface BELightClsUI ()

@property (nonatomic, strong) BELightClsInfoVC *vcInfo;

@end

@implementation BELightClsUI

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
}

- (void)onReceiveResult:(BELightClsAlgorithmResult *)result {
    if (result == nil || result.ligthInfo == nil) {
        return;
    }
    
    bef_ai_light_cls_result lightInfo = *result.ligthInfo;
    [self.vcInfo updateLightInfo:lightInfo];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *light = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_lightcls_highlight"
                                                            unselectImg:@"ic_lightcls_normal"
                                                                  title:@"feature_light"
                                                                   desc:@"tab_light_desc"];
    light.key = BELightClsAlgorithmTask.LIGHT_CLS;
    return light;
}

- (BELightClsInfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [BELightClsInfoVC new];
    }
    return _vcInfo;
}

@end
