//
//  BEHairParserUI.m
//  Algorithm
//
//  Created by qun on 2021/5/31.
//

#import "BEHairParserUI.h"
#import "BEHairParserAlgorithmTask.h"

@interface BEHairParserUI ()

@end

@implementation BEHairParserUI

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *hair = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_hair_parser_highlight"
                                                           unselectImg:@"ic_hair_parser_normal"
                                                                 title:@"feature_hair_parse"
                                                                  desc:@"segment_hair_desc"];
    hair.key = BEHairParserAlgorithmTask.HAIR_PARSER;
    return hair;
}

@end
