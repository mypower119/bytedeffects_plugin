//
//  BESkeletonUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEBachSkeletonUI.h"
#import "BEBachSkeletonAlgorithmTask.h"

@interface BEBachSkeletonUI ()

@end

@implementation BEBachSkeletonUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *bachSkeleton = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_bach_skeleton_highlight"
        unselectImg:@"ic_bach_skeleton_normal"
        title:@"feature_bach_skeleton"
        desc:@""];
    bachSkeleton.key = BEBachSkeletonAlgorithmTask.BACH_SKELETON;
    return bachSkeleton;
}

@end
