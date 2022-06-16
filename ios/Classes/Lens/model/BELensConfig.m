//
//  BELensConfig.m
//  Lens
//
//  Created by wangliu on 2021/6/2.
//

#import "BELensConfig.h"

NSString *const LENS_CONFIG_KEY = @"LENS_CONFIG_KEY";

@implementation BELensConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showBoard = YES;
    }
    return self;
}

+ (instancetype)initWithType:(ImageQualityType)type open:(BOOL)open {
    BELensConfig *config = [self new];
    config.type = type;
    config.open = open;
    return config;
}


@end
