//
//  BEGazeEstimationUI.m
//  BytedEffects
//
//  Created by qun on 2020/9/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEGazeEstimationUI.h"
#import "BEC1InfoVC.h"
#import "BEGazeEstimationTask.h"

static const float DEFAULT_POSITION = 0.5f;
static const int DEFAULT_WIDTH = 120;
static const int DEFAULT_HEIGHT = 200;

@interface BEGazeEstimationUI ()

@property (nonatomic, strong) BEC1InfoVC *vcInfo;

@end

@implementation BEGazeEstimationUI

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
    [self.vcInfo updateInfo:NSLocalizedString(@"gaze_inside", nil) value:NSLocalizedString(@"no", nil)];
}

- (void)onReceiveResult:(BEGazeEstimationAlgorithmResult *)result {
    if (result == nil || result.gazeInfo == nil) {
        return;
    }
    
    bef_ai_gaze_estimation_info gazeInfo = *result.gazeInfo;
    
    BOOL inside = NO;
    if (gazeInfo.face_count > 0 && gazeInfo.eye_infos[0].valid) {
        float *lEye = gazeInfo.eye_infos[0].leye_pos;
        float *rEye = gazeInfo.eye_infos[0].reye_pos;
        float *gaze = gazeInfo.eye_infos[0].mid_gaze;
        float eye[3];
        for (int i = 0; i < 3; i++) {
            eye[i] = (lEye[i] + rEye[i]) / 2;
        }
        float x = eye[0] - gaze[0] / gaze[2] * eye[2];
        float y = eye[1] - gaze[1] / gaze[2] * eye[2];
        
        int width = DEFAULT_WIDTH;
        int height = DEFAULT_HEIGHT;
        float position = DEFAULT_POSITION;
        int leftWidth = width * position;
        int rightWidth = width * (1 - position);
        inside = x >= -leftWidth && x <= rightWidth && y <= height && y >= 0;
    }
    
    [self.vcInfo updateInfo:NSLocalizedString(@"gaze_inside", nil) value:NSLocalizedString(inside ? @"yes" : @"no", nil)];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *item = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_gaze_estimation_highlight" unselectImg:@"ic_gaze_estimation_normal" title:@"feature_gaze_estimation" desc:@""];
    item.key = BEGazeEstimationTask.GAZE_ESTIMATION;
    return item;
}

- (BEC1InfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [BEC1InfoVC new];
    }
    return _vcInfo;
}

@end
