//
//  BEProfileRecordManager.m
//  Common
//
//  Created by qun on 2021/6/7.
//

#import "BEProfileRecordManager.h"

static double REFRESH_INTERVAL = 0.5;

@interface BEProfileRecordManager ()

@property (nonatomic, assign) double lastRefreshTime;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *frameTimes;

@property (nonatomic, assign) double frameTime;
@property (nonatomic, assign) double frameCount;

@end

@implementation BEProfileRecordManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _frameTimes = [NSMutableArray array];
    }
    return self;
}

- (void)record {
    double time = [NSDate date].timeIntervalSince1970;
    while (self.frameTimes.count > 0 && time - [self.frameTimes[0] doubleValue] > 1) {
        [self.frameTimes removeObjectAtIndex:0];
    }
    [self.frameTimes addObject:[NSNumber numberWithDouble:time]];
}

- (double)frameTime {
    double time = [NSDate date].timeIntervalSince1970;
    if (time - _lastRefreshTime < REFRESH_INTERVAL) {
        return _frameTime;
    }
    
    [self be_refresh];
    
    return _frameTime;
}

- (int)frameCount {
    double time = [NSDate date].timeIntervalSince1970;
    if (time - _lastRefreshTime < REFRESH_INTERVAL) {
        return _frameCount;
    }
    
    [self be_refresh];
    
    return _frameCount;
}

#pragma mark - refresh
- (void)be_refresh {
    _lastRefreshTime = [NSDate date].timeIntervalSince1970;
    
    _frameCount = self.frameTimes.count;
    
    if (self.frameTimes.count < 2) {
        _frameTime = 0;
    } else {
        double last1 = [self.frameTimes.lastObject doubleValue];
        double last2 = [self.frameTimes[self.frameTimes.count - 2] doubleValue];
        _frameTime = last1 - last2;
    }
}

@end
