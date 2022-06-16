//
//  BEHeadSegUI.m
//  Algorithm
//
//  Created by qun on 2021/5/31.
//

#import "BEHeadSegUI.h"
#import "BEHeadSegmentAlgorithmTask.h"

@interface BEHeadSegUI ()

@end

@implementation BEHeadSegUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *head = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_headseg_highlight"
                                                           unselectImg:@"ic_headseg_normal"
                                                                 title:@"feature_head_seg"
                                                                  desc:@"head_segment_desc"];
    head.key = BEHeadSegmentAlgorithmTask.HEAD_SEGMENT;
    return head;
}

@end
