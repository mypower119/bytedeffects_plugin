//
//  BEAlgorithmManager.m
//  BytedEffectSDK
//
//  Created by qun on 2021/5/11.
//

#import "BEAlgorithmTask.h"

@interface BEAlgorithmTask () {
    id<BEAlgorithmResourceProvider> _provider;
    id<BELicenseProvider> _licenseProvider;
}

@property (nonatomic, strong) NSMutableDictionary<BEAlgorithmKey *, NSObject *> *config;

@end

@implementation BEAlgorithmTask

+ (BEAlgorithmKey *)ALGORITHM_FOV {
    GET_TASK_KEY(algorithmFov, NO)
}

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>) licenseProvider {
    self = [self init];
    if (self) {
        _provider = provider;
        _licenseProvider = licenseProvider;
        _config = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setConfig:(BEAlgorithmKey *)key p:(NSObject *)p {
    self.config[key] = p;
}

- (BOOL)boolConfig:(BEAlgorithmKey *)key orDefault:(BOOL)orDefault {
    if ([self.config.allKeys containsObject:key]) {
        return [(NSNumber *)self.config[key] boolValue];
    }
    return orDefault;
}

- (float)floatConfig:(BEAlgorithmKey *)key orDefault:(float)orDefault {
    if ([self.config.allKeys containsObject:key]) {
        return [(NSNumber *)self.config[key] floatValue];
    }
    return orDefault;
}

@end
