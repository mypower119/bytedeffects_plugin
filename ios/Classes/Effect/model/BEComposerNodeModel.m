//
//  BEComposerNodeModel.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "BEComposerNodeModel.h"

@implementation BEComposerNodeModel

+ (instancetype)initWithPath:(NSString *)path keyArray:(NSArray<NSString *> *)keyArray tag:(NSString *)tag {
    BEComposerNodeModel *model = [self initWithPath:path keyArray:keyArray];
    model.tag = tag;
    return model;
}

+ (instancetype)initWithPath:(NSString *)path keyArray:(NSArray<NSString *> *)keyArray {
    BEComposerNodeModel *model = [[self alloc] init];
    model.path = path;
    model.keyArray = keyArray;
    return model;
}

+ (instancetype)initWithPath:(NSString *)path key:(NSString *)key {
    BEComposerNodeModel *model = [[self alloc] init];
    model.path = path;
    model.keyArray = key == nil ? [NSArray array] : [NSArray arrayWithObject:key];
    return model;
}

@end
