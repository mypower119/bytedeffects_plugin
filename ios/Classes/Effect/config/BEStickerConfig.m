//
//  BEStickerConfig.m
//  Effect
//
//  Created by qun on 2021/5/25.
//

#import "BEStickerConfig.h"

@interface BEStickerConfig ()

@end

@implementation BEStickerConfig

#pragma mark getter
+ (BEStickerConfig *(^)(NSString *type))newInstance {
    return ^id(NSString *type) {
        BEStickerConfig *o = [[BEStickerConfig alloc] init];
        o.type = type;
        return o;
    };
}

- (BEStickerConfig *(^)(NSString *))stickerPathW {
    return ^id(NSString *path) {
        self.stickerPath = path;
        return self;
    };
}

@end
