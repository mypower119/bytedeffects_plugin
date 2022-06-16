//
//  BEButtonItem.m
//  BytedEffects
//
//  Created by qun on 2020/8/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEButtonItem.h"

@implementation BEButtonItem

- (instancetype)initWithSelectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc {
    if (self = [super init]) {
        self.selectImg = selectImg;
        self.unselectImg = unselectImg;
        self.title = title;
        self.desc = desc;
    }
    return self;
}

- (NSString *)tipTitle {
    if (!_tipTitle) {
        if (_desc && ![_desc isEqualToString:@""]) {
            return _desc;
        }
        return _title;
    }
    return _tipTitle;
}

- (NSString *)tipDesc {
    if (!_tipDesc) {
        return _desc;
    }
    return _tipDesc;
}

@end
