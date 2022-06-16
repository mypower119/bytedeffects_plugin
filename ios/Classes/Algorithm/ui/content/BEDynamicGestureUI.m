//
//  BEC1UI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEDynamicGestureUI.h"
#import "BEDynamicGestureInfoVC.h"
#import "BETextSizeUtils.h"
#import "BEDynamicGestureAlgorithmTask.h"

static int DELAY_SHOW_FRAME_NUM = 32;

@interface BEDynamicGestureUI ()

@property (nonatomic, strong) BEDynamicGestureInfoVC *infoVC;
@property (nonatomic, assign) bef_ai_dynamic_gesture_info gestureInfo;
@property (nonatomic, assign) int frameNum;

@end

@implementation BEDynamicGestureUI

- (void)onReceiveResult:(BEDynamicGestureAlgorithmResult *)result {
    if (result == nil || result.gestureInfo == nil) {
        return;
    }

    bef_ai_dynamic_gesture_info gestureInfo = result.gestureInfo[0];
    
    if (gestureInfo.action >= 0 && gestureInfo.action <= 17) {
        self.frameNum = DELAY_SHOW_FRAME_NUM;
        self.gestureInfo = gestureInfo;
    } else {
        self.frameNum--;
    }

    NSString *title = NSLocalizedString(@"tab_dynamic_gesture", nil);
    NSString *value = NSLocalizedString(@"dynamic_gesture_no_results", nil);
    if (self.frameNum > 0 && self.gestureInfo.action >= 0 && self.gestureInfo.action <= 17) {
        title = NSLocalizedString([self dynamicGestureType][self.gestureInfo.action], nil);
        value = [NSString stringWithFormat:@"%.2f", self.gestureInfo.action_score * 100.0f];
    }
    [self.infoVC updateInfo:title value:value];
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.infoVC show:flag];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *dynamicGesture = [[BEAlgorithmItem alloc]
                                       initWithSelectImg:@"ic_dynamic_gesture_highlight"
                                       unselectImg:@"ic_dynamic_gesture_normal"
                                       title:@"feature_dynamic_gesture"
                                       desc:@""];
    dynamicGesture.key = BEDynamicGestureAlgorithmTask.DYNAMIC_GESTURE;
    return dynamicGesture;
}

- (BEDynamicGestureInfoVC *)infoVC {
    if (_infoVC == nil) {
        _infoVC = [BEDynamicGestureInfoVC new];
    }
    return _infoVC;
}

- (NSArray<NSString *> *)dynamicGestureType {
    static dispatch_once_t onceToken;
    static NSArray *array;
    dispatch_once(&onceToken, ^{
        array = @[
            @"dyngest_result_swiping_left",
            @"dyngest_result_swiping_right",
            @"dyngest_result_swiping_down",
            @"dyngest_result_swiping_up",
            @"dyngest_result_sliding_two_fingers_left",
            @"dyngest_result_sliding_two_fingers_right",
            @"dyngest_result_sliding_two_fingers_down",
            @"dyngest_result_sliding_two_fingers_up",
            @"dyngest_result_zooming_in_with_full_hand",
            @"dyngest_result_zooming_out_with_full_hand",
            @"dyngest_result_zooming_in_with_two_fingers",
            @"dyngest_result_zooming_out_with_two_fingers",
            @"dyngest_result_thump_up",
            @"dyngest_result_thump_down",
            @"dyngest_result_shaking_hand",
            @"dyngest_result_stop_sign",
            @"dyngest_result_drumming_fingers",
            @"dyngest_result_no_gesture"
        ];
    });
    return array;
}


@end
