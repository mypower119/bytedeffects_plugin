//
//  BEPetFaceListViewController.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/15.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>

#import "BEPetFaceInfoVC.h"
#import "BEPetFacePropertyView.h"

@interface BEPetFaceInfoVC ()

@property (nonatomic, strong) NSMutableArray<BEPetFacePropertyView *> *reusedView;
@property (nonatomic, assign) bef_ai_pet_face_result result;

@end


@implementation BEPetFaceInfoVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = NO;
}

#pragma mark - public

- (void)updateWithResult:(bef_ai_pet_face_result)result {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < result.face_count; i++) {
        [self be_showDialog:result.p_faces[i] index:i];
    }
    
    [self.view setNeedsLayout];
}

#pragma mark - private
- (void)be_showDialog:(bef_ai_pet_face_info)info index:(NSInteger)index {
    BEPetFacePropertyView *view;
    if (self.reusedView.count > index) {
        view = self.reusedView[index];
    } else {
        view = [BEPetFacePropertyView new];
        [self.reusedView addObject:view];
    }
    
    CGFloat left = [self offsetXWithRect:info.rect];
    CGFloat top = [self offsetYWithRect:info.rect];
    if (left < 0) left = 0;
    if (top < 50) top = 50;
    
    [self.view addSubview:view];
    [view setPetFaceInfo:info];
    view.frame = CGRectMake(left, top-50, 130, 55);
}

#pragma mark - getter
- (NSMutableArray<BEPetFacePropertyView *> *)reusedView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reusedView = [NSMutableArray array];
    });
    return _reusedView;
}

@end
