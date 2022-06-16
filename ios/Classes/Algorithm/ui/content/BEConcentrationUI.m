//
//  BEConcentrationUI.m
//  BytedEffects
//
//  Created by qun on 2020/9/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEConcentrationUI.h"
#import "BEC1InfoVC.h"
#import "BEConcentrationTask.h"

@interface BEConcentrationUI ()

@property (nonatomic, strong) BEC1InfoVC *vcInfo;

@end

@implementation BEConcentrationUI

- (void)onReceiveResult:(BEConcentrationAlgorithmResult *)result {
    float proportion = result.proportion;
    
    [self.vcInfo updateInfo:NSLocalizedString(@"feature_concentrate", nil) value:[[NSString stringWithFormat:@"%d", (int)(proportion * 100)] stringByAppendingString:@"%"]];
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *item = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_concentrate_highlight" unselectImg:@"ic_concentrate_normal" title:@"feature_concentrate" desc:@""];
    item.key = BEConcentrationTask.CONCENTRATION;
    return item;
}

- (BEC1InfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [BEC1InfoVC new];
    }
    return _vcInfo;
}

@end
