//
//  BEPetFacePropertyView.m
//  BytedEffects
//
//  Created by QunZhang on 2019/8/15.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "Masonry.h"

#import "BEPetFacePropertyView.h"
#import "BEPropertyTextView.h"
#import "BEActionView.h"

@interface BEPetFacePropertyView ()

@property (nonatomic, strong) BEPropertyTextView *tv;
@property (nonatomic, strong) BEActionView *av;

@end


@implementation BEPetFacePropertyView

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self addSubview:self.tv];
        [self addSubview:self.av];
        
        [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.equalTo(self);
            make.leading.equalTo(self);
            make.height.mas_equalTo(25);
        }];
        [self.av mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tv.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [self.tv setTitle:NSLocalizedString(@"pet_type", nil)];
    }
    return self;
}

#pragma mark - public
- (void)setPetFaceInfo:(bef_ai_pet_face_info)info {
    NSString *petType = [self be_getPetType:info.type];
    [self.tv setValue:petType];
    
    NSInteger action = info.action;
    [self.av clearSelect];
    for (int i = 0; i < 3; i++) {
        if (action & (1 << i)) {
            [self.av setSelect:i];
        }
    }
    
    [self setNeedsDisplay];
}

#pragma mark - private
- (NSString *)be_getPetType:(NSInteger)type {
    switch (type) {
        case BEF_CAT:
            return NSLocalizedString(@"pet_type_cat", nil);
        case BEF_DOG:
            return NSLocalizedString(@"pet_type_dog", nil);
        default:
            return @"unknown";
    }
}

#pragma mark - getter
- (BEPropertyTextView *)tv {
    if (!_tv) {
        _tv = [BEPropertyTextView new];
    }
    return _tv;
}

- (BEActionView *)av {
    if (!_av) {
        _av = [[BEActionView alloc] initWithTitles:[self titles] column:3 frame:CGRectMake(0, 0, 120, 50)];
        _av.highlightTextColor = [UIColor whiteColor];
        _av.normalTextColor = [UIColor colorWithWhite:0.6 alpha:1];
    }
    return _av;
}

- (NSArray<NSString *> *)titles {
    return @[
             NSLocalizedString(@"pet_left_eye", nil),
             NSLocalizedString(@"pet_right_eye", nil),
             NSLocalizedString(@"pet_mouth", nil),
             ];
}

@end
