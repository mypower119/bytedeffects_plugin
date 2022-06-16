//
//  BECarInfoVC.h
//  BytedEffects
//
//  Created by qun on 2020/9/4.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEBaseFloatInfoVC.h"
#import "bef_effect_ai_car_detect.h"

@interface BECarInfoVC : BEBaseFloatInfoVC

@property (nonatomic, assign) BOOL detectCar;
@property (nonatomic, assign) BOOL detectBrand;

- (void)updateCarInfo:(bef_ai_car_ret *)carInfo;
@end
