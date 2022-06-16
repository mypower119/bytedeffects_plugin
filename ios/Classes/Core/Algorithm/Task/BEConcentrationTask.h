//
//  BEConcentrationTask.h
//  BytedEffects
//
//  Created by qun on 2020/9/1.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"

@protocol BEConcentrationResourceProvider <BEFaceResourceProvider>

@end

@interface BEConcentrationAlgorithmResult : NSObject

@property (nonatomic, assign) float proportion;

@end

@interface BEConcentrationTask : BEAlgorithmTask

+ (BEAlgorithmKey *)CONCENTRATION;

@end
