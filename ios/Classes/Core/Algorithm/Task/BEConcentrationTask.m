//
//  BEConcentrationTask.m
//  BytedEffects
//
//  Created by qun on 2020/9/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEConcentrationTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "BEFaceAlgorithmTask.h"

static const float MIN_YAW = -14;
static const float MAX_YAW = 7;
static const float MIN_PITCH = -12;
static const float MAX_PITCH = 12;

@implementation BEConcentrationAlgorithmResult

@end
@interface BEConcentrationTask () {
    BEFaceAlgorithmTask     *_faceTask;
    
    int                 _totalCount;
    int                 _concentrationCount;
    double              _lastProcess;
}

@property (nonatomic, strong) id<BEConcentrationResourceProvider> provider;

@end

@implementation BEConcentrationTask

@dynamic provider;

+ (BEAlgorithmKey *)CONCENTRATION {
    GET_TASK_KEY(concentration, YES)
}

- (instancetype)initWithProvider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>)licenseProvider {
    if (self = [super initWithProvider:provider licenseProvider:licenseProvider]) {
        _faceTask = [[BEFaceAlgorithmTask alloc] initWithProvider:provider licenseProvider:licenseProvider];
    }
    return self;
}

- (int)initTask {
    _lastProcess = 0;
    return [_faceTask initTask];
}

- (BEConcentrationAlgorithmResult *)process:(const unsigned char *)buffer width:(int)widht height:(int)height stride:(int)stride format:(bef_ai_pixel_format)format rotation:(bef_ai_rotate_type)rotation {
    BEConcentrationAlgorithmResult *result = [BEConcentrationAlgorithmResult new];
    
    BEFaceAlgorithmResult *faceRet = [_faceTask process:buffer width:widht height:height stride:stride format:format rotation:rotation];
    bef_ai_face_info *faceInfo = faceRet.faceInfo;
    if (faceInfo == nil) {
        return result;
    }
    
    if ([NSDate date].timeIntervalSince1970 - _lastProcess < 1) {
        result.proportion = _totalCount > 0 ? _concentrationCount * 1.f / _totalCount : 0;
        return result;
    }
    _lastProcess = [NSDate date].timeIntervalSince1970;
    if (faceInfo->face_count > 0) {
        bef_ai_face_106 face106 = faceInfo->base_infos[0];
        bool concentration = face106.yaw >= MIN_YAW && face106.yaw <= MAX_YAW && face106.pitch >= MIN_PITCH && face106.pitch <= MAX_PITCH;
        _totalCount += 1;
        if (concentration) {
            _concentrationCount += 1;
        }
    } else {
        _totalCount = 0;
        _concentrationCount = 0;
    }
    
    result.proportion = _totalCount > 0 ? _concentrationCount * 1.f / _totalCount : 0;
    return result;
}

- (int)destroyTask {
    [_faceTask destroyTask];
    return 0;
}

- (BEAlgorithmKey *)key {
    return BEConcentrationTask.CONCENTRATION;
}

@end

