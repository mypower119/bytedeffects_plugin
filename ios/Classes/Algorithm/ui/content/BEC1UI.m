//
//  BEC1UI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEC1UI.h"
#import "BEC1InfoVC.h"
#import "BETextSizeUtils.h"
#import "BEC1AlgorithmTask.h"

static int TOP_N = 1;

@interface BEC1UI ()

@property (nonatomic, strong) BEC1InfoVC *infoVC;

@end

@implementation BEC1UI

- (void)onReceiveResult:(BEC1AlgorithmResult *)result {
    if (result == nil || result.c1Info == nil) {
        return;
    }
    
    bef_ai_c1_output c1Info = *result.c1Info;
    int max = -1;
    for (int i = 0; i < BEF_AI_C1_NUM_CLASSES; i++) {
        if (c1Info.items[i].satisfied && (max < 0 || c1Info.items[i].prob > c1Info.items[max].prob)) {
            max = i;
        }
    }
    if (max < 0) {
        [self.infoVC updateInfo:NSLocalizedString(@"tab_c1", nil) value:NSLocalizedString(@"video_cls_no_results", nil)];
    } else {
        bef_ai_c1_category c = c1Info.items[max];
        NSString *title = [self types][max];
        NSString *value = [NSString stringWithFormat:@"%.2f", c.prob];
        [self.infoVC updateInfo:title value:value];
    }
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.infoVC show:flag];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *c1 = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_c1_highlight"
                                                         unselectImg:@"ic_c1_normal"
                                                               title:@"tab_c1"
                                                                desc:@"c1_desc"];
    c1.key = BEC1AlgorithmTask.C1;
    return c1;
}

- (BEC1InfoVC *)infoVC {
    if (_infoVC == nil) {
        _infoVC = [BEC1InfoVC new];
    }
    return _infoVC;
}

- (NSArray *)types {
    static NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@"Baby",   @"Beach", @"Building",   @"Car",    @"Cartoon", @"Cat",    @"Dog",    @"Flower", @"Food", @"Group", @"Hill",
        @"Indoor", @"Lake",  @"Nightscape", @"Selfie", @"Sky",     @"Statue", @"Street", @"Sunset", @"Text", @"Tree",  @"Other"];
    });
    return arr;
}

@end
