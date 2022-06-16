//
//  BEFeatureItem.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEFeatureItem.h"

@implementation BEFeatureItem

+ (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon config:(BEFeatureConfig *)config {
    BEFeatureItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    item.config = config;
    return item;
}

@end

@implementation BEFeatureGroup

+ (instancetype)initWithTitle:(NSString *)title {
    BEFeatureGroup *group = [[self alloc] init];
    group.title = title;
    return group;
}

- (void) addChild:(BEFeatureItem *)item{
    if (_children == nil) {
        _children = [NSMutableArray new];
    }
    [_children addObject:item];
    
    
    
    
    
    
    
}

@end
