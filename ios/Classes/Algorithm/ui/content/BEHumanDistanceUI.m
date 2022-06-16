//
//  BEHumanDistanceUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEHumanDistanceUI.h"
#import "BEFaceDistanceInfoVC.h"
#import "BEHumanDistanceAlgorithmTask.h"

@interface BEHumanDistanceUI ()

@property (nonatomic, strong) BEFaceDistanceInfoVC *vcInfo;

@end

@implementation BEHumanDistanceUI

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
}

- (void)onReceiveResult:(BEHumanDistanceAlgorithmResult *)result {
    if (result == nil || result.faceInfo == nil || result.distanceInfo == nil) {
        return;
    }
    
    bef_ai_face_info faceInfo = *result.faceInfo;
    bef_ai_human_distance_result distance = *result.distanceInfo;
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.vcInfo setImageSize:self.provider.imageSize rotation:self.provider.imageRotation];
    [self.vcInfo updateFaceDistance:faceInfo distance:distance];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *humanDistance = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_human_distance_highlight"
                                                                    unselectImg:@"ic_human_distance_normal"
                                                                          title:@"feature_human_distance"
                                                                           desc:@"tab_distance_desc"];
    humanDistance.key = BEHumanDistanceAlgorithmTask.HUMAN_DISTANCE;
    return humanDistance;
}

- (BEFaceDistanceInfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [BEFaceDistanceInfoVC new];
    }
    return _vcInfo;
}

@end
