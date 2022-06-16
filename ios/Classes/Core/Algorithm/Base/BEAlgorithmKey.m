//
//  BEAlgorithmTaskKey.m
//  BytedEffectSDK
//
//  Created by qun on 2021/5/11.
//

#import "BEAlgorithmKey.h"

@interface BEAlgorithmKey ()

@end

@implementation BEAlgorithmKey

+ (instancetype)create:(NSString *)key {
    return [self create:key isTask:NO];
}

+ (instancetype)create:(NSString *)key isTask:(BOOL)isTask {
    BEAlgorithmKey *obj = [[self alloc] init];
    obj.algorithmKey = key;
    obj.isTask = isTask;
    return obj;
}


- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:[BEAlgorithmKey class]]) {
        return NO;
    } else {
        return [self.algorithmKey isEqualToString:[(BEAlgorithmKey *)other algorithmKey]];
    }
}

- (NSUInteger)hash
{
    return [self.algorithmKey hash];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    BEAlgorithmKey * copy = [[[self class] alloc] init];
    copy.algorithmKey = self.algorithmKey;
    copy.isTask = self.isTask;
    return copy;
}

@end
