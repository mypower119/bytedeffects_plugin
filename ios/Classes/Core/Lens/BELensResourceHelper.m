//
//  BELensResourceHelper.m
//  Lens
//
//  Created by qun on 2021/6/7.
//

#import "BELensResourceHelper.h"
#import "macro.h"

static NSString *LICENSE_PATH = @"LicenseBag";
static NSString *MODEL_PATH = @"ModelResource";
static NSString *BUNDLE = @"bundle";

@interface BELensResourceHelper () {
    NSString            *_licensePrefix;
}

@end

@implementation BELensResourceHelper

- (NSString *)licensePath {
    NSString *licenseName = [NSString stringWithFormat:@"/%s", LICENSE_NAME];
    if (!_licensePrefix) {
        _licensePrefix = [[NSBundle mainBundle] pathForResource:LICENSE_PATH ofType:BUNDLE];
    }
    return [_licensePrefix stringByAppendingString:licenseName];
}

- (NSString *)videoSRModelPath {
    return nil;
}


@end
