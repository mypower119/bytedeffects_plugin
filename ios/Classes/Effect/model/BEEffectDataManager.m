// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import "BEEffectDataManager.h"
#import "BEEffectResourceHelper.h"
#import "Common.h"

@interface BEEffectDataManager ()

@property (nonatomic, assign) BEEffectNode type;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, BEEffectItem *> *savedItems;

@end


@implementation BEEffectDataManager

- (instancetype)initWithType:(BEEffectType)type {
    self = [super init];
    if (self) {
        _effectType = type;
        _savedItems = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - public

- (BEEffectItem *)buttonItem:(BEEffectNode)type {
    if ([self.savedItems.allKeys containsObject:@(type)]) {
        return self.savedItems[@(type)];
    }
    
    BEEffectItem *item = nil;
    switch (type) {
        case BETypeBeautyFace:
            item = [self be_beautyFaceItem];
            break;
        case BETypeBeautyReshape:
            item = [self be_beautyReshapeItem];
            break;
        case BETypeBeautyBody:
            item = [self be_beautyBodyItem];
            break;
        case BETypeMakeup:
            item = [self be_makeupItem];
            break;
        case BETypeMakeupLipstickShine:
            item = [self be_makeupItemLipstickShine];
            break;
        case BETypeMakeupLipstickMatte:
            item = [self be_makeupItemLipstickMatte];
            break;
        case BETypeStyleMakeup:
            item = [self be_styleMakeupItem];
            break;
        case BETypeStyleHairColor:
            item = [self be_styleHairColor];
            break;
        case BETypeStyleHairDyeFull:
            item = [self be_styleHairDyeFull];
            break;
        case BETypeStyleHighlights:
            item = [self be_styleHighlights];
            break;
        default:
            break;
    }
    
    [self.savedItems setObject:item forKey:@(type)];
    return item;
}

- (NSDictionary *)hairDyeFullColor:(NSString *)key ItemColor:(BEEffectColorItem *)color {
    if ([key isEqualToString:@"hair_anlan"]) {
        return @{@"r":@"0.059",@"g":@"0.224",@"b":@"0.333",@"a":@"1.0"};
    } else if ([key isEqualToString:@"hair_molv"]) {
        return @{@"r":@"0.318",@"g":@"0.361",@"b":@"0.251",@"a":@"1.0"};
    } else if ([key isEqualToString:@"hair_shenzong"]) {
        return @{@"r":@"0.298",@"g":@"0.11",@"b":@"0.051",@"a":@"1.0"};
    } else if ([key isEqualToString:@"Internal_Makeup_airColor_a"] ||[key isEqualToString:@"Internal_Makeup_airColor_b"] ||[key isEqualToString:@"Internal_Makeup_airColor_c"]  ||[key isEqualToString:@"Internal_Makeup_airColor_d"] ) {
        return @{@"r":[NSString stringWithFormat:@"%f",color.red],@"g":[NSString stringWithFormat:@"%f",color.green],@"b":[NSString stringWithFormat:@"%f",color.blue],@"a":@"1.0"};
    }
    return @{@"r":@"1.0",@"g":@"1.0",@"b":@"1.0",@"a":@"0.0"};
}

- (NSInteger)hairDyeFullIndex:(NSString *)key {
    if ([key isEqualToString:@"hair_anlan"] || [key isEqualToString:@"hair_molv"] || [key isEqualToString:@"hair_shenzong"] || [key isEqualToString:@"hair_DyeFullClose"]) {
        return BEEffectPart_5;
    } else if ([key isEqualToString:@"Internal_Makeup_airColor_a"]) {
        return BEEffectPart_1;
    } else if ([key isEqualToString:@"Internal_Makeup_airColor_b"]) {
        return BEEffectPart_2;
    } else if ([key isEqualToString:@"Internal_Makeup_airColor_c"]) {
        return BEEffectPart_3;
    } else if ([key isEqualToString:@"Internal_Makeup_airColor_d"] ) {
        return BEEffectPart_4;
    } else if ([key isEqualToString:@"Internal_Makeup_airColor_Close"] ) {
        return BEEffectPart_6;
    }
    return 0;
}

- (NSArray<BEEffectCategoryModel *> *)effectCategoryModelArray {
    static NSArray *effectCategoryModelArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        effectCategoryModelArray = @[
            [BEEffectCategoryModel categoryWithType:BETypeBeautyFace title:NSLocalizedString(@"tab_face_beautification", nil)],
            [BEEffectCategoryModel categoryWithType:BETypeBeautyReshape title:NSLocalizedString(@"tab_beauty_reshape", nil)],
            [BEEffectCategoryModel categoryWithType:BETypeBeautyBody title:NSLocalizedString(@"tab_beauty_body", nil)],
            [BEEffectCategoryModel categoryWithType:BETypeMakeup title:NSLocalizedString(@"tab_face_makeup", nil)],
            [BEEffectCategoryModel categoryWithType:BETypeFilter title:NSLocalizedString(@"tab_filter", nil)],
        ];
    });
    return effectCategoryModelArray;
}

- (NSArray<BEEffectCategoryModel *> *)effectCategoryModelLipstickArray {
    static NSArray *effectCategoryModelLipstickArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        effectCategoryModelLipstickArray = @[
            [BEEffectCategoryModel categoryWithType:BETypeMakeupLipstickShine title:NSLocalizedString(@"tab_lipstick_glossy", nil)],
            [BEEffectCategoryModel categoryWithType:BETypeMakeupLipstickMatte title:NSLocalizedString(@"tab_lipstick_matte", nil)]
        ];
    });
    return effectCategoryModelLipstickArray;
}

- (NSArray<BEEffectCategoryModel *> *)effectCategoryModelHairColorArray {
    static NSArray *effectCategoryModelHairColorArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        effectCategoryModelHairColorArray = @[
            [BEEffectCategoryModel categoryWithType:BETypeStyleHairDyeFull title:NSLocalizedString(@"tab_hair_dye_full", nil)],
            [BEEffectCategoryModel categoryWithType:BETypeStyleHighlights title:NSLocalizedString(@"tab_hair_dye_highlight", nil)]
        ];
    });
    return effectCategoryModelHairColorArray;
}

- (BEEffectItem *)be_styleHairDyeFull {
    return [BEEffectItem initWithId:BETypeStyleHairDyeFull
                           children: @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconFilter_filter_normal"
         unselectImg:@"iconFilter_filter_normal"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"hair_DyeFullClose"]
         tipTitle:@""
         showIntensityBar:NO
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeMakeupHair
         selectImg:@"ic_icon_anlan"
         unselectImg:@"ic_icon_anlan"
         title:NSLocalizedString(@"hair_dye_dark_blue", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"hair_anlan"]
         tipTitle:@""
         showIntensityBar:NO
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeMakeupHair
         selectImg:@"ic_icon_molv"
         unselectImg:@"ic_icon_molv"
         title:NSLocalizedString(@"hair_dye_black_green", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"hair_molv"]
         tipTitle:@""
         showIntensityBar:NO
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeMakeupHair
         selectImg:@"ic_icon_shenzong"
         unselectImg:@"ic_icon_shenzong"
         title:NSLocalizedString(@"hair_dye_dark_brown", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"hair_shenzong"]
         tipTitle:@""
         showIntensityBar:NO
         type:BETypeHairColor],
    ]];
}

- (BEEffectItem *)be_styleHighlights {
    NSArray *colorset = @[
        [[BEEffectColorItem alloc]
                             initWithTitle:NSLocalizedString(@"hair_dye_blue_haze", nil) red:0.541f green:0.616f blue:0.706f],
        [[BEEffectColorItem alloc]
                             initWithTitle:NSLocalizedString(@"hair_dye_foggy_gray", nil) red:0.808f green:0.792f blue:0.745f],
        [[BEEffectColorItem alloc]
                             initWithTitle:NSLocalizedString(@"hair_dye_rose_red", nil) red:0.384f green:0.075f blue:0.086f]
    ];
    return [BEEffectItem initWithId:BETypeStyleHairColor
                           children: @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconFilter_filter_normal"
         unselectImg:@"iconFilter_filter_normal"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"Internal_Makeup_airColor_Close"]
         tipTitle:@""
         colorset:colorset
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeStyleHairColorA
         selectImg:@"ic_icon_part_a"
         unselectImg:@"ic_icon_part_a"
         title:NSLocalizedString(@"hair_dye_part_a", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"Internal_Makeup_airColor_a"]
         tipTitle:@""
         colorset:colorset
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeStyleHairColorB
         selectImg:@"ic_icon_part_b"
         unselectImg:@"ic_icon_part_b"
         title:NSLocalizedString(@"hair_dye_part_b", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"Internal_Makeup_airColor_b"]
         tipTitle:@""
         colorset:colorset
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeStyleHairColorC
         selectImg:@"ic_icon_part_c"
         unselectImg:@"ic_icon_part_c"
         title:NSLocalizedString(@"hair_dye_part_c", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"Internal_Makeup_airColor_c"]
         tipTitle:@""
         colorset:colorset
         type:BETypeHairColor],
        
        [BEEffectItem
         initWithID:BETypeStyleHairColorD
         selectImg:@"ic_icon_part_d"
         unselectImg:@"ic_icon_part_d"
         title:NSLocalizedString(@"hair_dye_part_d", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/ranfa" key:@"Internal_Makeup_airColor_d"]
         tipTitle:@""
         colorset:colorset
         type:BETypeHairColor],
    ]];
}

