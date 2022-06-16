//
//  BEHandUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEHandUI.h"
#import "BEHandInfoVC.h"
#import "BEHandAlgorithmTask.h"

@interface BEHandUI ()

@property (nonatomic, strong) BEHandInfoVC *vcInfo;

@end

@implementation BEHandUI

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
    self.vcInfo.view.hidden = YES;
}

- (void)onReceiveResult:(BEHandAlgorithmResult *)result {
    if (result == nil || result.handInfo == nil) {
        return;
    }
    
    bef_ai_hand_info handInfo = *result.handInfo;
    CHECK_ARGS_AVAILABLE(1, self.provider)
    self.vcInfo.view.hidden = handInfo.hand_count == 0;
    
    if (handInfo.hand_count == 0){
        return ;
    }
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.vcInfo setImageSize:self.provider.imageSize rotation:self.provider.imageRotation];
    [self.vcInfo updateHandInfo:handInfo.p_hands[0]];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *hand = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_hand_highlight"
                                                           unselectImg:@"ic_hand_normal"
                                                                 title:@"feature_hand"
                                                                  desc:@"hand_detect_desc"];
    hand.key = BEHandAlgorithmTask.HAND;
    return hand;
}

- (BEHandInfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [BEHandInfoVC new];
    }
    return _vcInfo;
}

@end
