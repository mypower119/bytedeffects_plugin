//
//  BECarInfoVC.m
//  BytedEffects
//
//  Created by qun on 2020/9/4.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BECarInfoVC.h"
#import "BECarInfoView.h"
#import "BECarQuilityView.h"
#import "Masonry.h"
#import "Common.h"

static const float GRAY_THRESHOLD = 40.f;
static const float BLUR_THRESHOLD = 5.f;

@interface BECarInfoVC ()

@property (nonatomic, strong) NSMutableArray<BECarInfoView *> *reusedBrandView;
@property (nonatomic, strong) NSMutableArray<BECarInfoView *> *reusedCarView;
@property (nonatomic, strong) BECarQuilityView *quilityView;

@end

@implementation BECarInfoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.userInteractionEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.quilityView];
    [self.quilityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.view).offset(ALGORITHM_INFO_TOP_MARGIN);
    }];
}

- (void)updateCarInfo:(bef_ai_car_ret *)carInfo {
    [self.reusedCarView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.reusedBrandView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.detectCar) {
        [self be_showCarQuility:*carInfo];
        
        if (carInfo->car_count > 0) {
            for (int i = 0; i < carInfo->car_count; ++i) {
                [self be_showCar:carInfo->car_boxes[i] index:i];
            }
        }
    }
    
    if (self.detectBrand) {
        if (carInfo->brand_count > 0) {
            for (int i = 0; i < carInfo->brand_count; ++i) {
                [self be_showBrand:carInfo->base_infos[i] index:i];
            }
        }
    }
    
    [self.view setNeedsLayout];
}

- (void)setDetectCar:(BOOL)detectCar {
    _detectCar = detectCar;
    self.quilityView.hidden = !detectCar;
    if (!detectCar) {
        [self.reusedCarView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)setDetectBrand:(BOOL)detectBrand {
    _detectBrand = detectBrand;
    if (!detectBrand) {
        [self.reusedBrandView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - private
- (void)be_showCarQuility:(bef_ai_car_ret)info {
    [self.quilityView updateQuility:info.gray_score > GRAY_THRESHOLD blur:info.blur_score > BLUR_THRESHOLD];
}

- (void)be_showCar:(bef_ai_car_bounding_box)info index:(NSInteger)index {
    BECarInfoView *view;
    if (self.reusedCarView.count > index) {
        view = self.reusedCarView[index];
    } else {
        view = [BECarInfoView new];
        [self.reusedCarView addObject:view];
    }
    
    CGFloat left = [self offsetX:[self carX:info]];
    CGFloat top = [self offsetY:[self carY:info]];
    if (left < 0) left = 0;
    if (top < 25) top = 25;
    
    [self.view addSubview:view];
    NSString *orientation = [self orientationArray][info.orient];
    [view updateInfo:orientation];
    view.frame = CGRectMake(left, top - 25, 100, 25);
}

- (void)be_showBrand:(bef_ai_car_brand_info)info index:(NSInteger)index {
    BECarInfoView *view;
    if (self.reusedBrandView.count > index) {
        view = self.reusedBrandView[index];
    } else {
        view = [BECarInfoView new];
        [self.reusedBrandView addObject:view];
    }
    
    CGFloat left = [self offsetX:[self carBrandX:info]];
    CGFloat top = [self offsetY:[self carBrandY:info]];
    if (left < 0) left = 0;
    if (top < 25) top = 25;
    
    [self.view addSubview:view];
    NSString *brand = @"";
    for (int i = 0; i < info.brand_vi_len; i++) {
        brand = [brand stringByAppendingString:[self brandArray][info.brand_vi[i]]];
    }
    [view updateInfo:brand];
    view.frame = CGRectMake(left, top - 25, 100, 25);
}

#pragma mark - getter
- (NSMutableArray<BECarInfoView *> *)reusedBrandView {
    if (_reusedBrandView == nil) {
        _reusedBrandView = [NSMutableArray array];
    }
    return _reusedBrandView;
}

- (NSMutableArray<BECarInfoView *> *)reusedCarView {
    if (_reusedCarView == nil) {
        _reusedCarView = [NSMutableArray array];
    }
    return _reusedCarView;
}

- (BECarQuilityView *)quilityView {
    if (_quilityView == nil) {
        _quilityView = [[BECarQuilityView alloc] init];
    }
    return _quilityView;
}

- (NSArray<NSString *> *)brandArray {
    static NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[
        @"",   @"0",  @"1",  @"2",  @"3",  @"4",  @"5",  @"6",  @"7",  @"8",  @"9",  @"A",  @"B",  @"C",
        @"D",  @"E",  @"F",  @"G",  @"H",  @"J",  @"K",  @"L",  @"M",  @"N",  @"P",  @"Q",  @"R",  @"S",
        @"T",  @"U",  @"V",  @"W",  @"X",  @"Y",  @"Z",
        @"云", @"京", @"冀", @"吉", @"宁", @"川", @"新", @"晋", @"桂", @"沪", @"津", @"浙",
        @"渝", @"湘", @"琼", @"甘", @"皖", @"粤", @"苏", @"蒙", @"藏", @"豫", @"贵", @"赣",
        @"辽", @"鄂", @"闽", @"陕", @"青", @"鲁", @"黑"];
    });
    return arr;
}

- (NSArray<NSString *> *)orientationArray {
    static NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[
            NSLocalizedString(@"car_direction_zhengqian", nil),
            NSLocalizedString(@"car_direction_zhengzhou", nil),
            NSLocalizedString(@"car_direction_zuoce", nil),
            NSLocalizedString(@"car_direction_youce", nil),
            
            NSLocalizedString(@"car_direction_zuoceqian", nil),
            NSLocalizedString(@"car_direction_youceqian", nil),
            NSLocalizedString(@"car_direction_zuocehou", nil),
            NSLocalizedString(@"car_direction_youcehou", nil),
        ];
    });
    return arr;
}

- (int)carX:(bef_ai_car_bounding_box)info {
    return self.isLandscape ? self.imageSize.width - info.y1 : info.x0;
}

- (int)carY:(bef_ai_car_bounding_box)info {
    return self.isLandscape ? info.x0 : info.y0;
}

- (int)carBrandX:(bef_ai_car_brand_info)info {
    return self.isLandscape ? self.imageSize.width - info.points_array[0].y : info.points_array[1].x;
}

- (int)carBrandY:(bef_ai_car_brand_info)info {
    return self.isLandscape ? info.points_array[2].x : info.points_array[1].y;
}

@end
