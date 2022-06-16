//
//  BECarDamageDetectTask.h
//  BytedEffects
//
//  Created by qun on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "bef_effect_ai_car_detect.h"

@protocol BECarResourceProvider <BEAlgorithmResourceProvider>

- (const char *)carDetectModel;
- (const char *)carLandmarkModel;
- (const char *)carPlateOcrModel;
- (const char *)carTrackModel;

@end

@interface BECarAlgorithmResult : NSObject

@property (nonatomic, assign) bef_ai_car_ret *carInfo;

@end

@interface BECarDetectTask : BEAlgorithmTask

+ (BEAlgorithmKey *)CAR;

+ (BEAlgorithmKey *)CAR_DETECT;

+ (BEAlgorithmKey *)CAR_BRAND_DETECT;
@end
