//
//  BESkeletonUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEChromaKeyingUI.h"
#import "BEChromaKeyingAlgorithmTask.h"

@interface BEChromaKeyingUI ()

@end

@implementation BEChromaKeyingUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *chromaKeying = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_chroma_keying_highlight"
        unselectImg:@"ic_chroma_keying_normal"
        title:@"feature_chroma_keying"
        desc:@""];
    chromaKeying.key = BEChromaKeyingAlgorithmTask.CHROMA_KEYING;
    return chromaKeying;
}

@end
