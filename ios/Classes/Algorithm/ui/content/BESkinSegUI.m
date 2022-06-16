//
//  BESkeletonUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BESkinSegUI.h"
#import "BESkinSegmentationAlgorithmTask.h"

@interface BESkinSegUI ()

@end

@implementation BESkinSegUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *skinSeg = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_skin_seg_highlight"
        unselectImg:@"ic_skin_seg_normal"
        title:@"feature_skin_segmentation"
        desc:@""];
    skinSeg.key = BESkinSegmentationAlgorithmTask.SKIN_SEGMENTATION;
    return skinSeg;
}

@end
