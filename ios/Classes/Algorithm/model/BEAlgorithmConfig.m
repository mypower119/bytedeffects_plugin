//
//  BEAlgorithmConfig.m
//  Algorithm
//
//  Created by qun on 2021/5/23.
//

#import "BEAlgorithmConfig.h"

NSString *ALGORITHM_CONFIG_KEY = @"ALGORITHM_CONFIG_KEY";

@implementation BEAlgorithmConfig

@synthesize algorithmKey = _algorithmKey;
@synthesize algorithmParams = _algorithmParams;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showBoard = YES;
        _topBarMode = 15;
    }
    return self;
}

#pragma mark getter
+ (BEAlgorithmConfig *(^)(void))newInstance {
    return ^id() {
        return [[BEAlgorithmConfig alloc] init];
    };
}

- (BEAlgorithmConfig *(^)(NSString *))typeW {
    return ^id(NSString *type) {
        self.type = type;
        return self;
    };
}

- (BEAlgorithmConfig *(^)(NSDictionary<NSString *,NSObject *> *))paramsW {
    return ^id(NSDictionary<NSString *,NSObject *> *params) {
        self.params = params;
        return self;
    };
}

- (BEAlgorithmConfig *(^)(NSInteger))topBarModeW {
    return ^id(NSInteger mode) {
        self.topBarMode = mode;
        return self;
    };
}

- (BEAlgorithmKey *)algorithmKey {
    if (_algorithmKey) {
        return _algorithmKey;
    }
    _algorithmKey = [BEAlgorithmKey create:self.type isTask:YES];
    return _algorithmKey;
}

- (NSDictionary<BEAlgorithmKey *,NSObject *> *)algorithmParams {
    if (_algorithmParams) {
        return _algorithmParams;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *s in self.params.allKeys) {
        [dict setObject:self.params[s] forKey:[BEAlgorithmKey create:s]];
    }
    _algorithmParams = [dict copy];
    return _algorithmParams;
}

@end
