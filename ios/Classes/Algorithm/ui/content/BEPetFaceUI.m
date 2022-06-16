//
//  BEPetFaceUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEPetFaceUI.h"
#import "BEPetFaceInfoVC.h"
#import "BEPetFaceAlgorithmTask.h"

@interface BEPetFaceUI () {
    
}

@property (nonatomic, strong) BEPetFaceInfoVC *vcInfo;

@end

@implementation BEPetFaceUI

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
}

- (void)onReceiveResult:(BEPetFaceAlgorithmResult *)result {
    if (result == nil || result.petFaceInfo == nil) {
        return;
    }
    
    bef_ai_pet_face_result petFaceInfo = *result.petFaceInfo;
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.vcInfo setImageSize:self.provider.imageSize rotation:self.provider.imageRotation];
    [self.vcInfo updateWithResult:petFaceInfo];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *petFace = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_pet_face_highlight"
                                                              unselectImg:@"ic_pet_face_normal"
                                                                    title:@"feature_cat_face"
                                                                     desc:@"pet_face_desc"];
    petFace.key = BEPetFaceAlgorithmTask.PET_FACE;
    return petFace;
}

- (BEPetFaceInfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [[BEPetFaceInfoVC alloc] init];
    }
    return _vcInfo;
}

@end
