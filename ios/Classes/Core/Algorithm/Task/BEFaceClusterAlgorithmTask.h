//
//  BEFaceClusterAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/10.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "BEFaceVerifyAlgorithmTask.h"
#import <UIKit/UIKit.h>

@protocol BEFaceClusterResourceProvider <BEFaceVerifyResourceProvider>

@end


@interface BEFaceClusterAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)FACE_CLUSTER;

- (NSMutableDictionary<NSNumber *, NSMutableArray *> *)faceClusterImages:(NSArray<UIImage *> *)images;

@end
