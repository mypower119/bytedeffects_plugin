//
//  BEAnimojiUI.m
//  BytedEffects
//
//  Created by qun on 2020/11/17.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAnimojiUI.h"
#import "BEAnimojiAlgorithmTask.h"

@implementation BEAnimojiUI

- (void)onReceiveResult:(BEAnimojiAlgorithmResult *)result {
    
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *item = [[BEAlgorithmItem alloc] initWithSelectImg:@"iconC2Selected" unselectImg:@"iconC2Normal" title:@"animoji" desc:@""];
    item.key = BEAnimojiAlgorithmTask.ANIMOJI;
    return item;
}

@end
