//
//  BEPortraitMattingUI.m
//  Algorithm
//
//  Created by qun on 2021/5/31.
//

#import "BEPortraitMattingUI.h"
#import "BEPortraitMattingAlgorithmTask.h"

@interface BEPortraitMattingUI ()

@end

@implementation BEPortraitMattingUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *portrait = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_portrait_highlight"
                                                               unselectImg:@"ic_portrait_normal"
                                                                     title:@"feature_portrait"
                                                                      desc:@"segment_segment_desc"];
    portrait.key = BEPortraitMattingAlgorithmTask.PORTRAIT_MATTING;
    return portrait;
}

@end
