//
//  BEBaseResource.m
//  BECommon
//
//  Created by qun on 2021/10/19.
//

#import "BEBaseResource.h"

@interface BEResourceResult ()

@end

@implementation BEResourceResult

+ (instancetype)resultWithPath:(NSString *)path {
    BEResourceResult *result = [BEResourceResult new];
    result.path = path;
    return result;
}

@end

@interface BEBaseResource ()

@end

@implementation BEBaseResource

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

@end


extern NSString *BEResourceDomain = @"BEResourceDomain";
