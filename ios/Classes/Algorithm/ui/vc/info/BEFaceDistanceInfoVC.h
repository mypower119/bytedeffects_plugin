//  Copyright © 2019 ailab. All rights reserved.
//

#import "BEBaseFloatInfoVC.h"
#import "bef_effect_ai_face_detect.h"
#import "bef_effect_ai_human_distance.h"

NS_ASSUME_NONNULL_BEGIN

@interface BEFaceDistanceInfoVC: BEBaseFloatInfoVC

- (void)updateFaceDistance:(bef_ai_face_info)faceInfo distance:(bef_ai_human_distance_result)distance;

@end

NS_ASSUME_NONNULL_END

