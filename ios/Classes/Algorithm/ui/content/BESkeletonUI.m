//
//  BESkeletonUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BESkeletonUI.h"
#import "BESkeletonAlgorithmTask.h"

@interface BESkeletonUI ()

@end

@implementation BESkeletonUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *skeleton = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_skeleton_highlight"
                                                               unselectImg:@"ic_skeleton_normal"
                                                                     title:@"feature_body"
                                                                      desc:@"skeleton_detect_desc"];
    skeleton.key = BESkeletonAlgorithmTask.SKELETON;
    return skeleton;
}

@end
