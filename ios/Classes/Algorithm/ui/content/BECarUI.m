//
//  BECarUI.m
//  BytedEffects
//
//  Created by qun on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BECarUI.h"
#import "BECarDetectTask.h"
#import "BECarInfoVC.h"
#import "BELocaleManager.h"

@interface BECarUI () {
    BOOL            _carDetect;
    BOOL            _brandDetect;
}

@property (nonatomic, strong) BECarInfoVC *vcInfo;

@end

@implementation BECarUI

- (void)onReceiveResult:(BECarAlgorithmResult *)result {
    if (result == nil || result.carInfo == nil) {
        return;
    }
    
    bef_ai_car_ret *carInfo = result.carInfo;
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.vcInfo setImageSize:self.provider.imageSize rotation:self.provider.imageRotation];
    [self.vcInfo updateCarInfo:carInfo];
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    if ([key isEqual:BECarDetectTask.CAR_DETECT]) {
        _carDetect = flag;
    } else if ([key isEqual:BECarDetectTask.CAR_BRAND_DETECT]) {
        _brandDetect = flag;
    }
//    [super onEvent:BECarDetectTask.CAR flag:_carDetect || _brandDetect];
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:_carDetect || _brandDetect];
    self.vcInfo.detectCar = _carDetect;
    self.vcInfo.detectBrand = _brandDetect;
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *carDetect = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_car_detect_highlight"
                                                                  unselectImg:@"ic_car_detect_normal"
                                                                        title:@"car_detect"
                                                                         desc:@""];
    carDetect.key = BECarDetectTask.CAR_DETECT;
    BEAlgorithmItem *carBrand = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_car_brand_highlight"
                                                              unselectImg:@"ic_car_brand_normal"
                                                                    title:@"car_brand_detect"
                                                                     desc:@""];
    carBrand.key = BECarDetectTask.CAR_BRAND_DETECT;
    
    BEAlgorithmItemGroup *group = [[BEAlgorithmItemGroup alloc] init];
    group.title = @"feature_car";
    if (BELocaleManager.isSupportCarBrandDetect) {
        group.items = [NSArray arrayWithObjects:carDetect, carBrand, nil];
    } else {
        group.items = [NSArray arrayWithObjects:carDetect, nil];
    }
    group.key = BECarDetectTask.CAR;
    
    return group;
}

- (BECarInfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [[BECarInfoVC alloc] init];
    }
    return _vcInfo;
}

@end
