//
//  BESkySegUI.m
//  Algorithm
//
//  Created by qun on 2021/5/31.
//

#import "BESkySegUI.h"
#import "BESkySegAlgorithmTask.h"

@interface BESkySegUI ()

@end

@implementation BESkySegUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *sky = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_skyseg_highlight"
                                                          unselectImg:@"ic_skyseg_normal"
                                                                title:@"feature_sky_seg"
                                                                 desc:@"segment_sky_desc"];
    sky.key = BESkySegAlgorithmTask.SKY_SEG;
    return sky;
}

@end
