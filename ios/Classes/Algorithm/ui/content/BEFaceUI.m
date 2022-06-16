//
//  BEFaceUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEFaceUI.h"
#import "BEFaceInfoVC.h"

@interface BEFaceUI () {
    BOOL            _enable106;
}

@property (nonatomic, strong) BEFaceInfoVC *vcInfo;

@end

@implementation BEFaceUI

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enable106 = NO;
    }
    return self;
}

- (void)onReceiveResult:(BEFaceAlgorithmResult *)result {
    if (result == nil || result.faceInfo == nil) {
        return;
    }
    
    bef_ai_face_info faceInfo = *result.faceInfo;
    int count = faceInfo.face_count;
    [self.vcInfo updateFaceInfo:faceInfo.base_infos[0] faceCount:count];

    if (result.faceAttrInfo == nil) {
        self.vcInfo.showAttrInfo = NO;
    } else {
        self.vcInfo.showAttrInfo = YES;
        [self.vcInfo updateFaceExtraInfo:result.faceAttrInfo];
    }
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    BOOL showInfo = _enable106;
    if ([key isEqual:BEFaceAlgorithmTask.FACE_ATTR] ) {
        
    } else if ([key isEqual:BEFaceAlgorithmTask.FACE_106]) {
        showInfo = flag;
    }
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    if (showInfo != _enable106) {
        [self.provider showOrHideVC:self.vcInfo show:showInfo];
        _enable106 = showInfo;
    }
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *face106 = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_face_106_highlight"
                                                              unselectImg:@"ic_face_106_normal"
                                                                    title:@"setting_face"
                                                                     desc:@"face_106_desc"];
    face106.key = BEFaceAlgorithmTask.FACE_106;
    BEAlgorithmItem *face280 = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_face_280_highlight"
                                                              unselectImg:@"ic_face_280_normal"
                                                                    title:@"setting_face_extra"
                                                                     desc:@"face_280_desc"];
    face280.key = BEFaceAlgorithmTask.FACE_280;
    face280.dependency = [NSArray arrayWithObject:face106.key];
    face280.dependencyToast = @"open_face106_fist";
    
    BEAlgorithmItem *faceAttr = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_face_attr_highlight"
                                                               unselectImg:@"ic_face_attr_normal"
                                                                     title:@"face_attr_title"
                                                                      desc:@"face_attr_desc"];
    
    faceAttr.key = BEFaceAlgorithmTask.FACE_ATTR;
    faceAttr.dependency = [NSArray arrayWithObject:face106.key];
    faceAttr.dependencyToast = @"open_face106_fist";
    
    BEAlgorithmItem *face_mask = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_face_mask_highlight"
                                                                unselectImg:@"ic_face_mask_normal"
                                                                      title:@"setting_face_mask"
                                                                       desc:@"face_mask_desc"];
    face_mask.key = BEFaceAlgorithmTask.FACE_MASK;
    face_mask.dependency = [NSArray arrayWithObject:face280.key];
    face_mask.dependencyToast = @"open_face280_fist";
    
    BEAlgorithmItem *mouth_mask = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_mouth_mask_highlight"
                                                                unselectImg:@"ic_mouth_mask_normal"
                                                                      title:@"setting_mouth_mask"
                                                                       desc:@"mouth_mask_desc"];
    mouth_mask.key = BEFaceAlgorithmTask.MOUTH_MASK;
    mouth_mask.dependency = [NSArray arrayWithObject:face280.key];
    mouth_mask.dependencyToast = @"open_face280_fist";
    
    
    BEAlgorithmItem *teeth_mask = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_teeth_mask_highlight"
                                                                unselectImg:@"ic_teeth_mask_normal"
                                                                      title:@"setting_teeth_mask"
                                                                       desc:@"teeth_mask_desc"];
    teeth_mask.key = BEFaceAlgorithmTask.TEETH_MASK;
    teeth_mask.dependency = [NSArray arrayWithObject:face280.key];
    teeth_mask.dependencyToast = @"open_face280_fist";
    
    BEAlgorithmItemGroup *group = [[BEAlgorithmItemGroup alloc] init];
    group.items = [NSArray arrayWithObjects:face106, face280, faceAttr, mouth_mask, teeth_mask, face_mask, nil];
    
    group.title = @"feature_face";
    group.key = BEFaceAlgorithmTask.FACE_106;
    group.scrollable = YES;
    return group;
}

- (BEFaceInfoVC *)vcInfo {
    if (!_vcInfo) {
        _vcInfo = [BEFaceInfoVC new];
    }
    return _vcInfo;
}

@end