- (BEEffectItem *)be_styleHairColor {
    return [BEEffectItem initWithId:BETypeBeautyFace
                           children: @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected"
         unselectImg:@"iconCloseButtonNormal"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        
        [BEEffectItem
         initWithID:BETypeMakeupHair
         selectImg:@"iconFaceMakeUpHairSelected"
         unselectImg:@"iconFaceMakeUpHairNormal"
         title:NSLocalizedString(@"hair_anlan", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/anlan" key:@""]
         tipTitle:@""
         showIntensityBar:NO],
        
        [BEEffectItem
         initWithID:BETypeMakeupHair
         selectImg:@"iconFaceMakeUpHairSelected"
         unselectImg:@"iconFaceMakeUpHairNormal"
         title:NSLocalizedString(@"hair_molv", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/molv" key:@""]
         tipTitle:@""
         showIntensityBar:NO],
        
        [BEEffectItem
         initWithID:BETypeMakeupHair
         selectImg:@"iconFaceMakeUpHairSelected"
         unselectImg:@"iconFaceMakeUpHairNormal"
         title:NSLocalizedString(@"hair_shenzong", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"/hair/shenzong" key:@""]
         tipTitle:@""
         showIntensityBar:NO],
    ]];
}

- (BEEffectItem *)be_makeupItemLipstickShine {
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[BEEffectItem
                      initWithID:BETypeClose
                      selectImg:@"iconFilter_filter_normal.png"
                      unselectImg:@"iconFilter_filter_normal.png"
                      title:NSLocalizedString(@"close", nil)
                      desc:@""
                      model:nil]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"caomeihong.png"
                      unselectImg:@"caomeihong.png"
                      title:NSLocalizedString(@"lipstick_caomeihong", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/caomeihong" key:@"caomeihong"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"meiguidousha.png"
                      unselectImg:@"meiguidousha.png"
                      title:NSLocalizedString(@"lipstick_meiguidousha", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/meiguidousha" key:@"meiguidousha"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"naikameigui.png"
                      unselectImg:@"naikameigui.png"
                      title:NSLocalizedString(@"lipstick_naikameigui", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/naikameigui" key:@"naikameigui"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"rixinaicha.png"
                      unselectImg:@"rixinaicha.png"
                      title:NSLocalizedString(@"lipstick_rixinaicha", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/rixinaicha" key:@"rixinaicha"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"shanhuluose.png"
                      unselectImg:@"shanhuluose.png"
                      title:NSLocalizedString(@"lipstick_shanhuluose", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/shanhuluose" key:@"shanhuluose"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"sijialihong.png"
                      unselectImg:@"sijialihong.png"
                      title:NSLocalizedString(@"lipstick_sijialihong", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/sijialihong" key:@"sijialihong"]]];
    
    return [BEEffectItem initWithId:BETypeMakeupLip
                           children: [items copy]];
    
}

- (BEEffectItem *)be_makeupItemLipstickMatte {
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[BEEffectItem
                      initWithID:BETypeClose
                      selectImg:@"iconFilter_filter_normal.png"
                      unselectImg:@"iconFilter_filter_normal.png"
                      title:NSLocalizedString(@"close", nil)
                      desc:@""
                      model:nil]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"doushase.png"
                      unselectImg:@"doushase.png"
                      title:NSLocalizedString(@"lipstick_doushase", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/doushase" key:@"doushase"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"naiyouxiyou.png"
                      unselectImg:@"naiyouxiyou.png"
                      title:NSLocalizedString(@"lipstick_naiyouxiyou", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/naiyouxiyou" key:@"naiyouxiyou"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"nanguase.png"
                      unselectImg:@"nanguase.png"
                      title:NSLocalizedString(@"lipstick_nanguase", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/nanguase" key:@"nanguase"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"rouwufen.png"
                      unselectImg:@"rouwufen.png"
                      title:NSLocalizedString(@"lipstick_rouwufen", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/rouwufen" key:@"rouwufen"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"sironghong.png"
                      unselectImg:@"sironghong.png"
                      title:NSLocalizedString(@"lipstick_sironghong", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/sironghong" key:@"sironghong"]]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeMakeupLip
                      selectImg:@"yinghuase.png"
                      unselectImg:@"yinghuase.png"
                      title:NSLocalizedString(@"lipstick_yinghuase", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:@"/lipstick/yinghuase" key:@"yinghuase"]]];
    
    return [BEEffectItem initWithId:BETypeMakeupLip
                           children: [items copy]];
    
}

- (NSArray<BEFilterItem *> *)filterArray {
    static dispatch_once_t onceToken;
    static NSArray *filterArr;
    dispatch_once(&onceToken, ^{
        NSError *error;
        NSString *resourcePath = [[[BEEffectResourceHelper alloc] init] filterPath:@"../"];
        NSArray *filterCategoryResourcePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
        for (NSString *path in filterCategoryResourcePaths) {
            NSString *fullPath = [resourcePath stringByAppendingPathComponent:path];
            NSArray *filterResourcePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:&error];
            NSMutableArray <BEFilterItem *>*filterArray = [NSMutableArray array];
            filterResourcePaths = [filterResourcePaths sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            for (NSString *filterPath in filterResourcePaths) {
                BEFilterItem *filter = [BEFilterItem new];
                filter.filterPath = filterPath;
                [filterArray addObject:filter];
            }
            if ([path isEqualToString:@"Filter"]) {
                NSArray *filterNames = @[
                    @"filter_chalk",
                    @"filter_cream",
                    @"filter_oxgen",
                    @"filter_campan",
                    @"filter_lolita",
                    @"filter_mitao",
                    @"filter_makalong",
                    @"filter_paomo",
                    @"filter_yinhua",
                    @"filter_musi",
                    @"filter_wuyu",
                    @"filter_beihaidao",
                    @"filter_riza",
                    @"filter_xiyatu",
                    @"filter_jingmi",
                    @"filter_jiaopian",
                    @"filter_nuanyang",
                    @"filter_jiuri",
                    @"filter_hongchun",
                    @"filter_julandiao",
                    @"filter_tuise",
                    @"filter_heibai",
                    @"filter_Po1",
                    @"filter_Po2",
                    @"filter_Po3",
                    @"filter_Po4",
                    @"filter_Po5",
                    @"filter_Po6",
                    @"filter_Po7",
                    @"filter_Po8",
                    @"filter_Po9",
                    @"filter_Po10",
                    @"filter_L1",
                    @"filter_L2",
                    @"filter_L3",
                    @"filter_L4",
                    @"filter_L5",
                    @"filter_F1",
                    @"filter_F2",
                    @"filter_F3",
                    @"filter_F4",
                    @"filter_F5",
                    @"filter_S1",
                    @"filter_S2",
                    @"filter_S3",
                    @"filter_S4",
                    @"filter_S5",
                ];
                [filterArray enumerateObjectsUsingBlock:^(BEFilterItem * filter, NSUInteger idx, BOOL * _Nonnull stop) {
                    idx = [filter.filterPath componentsSeparatedByString:@"_"][1].integerValue - 1;
                    filter.title = idx < filterNames.count ? NSLocalizedString(filterNames[idx], nil) : @"";
                    filter.imageName = idx < filterNames.count ? [@"iconFilter_" stringByAppendingString:filterNames[idx]] : @"";
                }];
                BEFilterItem *normal = [BEFilterItem new];
                normal.title =  NSLocalizedString(@"filter_normal", nil);
                normal.imageName = @"iconFilter_filter_normal";
                normal.filterPath = @"";
                [filterArray insertObject:normal atIndex:0];
            }
            filterArr = filterArray;
        }
    });
    return filterArr;
}

- (NSMutableArray<NSNumber *> *)defaultIntensity:(BEEffectNode)ID {
    NSObject *defaultIntensity = [self.defaultValue objectForKey:[NSNumber numberWithInteger:ID]];
    if ([defaultIntensity isKindOfClass:[NSNumber class]]) {
        return [NSMutableArray arrayWithObject:(NSNumber *)defaultIntensity];
    } else if ([defaultIntensity isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:(NSArray *)defaultIntensity];
    }
    return nil;
}

- (NSArray<BEEffectItem *> *)buttonItemArrayWithDefaultIntensity {
    BEEffectItem *beautyFace = [self buttonItem:BETypeBeautyFace];
    BEEffectItem *beautyReshape = [self buttonItem:BETypeBeautyReshape];
    BEEffectItem *beautyFaceSelect = beautyFace.selectChild;
    BEEffectItem *beautyReshapeSelect = beautyReshape.selectChild;
    [beautyFace reset];
    [beautyReshape reset];
    [[self buttonItem:BETypeBeautyBody] reset];
    [[self buttonItem:BETypeMakeup] reset];
    
    beautyFace.selectChild = beautyFaceSelect;
    beautyReshape.selectChild = beautyReshapeSelect;
    NSMutableArray<BEEffectItem *> *array = [NSMutableArray array];
    for (BEEffectItem *item in beautyFace.allChildren) {
        if ([self be_isDefaultEffect:item.ID]) {
            [array addObject:item];
        }
    }
    for (BEEffectItem *item in beautyReshape.allChildren) {
        if ([self be_isDefaultEffect:item.ID]) {
            [array addObject:item];
        }
    }
    
    for (BEEffectItem *model in array) {
        NSArray *defaultIntensity = [self defaultIntensity:model.ID];
        if (defaultIntensity != nil && model.intensityArray != nil) {
            for (int i = 0; i < defaultIntensity.count && i < model.intensityArray.count; i++) {
                model.intensityArray[i] = defaultIntensity[i];
            }
        }
    }
    return array;
}

- (void)resetAllItem {
    for (BEEffectItem *item in [self.savedItems allValues]) {
        [item reset];
    }
}

- (NSArray<BETextSwitchItem *> *)styleMakeupSwitchItems {
    if (_styleMakeupSwitchItems) {
        return _styleMakeupSwitchItems;
    }
    
    _styleMakeupSwitchItems = @[
        [BETextSwitchItem initWithTitle:NSLocalizedString(@"style_makeup_filter", nil)
                             pointColor:BEColorWithRGBHex(0x30D8DB)
                     highlightTextColor:[UIColor whiteColor]
                        normalTextColor:[UIColor colorWithWhite:1 alpha:0.8]],
        [BETextSwitchItem initWithTitle:NSLocalizedString(@"style_makeup_makeup", nil)
                             pointColor:BEColorWithRGBHex(0xFBB02E)
                     highlightTextColor:[UIColor whiteColor]
                        normalTextColor:[UIColor colorWithWhite:1 alpha:0.8]],
    ];
    return _styleMakeupSwitchItems;
}

- (NSDictionary<NSNumber *,NSNumber *> *)defaultValue {
    if (self.effectType == BEEffectTypeLite || self.effectType == BEEffectTypeLiteNotAsia) {
        return [BEEffectDataManager defaultLiteValue];
    }
    return [BEEffectDataManager defaultStandardValue];
}

#pragma mark - private
+ (NSDictionary<NSNumber *,NSNumber *> *)defaultStandardValue {
    static dispatch_once_t onceToken;
    static NSDictionary *dic;
    dispatch_once(&onceToken, ^{
        dic = @{
            // face
            @(BETypeBeautyFaceSmooth): @(0.65),
            @(BETypeBeautyFaceWhiten): @(0.35),
            @(BETypeBeautyFaceSharp): @(0.25),
            // reshape
            @(BETypeBeautyReshapeFaceOverall): @(0.75),
            @(BETypeBeautyReshapeFaceSmall): @(0.0),
            @(BETypeBeautyReshapeFaceCut): @(0.75),
            @(BETypeBeautyReshapeCheek): @(0.65),
            @(BETypeBeautyReshapeJaw): @(0.65),
            @(BETypeBeautyReshapeChin): @(0.5),
            @(BETypeBeautyReshapeForehead): @(0.7),
            @(BETypeBeautyReshapeRemoveSmileFolds): @(0.5),
            @(BETypeBeautyReshapeEyeSize): @(0.65),
            @(BETypeBeautyReshapeEyeRotate): @(0.5),
            @(BETypeBeautyReshapeEyeSpacing): @(0.5),
            @(BETypeBeautyReshapeEyeMove): @(0.5),
            @(BETypeBeautyReshapeRemovePouch): @(0.5),
            @(BETypeBeautyReshapeBrightenEye): @(0.4),
            @(BETypeBeautyReshapeNoseSize): @(0.65),
            @(BETypeBeautyReshapeNoseWing): @(0.6),
            @(BETypeBeautyReshapeMovNose): @(0.6),
            @(BETypeBeautyReshapeMouthZoom): @(0.6),
            @(BETypeBeautyReshapeMouthSmile): @(0.0),
            @(BETypeBeautyReshapeMouthMove): @(0.65),
            @(BETypeBeautyReshapeWhitenTeeth): @(0.3),
            // body
            @(BETypeBeautyBodyThin): @(0.0),
            @(BETypeBeautyBodyLegLong): @(0.0),
            @(BETypeBeautyBodyShrinkHead): @(0.0),
            @(BETypeBeautyBodySlimLeg): @(0.0),
            @(BETypeBeautyBodySlimWaist): @(0.0),
            @(BETypeBeautyBodyEnlargeBreast): @(0.0),
            @(BETypeBeautyBodyEnhanceHip): @(0.5),
            @(BETypeBeautyBodyEnhanceNeck): @(0.0),
            @(BETypeBeautyBodySlimArm): @(0.0),
            // makeup
            @(BETypeMakeupLip): @[@(0.5), @(0), @(0), @(0)],
            @(BETypeMakeupBlusher): @[@(0.5), @(0), @(0), @(0)],
            @(BETypeMakeupFacial): @(0.5),
            @(BETypeMakeupEyebrow): @[@(0.3), @(0), @(0), @(0)],
            @(BETypeMakeupEyeshadow): @(0.5),
            @(BETypeMakeupEyelash): @[@(0.5), @(0), @(0), @(0)],
            @(BETypeMakeupEyeLight): @(0.5),
            @(BETypeMakeupPupil): @(0.5),
            @(BETypeMakeupEyePlump): @(0.5),
            @(BETypeMakeupHair): @(0.5),
            // filter
            @(BETypeFilter): @(0.8),
            // style makeup
            @(BETypeStyleMakeup): @[@(0.8), @(0.3)],
            @(BETypeStyleHairColorA): @(0.8),
            @(BETypeStyleHairColorB): @(0.8),
            @(BETypeStyleHairColorC): @(0.8),
            @(BETypeStyleHairColorD): @(0.8),
        };
    });
    return dic;
}

+ (NSDictionary<NSNumber *,NSNumber *> *)defaultLiteValue {
    static dispatch_once_t onceToken;
    static NSDictionary *dic;
    dispatch_once(&onceToken, ^{
        dic = @{
            // face
            @(BETypeBeautyFaceSmooth): @(0.5),
            @(BETypeBeautyFaceWhiten): @(0.35),
            @(BETypeBeautyFaceSharp): @(0.7),
            //            @(BETypeBeautyReshapeBrightenEye): @(0.5),
            //            @(BETypeBeautyReshapeRemovePouch): @(0.5),
            //            @(BETypeBeautyReshapeRemoveSmileFolds): @(0.35),
            //            @(BETypeBeautyReshapeWhitenTeeth): @(0.35),
            // reshape
            @(BETypeBeautyReshapeFaceOverall): @(0.35),
            @(BETypeBeautyReshapeFaceSmall): @(0.0),
            @(BETypeBeautyReshapeFaceCut): @(0.0),
            @(BETypeBeautyReshapeEyeSize): @(0.35),
            @(BETypeBeautyReshapeEyeRotate): @(0.0),
            @(BETypeBeautyReshapeCheek): @(0.2),
            @(BETypeBeautyReshapeJaw): @(0.4),
            @(BETypeBeautyReshapeNoseWing): @(0.2),
            @(BETypeBeautyReshapeMovNose): @(0.0),
            @(BETypeBeautyReshapeChin): @(0.0),
            @(BETypeBeautyReshapeForehead): @(0.0),
            @(BETypeBeautyReshapeMouthZoom): @(0.15),
            @(BETypeBeautyReshapeMouthSmile): @(0.0),
            @(BETypeBeautyReshapeEyeSpacing): @(0.15),
            @(BETypeBeautyReshapeEyeMove): @(0.0),
            @(BETypeBeautyReshapeMouthMove): @(0.0),
            //            @(BETypeBeautyReshapeEyePlump): @(0.35),
            // body
            //            @(BETypeBeautyBodyThin): @(0.0),
            @(BETypeBeautyBodyLegLong): @(0.0),
            @(BETypeBeautyBodyShrinkHead): @(0.0),
            @(BETypeBeautyBodySlimLeg): @(0.0),
            @(BETypeBeautyBodySlimWaist): @(0.0),
            @(BETypeBeautyBodyEnlargeBreast): @(0.0),
            @(BETypeBeautyBodyEnhanceHip): @(0.5),
            @(BETypeBeautyBodyEnhanceNeck): @(0.0),
            @(BETypeBeautyBodySlimArm): @(0.0),
            // makeup
            @(BETypeMakeupLip): @(0.5),
            @(BETypeMakeupBlusher): @(0.2),
            @(BETypeMakeupFacial): @(0.35),
            @(BETypeMakeupEyebrow): @(0.35),
            @(BETypeMakeupEyeshadow): @(0.35),
            @(BETypeMakeupPupil): @(0.4),
            @(BETypeMakeupHair): @(0.5),
            // filter
            @(BETypeFilter): @(0.8),
            // style makeup
            @(BETypeStyleMakeup): @[@(0.8), @(0.3)],
        };
    });
    return dic;
}

- (BOOL)be_isDefaultEffect:(BEEffectNode)ID {
    return [[self be_defaultItems] containsObject:[NSNumber numberWithInteger:ID]];
}

- (NSArray<NSNumber *> *)be_defaultItems {
    static dispatch_once_t onceToken;
    static NSArray *lite_arr;
    static NSArray *standard_arr;
    dispatch_once(&onceToken, ^{
        lite_arr = @[
            @(BETypeBeautyFaceSmooth),
            @(BETypeBeautyFaceWhiten),
            @(BETypeBeautyFaceSharp),
            @(BETypeBeautyReshapeFaceOverall),
            @(BETypeBeautyReshapeEyeSize),
            @(BETypeBeautyReshapeMovNose),
        ];
        standard_arr = @[
            @(BETypeBeautyFaceSmooth),
            @(BETypeBeautyFaceWhiten),
            @(BETypeBeautyFaceSharp),
            @(BETypeBeautyReshapeFaceOverall),
            @(BETypeBeautyReshapeEyeSize),
            @(BETypeBeautyReshapeMovNose),
        ];
    });
    return [self be_isLite] ? lite_arr : standard_arr;
}

- (BEEffectItem *)be_beautyFaceItem {
    NSString *beautyPath = [self be_beautyPath];
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[BEEffectItem
                      initWithID:BETypeClose
                      selectImg:@"iconCloseButtonSelected.png"
                      unselectImg:@"iconCloseButtonNormal.png"
                      title:NSLocalizedString(@"close", nil)
                      desc:@""
                      model:nil]];
    [items addObject:[BEEffectItem
                      initWithID:BETypeBeautyFaceSmooth
                      selectImg:@"iconFaceBeautySkinSelected.png"
                      unselectImg:@"iconFaceBeautySkinNormal.png"
                      title:NSLocalizedString(@"beauty_face_smooth", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:beautyPath key:@"smooth"]]];
    if ([self be_hasWhiten]) {
        [items addObject:[BEEffectItem
                          initWithID:BETypeBeautyFaceWhiten
                          selectImg:@"iconFaceBeautyWhiteningSelected.png"
                          unselectImg:@"iconFaceBeautyWhiteningNormal.png"
                          title:NSLocalizedString(@"beauty_face_whiten", nil)
                          desc:@""
                          model:[BEComposerNodeModel initWithPath:beautyPath key:@"whiten"]]];
    }
    [items addObject:[BEEffectItem
                      initWithID:BETypeBeautyFaceSharp
                      selectImg:@"iconFaceBeautySharpSelected.png"
                      unselectImg:@"iconFaceBeautySharpNormal.png"
                      title:NSLocalizedString(@"beauty_face_sharpen", nil)
                      desc:@""
                      model:[BEComposerNodeModel initWithPath:beautyPath key:@"sharp"]]];
    return [BEEffectItem initWithId:BETypeBeautyFace
                           children: [items copy]];
}

- (BEEffectItem *)be_beautyReshapeItemLite {
    NSString *reshapePath = [self be_reshapePath];
    NSMutableArray *items = [NSMutableArray array];
#pragma mark face
    BEEffectItem *faceItem = [BEEffectItem
                              initWithID:BETypeBeautyReshapeFace
                              selectImg:@"iconReshapeFaceSelect"
                              unselectImg:@"iconReshapeFaceNormal"
                              title:NSLocalizedString(@"beauty_reshape_face_group", nil)
                              desc:@""
                              children:@[
                                  [BEEffectItem
                                   initWithID:BETypeClose
                                   selectImg:@"iconCloseButtonSelected.png"
                                   unselectImg:@"iconCloseButtonNormal.png"
                                   title:NSLocalizedString(@"close", nil)
                                   desc:@""
                                   model:nil],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeFaceOverall
                                   selectImg:@"iconFaceOverallSelect"
                                   unselectImg:@"iconFaceOverallNormal"
                                   title:NSLocalizedString(@"beauty_reshape_face_overall", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Overall"]],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeFaceSmall
                                   selectImg:@"iconFaceSmallSelect"
                                   unselectImg:@"iconFaceSmallNormal"
                                   title:NSLocalizedString(@"beauty_reshape_face_small", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Face"]],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeFaceCut
                                   selectImg:@"iconFaceCutSelect"
                                   unselectImg:@"iconFaceCutNormal"
                                   title:NSLocalizedString(@"beauty_reshape_face_cut", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_CutFace"]],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeCheek
                                   selectImg:@"iconFaceCheekSelect"
                                   unselectImg:@"iconFaceCheekNormal"
                                   title:NSLocalizedString(@"beauty_reshape_cheek", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Zoom_Cheekbone"]],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeJaw
                                   selectImg:@"iconFaceJawSelect"
                                   unselectImg:@"iconFaceJawNormal"
                                   title:NSLocalizedString(@"beauty_reshape_jaw", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Zoom_Jawbone"]],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeChin
                                   selectImg:@"iconFaceChinSelect"
                                   unselectImg:@"iconFaceChinNormal"
                                   title:NSLocalizedString(@"beauty_reshape_chin", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Chin"]],
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeForehead
                                   selectImg:@"iconFaceForeheadSelect"
                                   unselectImg:@"iconFaceForeheadNormal"
                                   title:NSLocalizedString(@"beauty_reshape_forehead", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Forehead"]],
                                  
                                  [BEEffectItem
                                   initWithID:BETypeBeautyReshapeRemoveSmileFolds
                                   selectImg:@"iconFaceSmillFoldsSelect"
                                   unselectImg:@"iconFaceSmillFoldsNormal"
                                   title:NSLocalizedString(@"beauty_face_smile_folds", nil)
                                   desc:@""
                                   model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_SMILES_FOLDS"]],
                              ]];
#pragma mark eye
    NSMutableArray* eyeItems =
    [NSMutableArray arrayWithArray:
     @[
         [BEEffectItem
          initWithID:BETypeClose
          selectImg:@"iconCloseButtonSelected.png"
          unselectImg:@"iconCloseButtonNormal.png"
          title:NSLocalizedString(@"close", nil)
          desc:@""
          model:nil],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeSize
          selectImg:@"iconEyeSizeSelect"
          unselectImg:@"iconEyeSizeNormal"
          title:NSLocalizedString(@"beauty_reshape_eye", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Eye"]],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeMove
          selectImg:@"iconEyePositionSelect"
          unselectImg:@"iconEyePositionNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_move", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Eye_Move"]],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeSpacing
          selectImg:@"iconEyeSpaceSelect"
          unselectImg:@"iconEyeSpaceNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_spacing", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Eye_Spacing"]],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeRotate
          selectImg:@"iconEyeRotateSelect"
          unselectImg:@"iconEyeRotateNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_rotate", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_RotateEye"]],
         
         [BEEffectItem
          initWithID:BETypeBeautyReshapeBrightenEye
          selectImg:@"iconEyeLightSelect"
          unselectImg:@"iconEyeLightNormal"
          title:NSLocalizedString(@"beauty_face_brighten_eye", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_BRIGHTEN_EYE"]],
         
         [BEEffectItem
          initWithID:BETypeBeautyReshapeRemovePouch
          selectImg:@"iconEyeRemovePouchSelect"
          unselectImg:@"iconEyeRemovePouchNormal"
          title:NSLocalizedString(@"beauty_face_remove_pouch", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_REMOVE_POUCH"]],
     ]];
    
    if ([self be_hasDoubleEyelid]) {
        [eyeItems addObjectsFromArray:@[
            [BEEffectItem
             initWithID:BETypeBeautyReshapeSingleToDoubleEyelid
             selectImg:@"iconEyeDoubleSelect"
             unselectImg:@"iconEyeDoubleNormal"
             title:NSLocalizedString(@"beauty_face_double_eyelid", nil)
             desc:@""
             model:[BEComposerNodeModel initWithPath:@"/double_eye_lid/newmoon" key:@"BEF_BEAUTY_EYE_SINGLE_TO_DOUBLE"]],
        ]];
    }
    BEEffectItem *eyeItem = [BEEffectItem
                             initWithID:BETypeBeautyReshapeEye
                             selectImg:@"iconReshapeEyeSelect"
                             unselectImg:@"iconReshapeEyeNormal"
                             title:NSLocalizedString(@"beauty_reshape_eye_group", nil)
                             desc:@""
                             children:eyeItems];
#pragma mark nose
    NSArray *noseItems = @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected.png"
         unselectImg:@"iconCloseButtonNormal.png"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeNoseWing
         selectImg:@"iconNoseWingSelect"
         unselectImg:@"iconNoseWingNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_lean", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Nose"]],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMovNose
         selectImg:@"iconNoseMovSelect"
         unselectImg:@"iconNoseMovNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_long", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_MovNose"]],
    ];
    BEEffectItem *noseItem = [BEEffectItem
                              initWithID:BETypeBeautyReshapeNose
                              selectImg:@"iconReshapeNoseSelect"
                              unselectImg:@"iconReshapeNoseNormal"
                              title:NSLocalizedString(@"beauty_reshape_nose_group", nil)
                              desc:@""
                              children:noseItems];
#pragma mark mouth
    NSArray *mouthItems = @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected.png"
         unselectImg:@"iconCloseButtonNormal.png"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthZoom
         selectImg:@"iconMouthSizeSelect"
         unselectImg:@"iconMouthSizeNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_zoom", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_ZoomMouth"]],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthMove
         selectImg:@"iconMouthPositionSelect"
         unselectImg:@"iconMouthPositionNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_move", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_MovMouth"]],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthSmile
         selectImg:@"iconMouthSmileSelect"
         unselectImg:@"iconMouthSmileNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_smile", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_MouthCorner"]],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeWhitenTeeth
         selectImg:@"iconWhitenTeethSelect"
         unselectImg:@"iconWihtenTeethNormal"
         title:NSLocalizedString(@"beauty_face_whiten_teeth", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_WHITEN_TEETH"]],
    ];
    BEEffectItem *mouthItem = [BEEffectItem
                               initWithID:BETypeBeautyReshapeMouth
                               selectImg:@"iconReshapeMouthSelect"
                               unselectImg:@"iconReshapeMouthNormal"
                               title:NSLocalizedString(@"beauty_reshape_mouth_group", nil)
                               desc:@""
                               children:mouthItems];
    
    [items removeAllObjects];
    [items addObject:[BEEffectItem
                      initWithID:BETypeClose
                      selectImg:@"iconCloseButtonSelected.png"
                      unselectImg:@"iconCloseButtonNormal.png"
                      title:NSLocalizedString(@"close", nil)
                      desc:@""
                      model:nil]];
    [items addObject:faceItem];
    [items addObject:eyeItem];
    [items addObject:noseItem];
    //    [items addObject:eyebrowItem];
    [items addObject:mouthItem];
    
    return [BEEffectItem initWithId:BETypeBeautyReshape
                           children:items];
}

- (BEEffectItem *)be_beautyReshapeItemStandard {
    NSString *reshapePath = [self be_reshapePath];
    NSMutableArray *items = [NSMutableArray array];
#pragma mark face
    NSArray *faceItems = @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected.png"
         unselectImg:@"iconCloseButtonNormal.png"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeFaceOverall
         selectImg:@"iconFaceOverallSelect"
         unselectImg:@"iconFaceOverallNormal"
         title:NSLocalizedString(@"beauty_reshape_face_overall", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Overall"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeFaceSmall
         selectImg:@"iconFaceSmallSelect"
         unselectImg:@"iconFaceSmallNormal"
         title:NSLocalizedString(@"beauty_reshape_face_small", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Face"]],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeFaceCut
         selectImg:@"iconFaceCutSelect"
         unselectImg:@"iconFaceCutNormal"
         title:NSLocalizedString(@"beauty_reshape_face_cut", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_CutFace"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeCheek
         selectImg:@"iconFaceCheekSelect"
         unselectImg:@"iconFaceCheekNormal"
         title:NSLocalizedString(@"beauty_reshape_cheek", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Zoom_Cheekbone"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeJaw
         selectImg:@"iconFaceJawSelect"
         unselectImg:@"iconFaceJawNormal"
         title:NSLocalizedString(@"beauty_reshape_jaw", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Zoom_Jawbone"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeFaceV
         selectImg:@"iconFaceVSelect"
         unselectImg:@"iconFaceVNormal"
         title:NSLocalizedString(@"beauty_reshape_face_vface", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_VFace"]],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeChin
         selectImg:@"iconFaceChinSelect"
         unselectImg:@"iconFaceChinNormal"
         title:NSLocalizedString(@"beauty_reshape_chin", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Chin"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeForehead
         selectImg:@"iconFaceForeheadSelect"
         unselectImg:@"iconFaceForeheadNormal"
         title:NSLocalizedString(@"beauty_reshape_forehead", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Forehead"]
         enableNegative:YES],
        
        [BEEffectItem
         initWithID:BETypeBeautyReshapeRemoveSmileFolds
         selectImg:@"iconFaceSmillFoldsSelect"
         unselectImg:@"iconFaceSmillFoldsNormal"
         title:NSLocalizedString(@"beauty_face_smile_folds", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_SMILES_FOLDS"]],
    ];
    BEEffectItem *faceItem = [BEEffectItem
                              initWithID:BETypeBeautyReshapeFace
                              selectImg:@"iconReshapeFaceSelect"
                              unselectImg:@"iconReshapeFaceNormal"
                              title:NSLocalizedString(@"beauty_reshape_face_group", nil)
                              desc:@""
                              children:faceItems];
#pragma mark eye
    NSMutableArray* eyeItems =
    [NSMutableArray arrayWithArray:
     @[
         [BEEffectItem
          initWithID:BETypeClose
          selectImg:@"iconCloseButtonSelected.png"
          unselectImg:@"iconCloseButtonNormal.png"
          title:NSLocalizedString(@"close", nil)
          desc:@""
          model:nil],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeSize
          selectImg:@"iconEyeSizeSelect"
          unselectImg:@"iconEyeSizeNormal"
          title:NSLocalizedString(@"beauty_reshape_eye", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Eye"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeHeight
          selectImg:@"iconEyeHeightSelect"
          unselectImg:@"iconEyeHeightNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_height", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_EyeHeight"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeWidth
          selectImg:@"iconEyeWidthSelect"
          unselectImg:@"iconEyeWidthNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_width", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_EyeWidth"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeMove
          selectImg:@"iconEyePositionSelect"
          unselectImg:@"iconEyePositionNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_move", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Eye_Move"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeSpacing
          selectImg:@"iconEyeSpaceSelect"
          unselectImg:@"iconEyeSpaceNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_spacing", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Eye_Spacing"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeLowerEyelid
          selectImg:@"iconEyeLowerEyelidSelect"
          unselectImg:@"iconEyeLowerEyelidNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_lower_eyelid", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_LowerEyelid"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyePupil
          selectImg:@"iconEyePupilSelect"
          unselectImg:@"iconEyePupilNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_pupil_size", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_EyePupil"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeInnerCorner
          selectImg:@"iconEyeInnerCornerSelect"
          unselectImg:@"iconEyeInnerCornerNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_inner_corner", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_EyeInnerCorner"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeOuterCorner
          selectImg:@"iconEyeOuterCornerSelect"
          unselectImg:@"iconEyeOuterCornerNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_outer_corner", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_EyeOuterCorner"]
          enableNegative:YES],
         [BEEffectItem
          initWithID:BETypeBeautyReshapeEyeRotate
          selectImg:@"iconEyeRotateSelect"
          unselectImg:@"iconEyeRotateNormal"
          title:NSLocalizedString(@"beauty_reshape_eye_rotate", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_RotateEye"]
          enableNegative:YES],
         
         [BEEffectItem
          initWithID:BETypeBeautyReshapeBrightenEye
          selectImg:@"iconEyeLightSelect"
          unselectImg:@"iconEyeLightNormal"
          title:NSLocalizedString(@"beauty_face_brighten_eye", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_BRIGHTEN_EYE"]],
         
         [BEEffectItem
          initWithID:BETypeBeautyReshapeRemovePouch
          selectImg:@"iconEyeRemovePouchSelect"
          unselectImg:@"iconEyeRemovePouchNormal"
          title:NSLocalizedString(@"beauty_face_remove_pouch", nil)
          desc:@""
          model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_REMOVE_POUCH"]],
     ]];
    
    if ([self be_hasDoubleEyelid]) {
        [eyeItems addObjectsFromArray:@[
            [BEEffectItem
             initWithID:BETypeBeautyReshapeSingleToDoubleEyelid
             selectImg:@"iconEyeDoubleSelect"
             unselectImg:@"iconEyeDoubleNormal"
             title:NSLocalizedString(@"beauty_face_double_eyelid", nil)
             desc:@""
             model:[BEComposerNodeModel initWithPath:@"/double_eye_lid/newmoon" key:@"BEF_BEAUTY_EYE_SINGLE_TO_DOUBLE"]],
        ]];
    }
    BEEffectItem *eyeItem = [BEEffectItem
                             initWithID:BETypeBeautyReshapeEye
                             selectImg:@"iconReshapeEyeSelect"
                             unselectImg:@"iconReshapeEyeNormal"
                             title:NSLocalizedString(@"beauty_reshape_eye_group", nil)
                             desc:@""
                             children:eyeItems];
#pragma mark nose
    NSArray *noseItems = @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected.png"
         unselectImg:@"iconCloseButtonNormal.png"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeNoseSize
         selectImg:@"iconNoseSizeSelect"
         unselectImg:@"iconNoseSizeNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_size", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_NoseSize"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeNoseWing
         selectImg:@"iconNoseWingSelect"
         unselectImg:@"iconNoseWingNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_lean", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_Nose"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeNoseBridge
         selectImg:@"iconNoseBridgeSelect"
         unselectImg:@"iconNoseBridgeNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_bridge", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_NoseBridge"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMovNose
         selectImg:@"iconNoseMovSelect"
         unselectImg:@"iconNoseMovNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_long", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_MovNose"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeNoseTip
         selectImg:@"iconNoseTipSelect"
         unselectImg:@"iconNoseTipNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_tip", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_NoseTip"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeNoseRoot
         selectImg:@"iconNoseRootSelect"
         unselectImg:@"iconNoseRootNormal"
         title:NSLocalizedString(@"beauty_reshape_nose_root", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_NoseRoot"]
         enableNegative:YES],
    ];
    BEEffectItem *noseItem = [BEEffectItem
                              initWithID:BETypeBeautyReshapeNose
                              selectImg:@"iconReshapeNoseSelect"
                              unselectImg:@"iconReshapeNoseNormal"
                              title:NSLocalizedString(@"beauty_reshape_nose_group", nil)
                              desc:@""
                              children:noseItems];
#pragma mark eyebrow
    NSArray *eyebrowItems = @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected.png"
         unselectImg:@"iconCloseButtonNormal.png"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeBrowSize
         selectImg:@"iconBrowSizeSelect"
         unselectImg:@"iconBrowSizeNormal"
         title:NSLocalizedString(@"beauty_reshape_brow_size", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_BrowSize"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeBrowPosition
         selectImg:@"iconBrowPositionSelect"
         unselectImg:@"iconBrowPositionNormal"
         title:NSLocalizedString(@"beauty_reshape_brow_position", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_BrowPosition"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeBrowTilt
         selectImg:@"iconBrowTiltSelect"
         unselectImg:@"iconBrowTiltNormal"
         title:NSLocalizedString(@"beauty_reshape_brow_tile", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_BrowTilt"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeBrowRidge
         selectImg:@"iconBrowRidgeSelect"
         unselectImg:@"iconBrowRidgeNormal"
         title:NSLocalizedString(@"beauty_reshape_brow_ridge", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_BrowRidge"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeBrowDistance
         selectImg:@"iconBrowDistanceSelect"
         unselectImg:@"iconBrowDistanceNormal"
         title:NSLocalizedString(@"beauty_reshape_brow_distance", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_BrowDistance"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeBrowWidth
         selectImg:@"iconBrowWidthSelect"
         unselectImg:@"iconBrowWidthNormal"
         title:NSLocalizedString(@"beauty_reshape_brow_width", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_BrowWidth"]
         enableNegative:YES],
    ];
    BEEffectItem *eyebrowItem = [BEEffectItem
                                 initWithID:BETypeBeautyReshapeBrow
                                 selectImg:@"iconReshapeBrowSelect"
                                 unselectImg:@"iconReshapeBrowNormal"
                                 title:NSLocalizedString(@"beauty_reshape_brow_group", nil)
                                 desc:@""
                                 children:eyebrowItems];
#pragma mark mouth
    NSArray *mouthItems = @[
        [BEEffectItem
         initWithID:BETypeClose
         selectImg:@"iconCloseButtonSelected.png"
         unselectImg:@"iconCloseButtonNormal.png"
         title:NSLocalizedString(@"close", nil)
         desc:@""
         model:nil],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthZoom
         selectImg:@"iconMouthSizeSelect"
         unselectImg:@"iconMouthSizeNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_zoom", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_ZoomMouth"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthWidth
         selectImg:@"iconMouthWidthSelect"
         unselectImg:@"iconMouthWidthNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_width", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_MouseWidth"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthMove
         selectImg:@"iconMouthPositionSelect"
         unselectImg:@"iconMouthPositionNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_move", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_MovMouth"]
         enableNegative:YES],
        [BEEffectItem
         initWithID:BETypeBeautyReshapeMouthSmile
         selectImg:@"iconMouthSmileSelect"
         unselectImg:@"iconMouthSmileNormal"
         title:NSLocalizedString(@"beauty_reshape_mouth_smile", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:reshapePath key:@"Internal_Deform_MouthCorner"]],
        
        [BEEffectItem
         initWithID:BETypeBeautyReshapeWhitenTeeth
         selectImg:@"iconWhitenTeethSelect"
         unselectImg:@"iconWihtenTeethNormal"
         title:NSLocalizedString(@"beauty_face_whiten_teeth", nil)
         desc:@""
         model:[BEComposerNodeModel initWithPath:@"beauty_4Items" key:@"BEF_BEAUTY_WHITEN_TEETH"]],
    ];
    BEEffectItem *mouthItem = [BEEffectItem
                               initWithID:BETypeBeautyReshapeMouth
                               selectImg:@"iconReshapeMouthSelect"
                               unselectImg:@"iconReshapeMouthNormal"
                               title:NSLocalizedString(@"beauty_reshape_mouth_group", nil)
                               desc:@""
                               children:mouthItems];
    
    [items removeAllObjects];
    [items addObject:[BEEffectItem
                      initWithID:BETypeClose
                      selectImg:@"iconCloseButtonSelected.png"
                      unselectImg:@"iconCloseButtonNormal.png"
                      title:NSLocalizedString(@"close", nil)
                      desc:@""
                      model:nil]];
    [items addObject:faceItem];
    [items addObject:eyeItem];
    [items addObject:noseItem];
    [items addObject:eyebrowItem];
    [items addObject:mouthItem];
    
    return [BEEffectItem initWithId:BETypeBeautyReshape
                           children:items];
}

- (BEEffectItem *)be_beautyReshapeItem {
    switch (self.effectType) {
        case BEEffectTypeLite:
        case BEEffectTypeLiteNotAsia:
            return [self be_beautyReshapeItemLite];
        case BEEffectTypeStandard:
        case BEEffectTypeStandardNotAsia:
            return [self be_beautyReshapeItemStandard];
        default:
            break;
    }
}

- (BEEffectItem *)be_beautyBodyItem {
    NSString *bodyPath = @"/body/allslim";
    return [BEEffectItem initWithId:BETypeBeautyBody
                           children:@[
                               [BEEffectItem
                                initWithID:BETypeClose
                                selectImg:@"iconCloseButtonSelected.png"
                                unselectImg:@"iconCloseButtonNormal.png"
                                title:NSLocalizedString(@"close", nil)
                                desc:@""
                                model:nil],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodyThin
                                selectImg:@"iconBeautyBodyThinSelect"
                                unselectImg:@"iconBeautyBodyThinNormal"
                                title:NSLocalizedString(@"beauty_body_thin", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_THIN"]],
                               
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodyLegLong
                                selectImg:@"iconBeautyBodyLegLongSelect"
                                unselectImg:@"iconBeautyBodyLegLongNormal"
                                title:NSLocalizedString(@"beauty_body_leg_long", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_LONG_LEG"]],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodyShrinkHead
                                selectImg:@"iconBeautyBodyShrinkHeadSelect"
                                unselectImg:@"iconBeautyBodyShrinkHeadNormal"
                                title:NSLocalizedString(@"beauty_body_shrink_head", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_SHRINK_HEAD"]],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodySlimLeg
                                selectImg:@"iconBeautyBodySlimLegSelect"
                                unselectImg:@"iconBeautyBodySlimLegNormal"
                                title:NSLocalizedString(@"beauty_body_leg_slim", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_SLIM_LEG"]],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodySlimWaist
                                selectImg:@"iconBeautyBodyThinSelect"
                                unselectImg:@"iconBeautyBodyThinNormal"
                                title:NSLocalizedString(@"beauty_body_waist_slim", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_SLIM_WAIST"]],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodyEnlargeBreast
                                selectImg:@"iconBeautyBodyEnlargeBreastSelect"
                                unselectImg:@"iconBeautyBodyEnlargeBreastNormal"
                                title:NSLocalizedString(@"beauty_body_breast_enlarge", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_ENLARGR_BREAST"]],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodyEnhanceHip
                                selectImg:@"iconBeautyBodyEnhanceHipSelect"
                                unselectImg:@"iconBeautyBodyEnhanceHipNormal"
                                title:NSLocalizedString(@"beauty_body_hip_enhance", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_ENHANCE_HIP"]
                                enableNegative:YES],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodyEnhanceNeck
                                selectImg:@"iconBeautyBodyEnhanceNeckSelect"
                                unselectImg:@"iconBeautyBodyEnhanceNeckNormal"
                                title:NSLocalizedString(@"beauty_body_neck_enhance", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_ENHANCE_NECK"]],
                               
                               [BEEffectItem
                                initWithID:BETypeBeautyBodySlimArm
                                selectImg:@"iconBeautyBodySlimArmSelect"
                                unselectImg:@"iconBeautyBodySlimArmNormal"
                                title:NSLocalizedString(@"beauty_body_arm_slim", nil)
                                desc:@""
                                model:[BEComposerNodeModel initWithPath:bodyPath key:@"BEF_BEAUTY_BODY_SLIM_ARM"]],
                           ]];
}

- (BEEffectItem *)be_makeupItem {
    BOOL isLite = [self be_isLite];
    NSMutableArray *arr =
    [NSMutableArray
     arrayWithArray:@[
         [BEEffectItem
          initWithID:BETypeClose
          selectImg:@"iconCloseButtonSelected.png"
          unselectImg:@"iconCloseButtonNormal.png"
          title:NSLocalizedString(@"close", nil)
          desc:@""
          model:nil],
         
         [BEEffectItem
          initWithID:BETypeMakeupLip
          selectImg:@"iconFaceMakeUpLipsSelected.png"
          unselectImg:@"iconFaceMakeUpLipsNormal.png"
          title:NSLocalizedString(@"makeup_lip", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupLip]
          enableMultiSelect:NO
          colorset: isLite ? nil : @[]],
         
         [BEEffectItem
          initWithID:BETypeMakeupBlusher
          selectImg:@"iconFaceMakeUpBlusherSelected.png"
          unselectImg:@"iconFaceMakeUpBlusherNormal.png"
          title:NSLocalizedString(@"makeup_blusher", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupBlusher]
          enableMultiSelect:NO
          colorset: isLite ? nil : @[]],
         
         [BEEffectItem
          initWithID:BETypeMakeupFacial
          selectImg:@"iconFaceMakeUpFacialSelected.png"
          unselectImg:@"iconFaceMakeUpFacialNormal.png"
          title:NSLocalizedString(@"makeup_facial", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupFacial]
          enableMultiSelect:NO],
         
         [BEEffectItem
          initWithID:BETypeMakeupEyebrow
          selectImg:@"iconFaceMakeUpEyebrowSelected.png"
          unselectImg:@"iconFaceMakeUpEyebrowNormal.png"
          title:NSLocalizedString(@"makeup_eyebrow", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupEyebrow]
          enableMultiSelect:NO
          colorset: isLite ? nil : @[]],
         
         [BEEffectItem
          initWithID:BETypeMakeupEyeshadow
          selectImg:@"iconFaceMakeUpEyeshadowSelected.png"
          unselectImg:@"iconFaceMakeUpEyeshadowNormal.png"
          title:NSLocalizedString(@"makeup_eyeshadow", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupEyeshadow]
          enableMultiSelect:NO],
         
         [BEEffectItem
          initWithID:BETypeMakeupPupil
          selectImg:@"iconFaceMakeUpPupilSelected.png"
          unselectImg:@"iconFaceMakeUpPupilNormal.png"
          title:NSLocalizedString(@"makeup_pupil", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupPupil]
          enableMultiSelect:NO],
         
         [BEEffectItem
          initWithID:BETypeMakeupHair
          selectImg:@"iconFaceMakeUpHairSelected"
          unselectImg:@"iconFaceMakeUpHairNormal"
          title:NSLocalizedString(@"makeup_hair", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupHair]
          enableMultiSelect:NO
          showIntensityBar:NO],
     ]];
    if ([self be_hasDoubleEyelid]) {
        [arr insertObject:
         [BEEffectItem
          initWithID:BETypeMakeupEyePlump
          selectImg:@"iconFaceMakeupEyePlumpSelect"
          unselectImg:@"iconFaceMakeupEyePlumpNormal"
          title:@"卧蚕"
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupEyePlump]
          enableMultiSelect:NO] atIndex:7];
    }
    if (![self be_isLite]) {
        [arr insertObject:
         [BEEffectItem
          initWithID:BETypeMakeupEyelash
          selectImg:@"iconFaceMakeupEyeSlashSelect"
          unselectImg:@"iconFaceMakeupEyeSlashNormal"
          title:NSLocalizedString(@"makeup_eyelash", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupEyelash]
          enableMultiSelect:NO
          colorset:@[]] atIndex:6];
        [arr insertObject:
         [BEEffectItem
          initWithID:BETypeMakeupEyeLight
          selectImg:@"iconFaceMakeupEyeLightSelect"
          unselectImg:@"iconFaceMakeupEyeLightNormal"
          title:NSLocalizedString(@"makeup_eyelight", nil)
          desc:@""
          children:[self be_makeupOptionWithType:BETypeMakeupEyeLight]
          enableMultiSelect:NO] atIndex:7];
    }
    return [BEEffectItem initWithId:BETypeMakeup
                           children:[arr copy]];
}

- (NSArray<BEEffectItem *> *)be_makeupOptionWithType:(NSInteger)type {
    switch (type) {
#pragma mark blush
        case BETypeMakeupBlusher:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected.png"
                     unselectImg:@"iconCloseButtonNormal.png"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_weixun", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/weixun" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_richang", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/richang" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_mitao", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/mitao" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_tiancheng", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/tiancheng" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_qiaopi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/qiaopi" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_xinji", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/xinji" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_shaishang", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/lite/shaishang" key:@"Internal_Makeup_Blusher"]
                     tipTitle:@""],
                    
                ];
            } else {
                NSArray *colorset = @[
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"浅粉", nil) red:0.988f green:0.678f blue:0.733f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"杏仁", nil) red:0.996f green:0.796f blue:0.545f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"珊瑚", nil) red:1.000f green:0.565f blue:0.443f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"粉桃", nil) red:1.000f green:0.506f blue:0.529f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"浅紫", nil) red:0.980f green:0.722f blue:0.855f],
                ];
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected.png"
                     unselectImg:@"iconCloseButtonNormal.png"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_mitao", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/mitao" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_weixun", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/weixun" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_yuanqi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/yuanqi" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_qise", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/qise" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_shaishang", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/shaishang" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_rixi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/rixi" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupBlusher
                     selectImg:@"iconFaceMakeUpBlusherSelected"
                     unselectImg:@"iconFaceMakeUpBlusherNormal"
                     title:NSLocalizedString(@"blusher_suzui", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/blush/standard/suzui" keyArray:@[@"Internal_Makeup_Blusher", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                ];
            }
#pragma mark lip
        case BETypeMakeupLip:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_fuguhong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/fuguhong" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_shaonvfen", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/shaonvfen" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_yuanqiju", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/yuanqiju" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_xiyouse", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/xiyouse" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_xiguahong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/xiguahong" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_sironghong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/sironghong" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_zangjuse", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/zangjuse" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_meizise", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/meizise" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_shanhuse", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/shanhuse" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_doushafen", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/lite/doushafen" key:@"Internal_Makeup_Lips"]
                     tipTitle:@""],
                    
                ];
            } else {
                NSArray *colorset = @[
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"元气", nil) red:0.867f green:0.388f blue:0.388f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"柔和粉", nil) red:0.949f green:0.576f blue:0.620f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"西柚", nil) red:0.945f green:0.510f blue:0.408f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"火龙果", nil) red:0.714f green:0.224f blue:0.388f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"草莓啵啵", nil) red:0.631f green:0.016f blue:0.016f],
//                    [[BEEffectColorItem alloc]
//                                          {zh} initWithTitle:NSLocalizedString(@"番茄", nil) red:0.580f green:0.063f blue:0.024f],                                          {en} initWithTitle: NSLocalizedString (@"tomato", nil) red: 0.580f green: 0.063f blue: 0.024f],
//                    [[BEEffectColorItem alloc]
//                                          {zh} initWithTitle:NSLocalizedString(@"梅子", nil) red:0.455f green:0.043f blue:0.137f],                                          {en} initWithTitle: NSLocalizedString (@"Plum", nil) red: 0.455f green: 0.043f blue: 0.137f],
//                    [[BEEffectColorItem alloc]
//                                          {zh} initWithTitle:NSLocalizedString(@"深红", nil) red:0.302f green:0.000f blue:0.004f],                                          {en} initWithTitle: NSLocalizedString (@"Crimson", nil) red: 0.302f green: 0.000f blue: 0.004f],
                ];
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_liangze", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/standard/liangze" keyArray:@[@"Internal_Makeup_Lips", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_wumian", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/standard/wumian" keyArray:@[@"Internal_Makeup_Lips", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_yaochun", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/standard/yaochun" keyArray:@[@"Internal_Makeup_Lips", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupLip
                     selectImg:@"iconFaceMakeUpLipsSelected"
                     unselectImg:@"iconFaceMakeUpLipsNormal"
                     title:NSLocalizedString(@"lip_yunran", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/lip/standard/yunran" keyArray:@[@"Internal_Makeup_Lips", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                ];
            }
#pragma mark pupil
        case BETypeMakeupPupil:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_hunxuezong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/hunxuezong" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_kekezong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/kekezong" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_mitaofen", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/mitaofen" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_shuiguanghei", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/shuiguanghei" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_xingkonglan", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/xingkonglan" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_chujianhui", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/chujianhui" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                ];
            } else {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_yuansheng", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/yuansheng" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_xinxinzi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/xinxinzi" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_huoxing", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/huoxing" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_huilv", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/huilv" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupPupil
                     selectImg:@"iconFaceMakeUpPupilSelected"
                     unselectImg:@"iconFaceMakeUpPupilNormal"
                     title:NSLocalizedString(@"pupil_huitong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/pupil/huitong" key:@"Internal_Makeup_Pupil"]
                     tipTitle:@""],
                    
                ];
            }
            
#pragma mark hair
        case BETypeMakeupHair:
            return @[
                [BEEffectItem
                 initWithID:BETypeClose
                 selectImg:@"iconCloseButtonSelected"
                 unselectImg:@"iconCloseButtonNormal"
                 title:NSLocalizedString(@"close", nil)
                 desc:@""
                 model:nil
                 showIntensityBar:NO],
                
                [BEEffectItem
                 initWithID:BETypeMakeupHair
                 selectImg:@"iconFaceMakeUpHairSelected"
                 unselectImg:@"iconFaceMakeUpHairNormal"
                 title:NSLocalizedString(@"hair_anlan", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/hair/anlan" key:@""]
                 tipTitle:@""
                 showIntensityBar:NO],
                
                [BEEffectItem
                 initWithID:BETypeMakeupHair
                 selectImg:@"iconFaceMakeUpHairSelected"
                 unselectImg:@"iconFaceMakeUpHairNormal"
                 title:NSLocalizedString(@"hair_molv", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/hair/molv" key:@""]
                 tipTitle:@""
                 showIntensityBar:NO],
                
                [BEEffectItem
                 initWithID:BETypeMakeupHair
                 selectImg:@"iconFaceMakeUpHairSelected"
                 unselectImg:@"iconFaceMakeUpHairNormal"
                 title:NSLocalizedString(@"hair_shenzong", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/hair/shenzong" key:@""]
                 tipTitle:@""
                 showIntensityBar:NO],
                
            ];
#pragma mark eyeshadow
        case BETypeMakeupEyeshadow:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_wanxiahong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/wanxiahong" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_shaonvfen", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/shaonvfen" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_qizhifen", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/qizhifen" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_meizihong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/meizihong" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_jiaotangzong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/jiaotangzong" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_yuanqiju", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/yuanqiju" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_naichase", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/naichase" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                ];
            } else {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_dadizong", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/dadizong" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_hanxi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/hanxi" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_nvshen", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/nvshen" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_xingzi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/xingzi" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyeshadow
                     selectImg:@"iconFaceMakeUpEyeshadowSelected"
                     unselectImg:@"iconFaceMakeUpEyeshadowNormal"
                     title:NSLocalizedString(@"eye_bingtangshanzha", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyeshadow/bingtangshanzha" key:@"Internal_Makeup_Eye"]
                     tipTitle:@""],
                ];
            }
#pragma mark eyebrow
        case BETypeMakeupEyebrow:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_zongse", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/lite/BR01" key:@"Internal_Makeup_Brow"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_cuhei", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/lite/BK01" key:@"Internal_Makeup_Brow"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_heise", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/lite/BK02" key:@"Internal_Makeup_Brow"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_xihei", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/lite/BK03" key:@"Internal_Makeup_Brow"]
                     tipTitle:@""],
                    
                ];
            } else {
                NSArray *colorset = @[
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"黑", nil) red:0.078f green:0.039f blue:0.039f],
                    [[BEEffectColorItem alloc]
                                         initWithTitle:NSLocalizedString(@"棕", nil) red:0.420f green:0.314f blue:0.239f],
                ];
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_biaozhun", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/standard/biaozhun" keyArray:@[@"Internal_Makeup_Brow", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_liuyemei", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/standard/liuye" keyArray:@[@"Internal_Makeup_Brow", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_rongrongmei", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/standard/rongrong" keyArray:@[@"Internal_Makeup_Brow", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyebrow
                     selectImg:@"iconFaceMakeUpEyebrowSelected"
                     unselectImg:@"iconFaceMakeUpEyebrowNormal"
                     title:NSLocalizedString(@"eyebrow_yeshengmei", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/eyebrow/standard/yesheng" keyArray:@[@"Internal_Makeup_Brow", @"R", @"G", @"B"]]
                     tipTitle:@""
                     colorset:colorset],
                ];
            }
#pragma mark eyelash
        case BETypeMakeupEyelash:
        {
            NSArray *colorset = @[
                [[BEEffectColorItem alloc]
                                     initWithTitle:NSLocalizedString(@"黑", nil) red:0.078f green:0.039f blue:0.039f],
                [[BEEffectColorItem alloc]
                                     initWithTitle:NSLocalizedString(@"棕", nil) red:0.420f green:0.314f blue:0.239f],
            ];
            return @[
                [BEEffectItem
                 initWithID:BETypeClose
                 selectImg:@"iconCloseButtonSelected"
                 unselectImg:@"iconCloseButtonNormal"
                 title:NSLocalizedString(@"close", nil)
                 desc:@""
                 model:nil],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyelash
                 selectImg:@"iconFaceMakeupEyeSlashSelect"
                 unselectImg:@"iconFaceMakeupEyeSlashNormal"
                 title:NSLocalizedString(@"eyelash_ziran", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelashes/ziran" keyArray:@[@"Internal_Makeup_Eyelash", @"R", @"G", @"B"]]
                 tipTitle:@""
                 colorset:colorset],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyelash
                 selectImg:@"iconFaceMakeupEyeSlashSelect"
                 unselectImg:@"iconFaceMakeupEyeSlashNormal"
                 title:NSLocalizedString(@"eyelash_juanqiao", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelashes/juanqiao" keyArray:@[@"Internal_Makeup_Eyelash", @"R", @"G", @"B"]]
                 tipTitle:@""
                 colorset:colorset],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyelash
                 selectImg:@"iconFaceMakeupEyeSlashSelect"
                 unselectImg:@"iconFaceMakeupEyeSlashNormal"
                 title:NSLocalizedString(@"eyelash_chibang", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelashes/chibang" keyArray:@[@"Internal_Makeup_Eyelash", @"R", @"G", @"B"]]
                 tipTitle:@""
                 colorset:colorset],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyelash
                 selectImg:@"iconFaceMakeupEyeSlashSelect"
                 unselectImg:@"iconFaceMakeupEyeSlashNormal"
                 title:NSLocalizedString(@"eyelash_manhua", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelashes/manhua" keyArray:@[@"Internal_Makeup_Eyelash", @"R", @"G", @"B"]]
                 tipTitle:@""
                 colorset:colorset],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyelash
                 selectImg:@"iconFaceMakeupEyeSlashSelect"
                 unselectImg:@"iconFaceMakeupEyeSlashNormal"
                 title:NSLocalizedString(@"eyelash_xiachui", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelashes/xiachui" keyArray:@[@"Internal_Makeup_Eyelash", @"R", @"G", @"B"]]
                 tipTitle:@""
                 colorset:colorset],
                
            ];
        }
#pragma mark eyelight
        case BETypeMakeupEyeLight:
            return @[
                [BEEffectItem
                 initWithID:BETypeClose
                 selectImg:@"iconCloseButtonSelected"
                 unselectImg:@"iconCloseButtonNormal"
                 title:NSLocalizedString(@"close", nil)
                 desc:@""
                 model:nil],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyeLight
                 selectImg:@"iconFaceMakeupEyeLightSelect"
                 unselectImg:@"iconFaceMakeupEyeLightNormal"
                 title:NSLocalizedString(@"eyelight_ziranguang", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelight/ziranguang" key:@"Internal_Makeup_EyeLight"]
                 tipTitle:@""],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyeLight
                 selectImg:@"iconFaceMakeupEyeLightSelect"
                 unselectImg:@"iconFaceMakeupEyeLightNormal"
                 title:NSLocalizedString(@"eyelight_yueyaguang", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelight/yueyaguang" key:@"Internal_Makeup_EyeLight"]
                 tipTitle:@""],
                
                [BEEffectItem
                 initWithID:BETypeMakeupEyeLight
                 selectImg:@"iconFaceMakeupEyeLightSelect"
                 unselectImg:@"iconFaceMakeupEyeLightNormal"
                 title:NSLocalizedString(@"eyelight_juguangdeng", nil)
                 desc:@""
                 model:[BEComposerNodeModel initWithPath:@"/eyelight/juguangdeng" key:@"Internal_Makeup_EyeLight"]
                 tipTitle:@""],
            ];
#pragma mark facial
        case BETypeMakeupFacial:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupFacial
                     selectImg:@"iconFaceMakeUpFacialSelected"
                     unselectImg:@"iconFaceMakeUpFacialNormal"
                     title:NSLocalizedString(@"facial_jingzhi", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/facial/jingzhi" key:@"Internal_Makeup_Facial"]
                     tipTitle:@""],
                ];
            } else {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupFacial
                     selectImg:@"iconFaceMakeUpFacialSelected"
                     unselectImg:@"iconFaceMakeUpFacialNormal"
                     title:NSLocalizedString(@"facial_ziran", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/facial/ziran" key:@"Internal_Makeup_Facial"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupFacial
                     selectImg:@"iconFaceMakeUpFacialSelected"
                     unselectImg:@"iconFaceMakeUpFacialNormal"
                     title:NSLocalizedString(@"facial_xiaov", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/facial/xiaov" key:@"Internal_Makeup_Facial"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupFacial
                     selectImg:@"iconFaceMakeUpFacialSelected"
                     unselectImg:@"iconFaceMakeUpFacialNormal"
                     title:NSLocalizedString(@"facial_fajixian", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/facial/fajixian" key:@"Internal_Makeup_Facial"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupFacial
                     selectImg:@"iconFaceMakeUpFacialSelected"
                     unselectImg:@"iconFaceMakeUpFacialNormal"
                     title:NSLocalizedString(@"facial_gaoguang", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/facial/gaoguang" key:@"Internal_Makeup_Facial"]
                     tipTitle:@""],
                ];
            }
#pragma mark eyeplump
        case BETypeMakeupEyePlump:
            if ([self be_isLite]) {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyePlump
                     selectImg:@"iconFaceMakeupEyePlumpSelect"
                     unselectImg:@"iconFaceMakeupEyePlumpNormal"
                     title:NSLocalizedString(@"eyeplump_ziran", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/wocan/ziran" key:@"Internal_Makeup_WoCan"]
                     tipTitle:@""],
                ];
            } else {
                return @[
                    [BEEffectItem
                     initWithID:BETypeClose
                     selectImg:@"iconCloseButtonSelected"
                     unselectImg:@"iconCloseButtonNormal"
                     title:NSLocalizedString(@"close", nil)
                     desc:@""
                     model:nil],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyePlump
                     selectImg:@"iconFaceMakeupEyePlumpSelect"
                     unselectImg:@"iconFaceMakeupEyePlumpNormal"
                     title:NSLocalizedString(@"eyeplump_suyan", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/wocan/suyan" key:@"Internal_Makeup_WoCan"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyePlump
                     selectImg:@"iconFaceMakeupEyePlumpSelect"
                     unselectImg:@"iconFaceMakeupEyePlumpNormal"
                     title:NSLocalizedString(@"eyeplump_chulian", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/wocan/chulian" key:@"Internal_Makeup_WoCan"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyePlump
                     selectImg:@"iconFaceMakeupEyePlumpSelect"
                     unselectImg:@"iconFaceMakeupEyePlumpNormal"
                     title:NSLocalizedString(@"eyeplump_manhuayan", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/wocan/manhuayan" key:@"Internal_Makeup_WoCan"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyePlump
                     selectImg:@"iconFaceMakeupEyePlumpSelect"
                     unselectImg:@"iconFaceMakeupEyePlumpNormal"
                     title:NSLocalizedString(@"eyeplump_xiachui", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/wocan/xiachui" key:@"Internal_Makeup_WoCan"]
                     tipTitle:@""],
                    
                    [BEEffectItem
                     initWithID:BETypeMakeupEyePlump
                     selectImg:@"iconFaceMakeupEyePlumpSelect"
                     unselectImg:@"iconFaceMakeupEyePlumpNormal"
                     title:NSLocalizedString(@"eyeplump_taohua", nil)
                     desc:@""
                     model:[BEComposerNodeModel initWithPath:@"/wocan/taohua" key:@"Internal_Makeup_WoCan"]
                     tipTitle:@""],
                ];
            }
        default:
            return @[];
            break;
    }
}

- (BEEffectItem *)be_styleMakeupItem {
    NSString *tag = @"";
    BEEffectItem *item = [BEEffectItem
                          initWithId:BETypeStyleMakeup
                          children:@[
                              [BEEffectItem
                               initWithID:BETypeClose
                               selectImg:@"ic_close_icon"
                               unselectImg:@"ic_close_icon"
                               title:NSLocalizedString(@"close", nil)
                               desc:@""
                               model:nil],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_baicha"
                               unselectImg:@"icon_baicha"
                               title:NSLocalizedString(@"style_makeup_baicha", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/baicha" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_meiyouxiaoxiong"
                               unselectImg:@"icon_meiyouxiaoxiong"
                               title:NSLocalizedString(@"style_makeup_meiyouxiaoxiong", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/meiyouxiaoxiong" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_bingchuanlantong"
                               unselectImg:@"icon_bingchuanlantong"
                               title:NSLocalizedString(@"style_makeup_bingchuan", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/bingchuan" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_qise"
                               unselectImg:@"icon_qise"
                               title:NSLocalizedString(@"style_makeup_qise", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/qise" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_aidou"
                               unselectImg:@"icon_aidou"
                               title:NSLocalizedString(@"style_makeup_aidou", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/aidou" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_youya"
                               unselectImg:@"icon_youya"
                               title:NSLocalizedString(@"style_makeup_youya", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/youya" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_cwei"
                               unselectImg:@"icon_cwei"
                               title:NSLocalizedString(@"style_makeup_cwei", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/cwei" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_nuannan"
                               unselectImg:@"icon_nuannan"
                               title:NSLocalizedString(@"style_makeup_nuannan", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/nuannan" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_baixi"
                               unselectImg:@"icon_baixi"
                               title:NSLocalizedString(@"style_makeup_baixi", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/baixi" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_wennuan"
                               unselectImg:@"icon_wennuan"
                               title:NSLocalizedString(@"style_makeup_wennuan", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/wennuan" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_shensui"
                               unselectImg:@"icon_shensui"
                               title:NSLocalizedString(@"style_makeup_shensui", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/shensui" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_tianmei"
                               unselectImg:@"icon_tianmei"
                               title:NSLocalizedString(@"style_makeup_tianmei", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/tianmei" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_duanmei"
                               unselectImg:@"icon_duanmei"
                               title:NSLocalizedString(@"style_makeup_duanmei", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/duanmei" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_oumei"
                               unselectImg:@"icon_oumei"
                               title:NSLocalizedString(@"style_makeup_oumei", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/oumei" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_zhigan"
                               unselectImg:@"icon_zhigan"
                               title:NSLocalizedString(@"style_makeup_zhigan", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/zhigan" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_hanxi"
                               unselectImg:@"icon_hanxi"
                               title:NSLocalizedString(@"style_makeup_hanxi", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/hanxi" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                              
                              [BEEffectItem
                               initWithID:BETypeStyleMakeup
                               selectImg:@"icon_yuanqi"
                               unselectImg:@"icon_yuanqi"
                               title:NSLocalizedString(@"style_makeup_yuanqi", nil)
                               desc:@""
                               model:[BEComposerNodeModel initWithPath:@"/style_makeup/yuanqi" keyArray:@[@"Filter_ALL", @"Makeup_ALL"] tag:tag]],
                          ]
                          enableMultiSelect:NO];
    item.title = NSLocalizedString(@"tab_style_makeup", nil);
    return item;
}

- (NSString *)be_beautyPath {
    return [self be_isLite] ? @"/beauty_IOS_lite" : @"/beauty_IOS_standard";
}

- (NSString *)be_reshapePath {
    return [self be_isLite] ? @"/reshape_lite" : @"/reshape_standard";
}

- (BOOL)be_hasWhiten {
    switch (self.effectType) {
        case BEEffectTypeLiteNotAsia:
        case BEEffectTypeStandardNotAsia:
            return NO;
        case BEEffectTypeLite:
        case BEEffectTypeStandard:
            return YES;
    }
}

- (BOOL)be_hasDoubleEyelid {
    switch (self.effectType) {
        case BEEffectTypeLiteNotAsia:
        case BEEffectTypeStandardNotAsia:
            return NO;
        case BEEffectTypeLite:
        case BEEffectTypeStandard:
            return YES;
    }
}

- (BOOL)be_isLite {
    switch (self.effectType) {
        case BEEffectTypeLite:
        case BEEffectTypeLiteNotAsia:
            return YES;
        case BEEffectTypeStandard:
        case BEEffectTypeStandardNotAsia:
            return NO;
    }
}

@end
