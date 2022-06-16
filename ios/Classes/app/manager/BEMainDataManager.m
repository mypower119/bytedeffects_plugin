//
//  BEMainDataManager.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#import "BEMainDataManager.h"
#import "BEEffectVC.h"
#import "BEBeautyEffectVC.h"
#import "BEStickerVC.h"
#import "BEStyleMakeupVC.h"
#import "BEMattingStickerVC.h"
#import "BEBackgroundBlurVC.h"
#import "BEAlgorithmVC.h"
#import "BEFaceAlgorithmTask.h"
#import "BEHandAlgorithmTask.h"
#import "BESkeletonAlgorithmTask.h"
#import "BEPetFaceAlgorithmTask.h"
#import "BEHeadSegmentAlgorithmTask.h"
#import "BEPortraitMattingAlgorithmTask.h"
#import "BEHairParserAlgorithmTask.h"
#import "BESkySegAlgorithmTask.h"
#import "BELightClsAlgorithmTask.h"
#import "BEHumanDistanceAlgorithmTask.h"
#import "BEConcentrationTask.h"
#import "BEGazeEstimationTask.h"
#import "BEC1AlgorithmTask.h"
#import "BEC2AlgorithmTask.h"
#import "BEVideoClsAlgorithmTask.h"
#import "BECarDetectTask.h"
#import "BEFaceVerifyAlgorithmTask.h"
#import "BEFaceClusterAlgorithmTask.h"
#import "BEAnimojiAlgorithmTask.h"
#import "BEDynamicGestureAlgorithmTask.h"
#import "BESkinSegmentationAlgorithmTask.h"
#import "BEBachSkeletonAlgorithmTask.h"
#import "BEChromaKeyingAlgorithmTask.h"
#import "BELensVC.h"
#import "BEQRScanVC.h"
#import "macro.h"
#import "BEActionRecognitionAlgorithmTask.h"
#import "BESportsAssistantVC.h"
#import "BELocaleManager.h"
#if BEF_USE_CK
#import "CSIFTestViewController.h"
#import "VEHomeViewController.h"
#endif
#if ENABLE_STICKER_TEST
#import "BEStickerTestVC.h"
#endif

@interface BEMainDataManager ()
@end

@implementation BEMainDataManager


static NSString * const GROUP_HOT=@"group_hot";
static NSString * const GROUP_ALGORITHM=@"group_algorithm";
static NSString * const GROUP_EFFECT=@"group_effect";
static NSString * const GROUP_SPORTS=@"group_sports";
static NSString * const GROUP_LENS=@"group_lens";
static NSString * const GROUP_AR=@"group_ar";
static NSString * const GROUP_AR_TRY_ON=@"group_ar_try_on";
#if BEF_USE_CK
static NSString * const GROUP_CK=@"group_creation_kit";
#endif
#if ENABLE_STICKER_TEST
static NSString * const GROUP_TEST=@"group_test";
#endif

/**
 * Feature Items
 */
static NSString * const FEATURE_BEAUTY_LITE = @"feature_beauty_lite";
static NSString * const FEATURE_BEAUTY_STANDARD = @"feature_beauty_standard";
static NSString * const FEATURE_STICKER = @"feature_sticker";
static NSString * const FEATURE_STYLE_MAKEUP = @"feature_style_makeup";
static NSString * const FEATURE_ANIMOJI = @"feature_animoji";
static NSString * const FEATURE_MATTING_STIKCER = @"feature_matting_sticker";
static NSString * const FEATURE_AMAZING_STIKCER = @"feature_amazing_sticker";
static NSString * const FEATURE_BACKGROUND_BLUR = @"feature_background_blur";
static NSString * const FEATURE_AR_LIPSTICK = @"feature_ar_lipstick";
static NSString * const FEATURE_AR_HAIR_DYE = @"feature_ar_hair_dye";
static NSString * const FEATURE_AR_PURSE = @"feature_ar_purse";
static NSString * const FEATURE_AR_NECKLACE = @"feature_ar_necklace";
static NSString * const FEATURE_AR_EARRINGS = @"feature_ar_earrings";
static NSString * const FEAUTRE_QR_SCAN = @"feature_qr_scan";
static NSString * const FEATURE_AR_SCAN = @"feature_ar_scan";
static NSString * const FEATURE_AR_SHOE = @"feature_ar_shoe";
static NSString * const FEATURE_AR_RING = @"feature_ar_ring";
static NSString * const FEATURE_AR_GLASSES = @"feature_ar_glasses";
static NSString * const FEATURE_AR_NAIL = @"feature_ar_nail";
static NSString * const FEATURE_AR_SLAM = @"feature_ar_slam";
static NSString * const FEATURE_AR_OBJECT = @"feature_ar_object";
static NSString * const FEATURE_AR_LANDMARK = @"feature_ar_landmark";
static NSString * const FEATURE_AR_SKY_LAND = @"feature_sky_land";

static NSString * const FEATURE_AR_HAT = @"feature_ar_hat";
static NSString * const FEATURE_AR_WATCH = @"feature_ar_watch";
static NSString * const FEATURE_AR_BRACELEN = @"feature_ar_bracelet";
static NSString * const FEATURE_FACE = @"feature_face";
static NSString * const FEATURE_HAND = @"feature_hand";
static NSString * const FEATURE_SKELETON = @"feature_skeleton";
static NSString * const FEATURE_PET_FACE = @"feature_pet_face";
static NSString * const FEATURE_HEAD_SEG = @"feature_head_seg";
static NSString * const FEATURE_HAIR_PARSE = @"feature_hair_parse";
static NSString * const FEATURE_PORTRAIT_MATTING = @"feature_portrait";
static NSString * const FEATURE_SKY_SEG = @"feature_sky_seg";
static NSString * const FEATURE_LIGHT = @"feature_light";
static NSString * const FEATURE_HUMAN_DISTANCE = @"feature_human_distance";
static NSString * const FEATURE_CONCENTRATE = @"feature_concentrate";
static NSString * const FEATURE_GAZE = @"feature_gaze_estimation";
static NSString * const FEATURE_C1 = @"feature_c1";
static NSString * const FEATURE_C2 = @"feature_c2";
static NSString * const FEATURE_VIDEO_CLS = @"feature_video_cls";
static NSString * const FEATURE_CAR = @"feature_car";
static NSString * const FEATURE_FACE_VREIFY = @"feature_face_verify";
static NSString * const FEATURE_FACE_CLUSTER = @"feature_face_cluster";
static NSString * const FEATURE_DYNAMIC_GESTURE = @"feature_dynamic_gesture";
static NSString * const FEATURE_SKIN_SEGMENTATION = @"feature_skin_segmentation";
static NSString * const FEATURE_BACH_SKELETON = @"feature_bach_skeleton";
static NSString * const FEATURE_CHROMA_KEYING = @"feature_chroma_keying";
static NSString * const FEATURE_SPORT_ASSISTANCE = @"feature_sport_assistance";
static NSString * const FEATURE_VIDEO_SR = @"feature_video_sr";
static NSString * const FEATURE_NIGHT_SCENE = @"feature_night_scene";
static NSString * const FEATURE_ADAPTIVE_SHARPEN = @"feature_adaptive_sharpen";
#if BEF_USE_CK
static NSString * const FEATURE_CREATION_KIT = @"feature_creation_kit";
#endif
#if ENABLE_STICKER_TEST
static NSString * const FEATURE_STICKER_TEST = @"feature_sticker_test";
#endif

- (NSArray<BEFeatureGroup *> *)getFeatureItems:(NSString *)name {
    static dispatch_once_t onceToken;
    static NSMutableArray *items;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSError* error;
        NSArray * jsonarray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        items = [NSMutableArray new];
        if (error != nil) {
            NSLog(@"Error occur when parse custom.json, error is %@", error);
            return;
        }
        
        for (int i = 0; i < jsonarray.count; i++) {
            NSDictionary *dicItem = jsonarray[i];
            NSString * group = dicItem[@"group"];

            BEFeatureGroup *tab = [self featureGroupWithName:group];
            if (tab == nil) {
                NSLog(@"group %@ not found", group);
                continue;
            }

            NSArray *features = dicItem[@"features"];
            for (int j = 0; j < features.count;j++){
                NSString * feature = features[j];
                BEFeatureItem *item = [self featureItemWithName:feature];
                if (item == nil) {
                    NSLog(@"feature %@ not found", feature);
                    continue;
                }

                [tab addChild:item];
            }
            [items addObject:tab];
        }
    });

    return items;
}

- (BEFeatureGroup *)featureGroupWithName:(NSString *)group {
    if ([GROUP_HOT isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"hot_feature"];
    } else if ([GROUP_EFFECT isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"feature_effect"];
    } else if ([GROUP_ALGORITHM isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"feature_algorithm"];
    } else if ([GROUP_SPORTS isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"feature_sport"];
    } else if ([GROUP_AR isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"feature_ar"];
    } else if ([GROUP_AR_TRY_ON isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"feature_ar_try_on"];
    } else if ([GROUP_LENS isEqualToString:group]) {
        if (@available(iOS 11, *)) {
            return [BEFeatureGroup initWithTitle:@"feature_image_quality"];
        }
        return nil;
    }
#if BEF_USE_CK
    else if ([GROUP_CK isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"feature_ck"];
    }
#endif
#if ENABLE_STICKER_TEST
    else if ([GROUP_TEST isEqualToString:group]) {
        return [BEFeatureGroup initWithTitle:@"FOR TEST"];
    }
#endif
    return nil;
}

- (BEFeatureItem *)featureItemWithName:(NSString *)feature {
    BOOL supportWhiten = BELocaleManager.isSupportWhiten;
    BOOL supportFaceVerify = BELocaleManager.isSupportFaceVerify;
#pragma mark effect
    if ([FEATURE_BEAUTY_LITE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_beauty"
                icon:@"ic_feature_beauty"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEBeautyEffectVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .effectTypeW(supportWhiten ? BEEffectTypeLite : BEEffectTypeLiteNotAsia)
                                   )
        ];
    } else if ([FEATURE_BEAUTY_STANDARD isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_beauty_pro"
                icon:@"ic_feature_beauty"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEBeautyEffectVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .effectTypeW(supportWhiten ? BEEffectTypeStandard : BEEffectTypeStandardNotAsia)
                                   )
        ];
    } else if ([FEATURE_AR_LIPSTICK isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_lipstick"
                icon:@"ic_feature_ar_lipstick"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEBeautyEffectVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .effectTypeW(supportWhiten ? BEEffectTypeStandard : BEEffectTypeStandardNotAsia)
                                   .titleW(@"ar_try_lipstick")
                                   )
        ];
    } else if ([FEATURE_AR_HAIR_DYE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_hair_dye"
                icon:@"ic_feature_ar_hair_dye"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEBeautyEffectVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .effectTypeW(supportWhiten ? BEEffectTypeStandard : BEEffectTypeStandardNotAsia)
                                   .titleW(@"ar_hair_color")
                                   )
        ];
    } else if ([FEATURE_STICKER isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_sticker"
                icon:@"ic_feature_sticker"
                config:BEFeatureConfig
                    .newInstance()
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"sticker")))
                    .classW(BEStickerVC.class)
        ];
    } else if ([FEATURE_AR_PURSE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_purse"
                icon:@"ic_feature_ar_purse"
                config:BEFeatureConfig
                    .newInstance()
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-purse")))
                    .classW(BEStickerVC.class)
        ];
    } else if ([FEATURE_AR_NECKLACE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_necklace"
                icon:@"ic_feature_ar_necklace"
                config:BEFeatureConfig
                    .newInstance()
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-necklace")))
                    .classW(BEStickerVC.class)
        ];
    } else if ([FEATURE_AR_EARRINGS isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_earrings"
                icon:@"ic_feature_ar_earrings"
                config:BEFeatureConfig
                    .newInstance()
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-earrings")))
                    .classW(BEStickerVC.class)
        ];
    } else if ([FEATURE_STYLE_MAKEUP isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_style_makeup"
                icon:@"ic_feature_style_makeup"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStyleMakeupVC.class)
        ];
    }
    else if ([FEATURE_ANIMOJI isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_animoji"
                icon:@"ic_feature_animoji"
                config:BEFeatureConfig
                    .newInstance()
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"animoji")))
                    .classW(BEStickerVC.class)
        ];
    } else if ([FEATURE_MATTING_STIKCER isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_matting_sticker"
                icon:@"ic_feature_matting"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEMattingStickerVC.class)
        ];
    }  else if ([FEATURE_BACKGROUND_BLUR isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_background_blur"
                icon:@"ic_feature_background_blur"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEBackgroundBlurVC.class)
        ];
    } else if ([FEATURE_AMAZING_STIKCER isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_amazing_sticker"
                icon:@"ic_feature_amazing_sticker"
                config:BEFeatureConfig
                    .newInstance()
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"amazing-sticker")))
                    .classW(BEStickerVC.class)

        ];
    } else if ([FEAUTRE_QR_SCAN isEqualToString:feature]) {
        BEVideoSourceConfig *qrScanVideoSourceConfig = [BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack];
        qrScanVideoSourceConfig.metadtaType = AVMetadataObjectTypeQRCode;
        qrScanVideoSourceConfig.metadataRect = CGRectMake(0, 0, 1, 1);
        return [BEFeatureItem
                initWithTitle:@"feature_qr_scan"
                icon:@"ic_feature_qrscan"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEQRScanVC.class)
                    .videoSourceConfigW(qrScanVideoSourceConfig)
        ];
    }
#pragma mark algorithm
    else if ([FEATURE_FACE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_face"
                icon:@"ic_feature_face"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEFaceAlgorithmTask.FACE_106.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEFaceAlgorithmTask.FACE_106.algorithmKey]))
        ];
    } else if ([FEATURE_HAND isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_hand"
                icon:@"ic_feature_hand"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEHandAlgorithmTask.HAND.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEHandAlgorithmTask.HAND.algorithmKey]))
        ];
    } else if ([FEATURE_SKELETON isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_body"
                icon:@"ic_feature_skeleton"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BESkeletonAlgorithmTask.SKELETON.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BESkeletonAlgorithmTask.SKELETON.algorithmKey]))
        ];
    } else if ([FEATURE_PET_FACE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_cat_face"
                icon:@"ic_feature_pet_face"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEPetFaceAlgorithmTask.PET_FACE.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEPetFaceAlgorithmTask.PET_FACE.algorithmKey]))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_HEAD_SEG isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_head_seg"
                icon:@"ic_feature_headseg"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEHeadSegmentAlgorithmTask.HEAD_SEGMENT.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEHeadSegmentAlgorithmTask.HEAD_SEGMENT.algorithmKey]))
        ];
    } else if ([FEATURE_PORTRAIT_MATTING isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_portrait"
                icon:@"ic_feature_portrait"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEPortraitMattingAlgorithmTask.PORTRAIT_MATTING.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEPortraitMattingAlgorithmTask.PORTRAIT_MATTING.algorithmKey]))
        ];
    } else if ([FEATURE_HAIR_PARSE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_hair_parse"
                icon:@"ic_feature_hair_parser"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEHairParserAlgorithmTask.HAIR_PARSER.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEHairParserAlgorithmTask.HAIR_PARSER.algorithmKey]))
        ];
    } else if ([FEATURE_SKY_SEG isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_sky_seg"
                icon:@"ic_feature_skyseg"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BESkySegAlgorithmTask.SKY_SEG.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BESkySegAlgorithmTask.SKY_SEG.algorithmKey]))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_LIGHT isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_light"
                icon:@"ic_feature_lightcls"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BELightClsAlgorithmTask.LIGHT_CLS.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BELightClsAlgorithmTask.LIGHT_CLS.algorithmKey]))
        ];
    } else if ([FEATURE_HUMAN_DISTANCE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_human_distance"
                icon:@"ic_feature_human_distance"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEHumanDistanceAlgorithmTask.HUMAN_DISTANCE.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEHumanDistanceAlgorithmTask.HUMAN_DISTANCE.algorithmKey]))
        ];
    } else if ([FEATURE_CONCENTRATE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_concentrate"
                icon:@"ic_feature_concentration"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEConcentrationTask.CONCENTRATION.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEConcentrationTask.CONCENTRATION.algorithmKey]))
        ];
    } else if ([FEATURE_GAZE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_gaze_estimation"
                icon:@"ic_feature_gaze_estimation"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEGazeEstimationTask.GAZE_ESTIMATION.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEGazeEstimationTask.GAZE_ESTIMATION.algorithmKey]))
        ];
    } else if ([FEATURE_C1 isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_c1"
                icon:@"ic_feature_c1"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEC1AlgorithmTask.C1.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEC1AlgorithmTask.C1.algorithmKey]))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_C2 isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_c2"
                icon:@"ic_feature_c2"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEC2AlgorithmTask.C2.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEC2AlgorithmTask.C2.algorithmKey]))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_VIDEO_CLS isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_video_cls"
                icon:@"ic_feature_video_cls"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEVideoClsAlgorithmTask.VIDEO_CLS.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEVideoClsAlgorithmTask.VIDEO_CLS.algorithmKey]))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_CAR isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_car"
                icon:@"ic_feature_car"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BECarDetectTask.CAR.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObjects:@[@(YES), @(YES)] forKeys:@[BECarDetectTask.CAR.algorithmKey, BECarDetectTask.CAR_DETECT.algorithmKey]]))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_FACE_VREIFY isEqualToString:feature]) {
        if (!supportFaceVerify) return nil;
        return [BEFeatureItem
                initWithTitle:@"feature_face_verify"
                icon:@"ic_feature_face_verify"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEFaceVerifyAlgorithmTask.FACE_VERIFY.algorithmKey)
                                      .paramsW([NSDictionary dictionaryWithObjects:@[@(YES)] forKeys:@[BEFaceVerifyAlgorithmTask.FACE_VERIFY.algorithmKey]]))
        ];
    } else if ([FEATURE_FACE_CLUSTER isEqualToString:feature]) {
        if (!supportFaceVerify) return nil;
        return [BEFeatureItem
                initWithTitle:@"feature_face_cluster"
                icon:@"ic_feature_face_cluster"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance()
                                      .typeW(BEFaceClusterAlgorithmTask.FACE_CLUSTER.algorithmKey)
                                      .topBarModeW(BEBaseBarBack | BEBaseBarSetting))
        ];
    } else if ([FEATURE_DYNAMIC_GESTURE isEqualToString:feature]) {
        return  [BEFeatureItem
                 initWithTitle:@"feature_dynamic_gesture"
                 icon:@"ic_feature_dynamic_gesture"
                 config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance().typeW(BEDynamicGestureAlgorithmTask.DYNAMIC_GESTURE.algorithmKey)
                                   .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEDynamicGestureAlgorithmTask.DYNAMIC_GESTURE.algorithmKey]))
                 ];
    } else if ([FEATURE_SKIN_SEGMENTATION isEqualToString:feature]) {
        return  [BEFeatureItem
                 initWithTitle:@"feature_skin_segmentation"
                 icon:@"ic_feature_skin_seg"
                 config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance().typeW(BESkinSegmentationAlgorithmTask.SKIN_SEGMENTATION.algorithmKey)
                                   .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BESkinSegmentationAlgorithmTask.SKIN_SEGMENTATION.algorithmKey]))
                 ];
    } else if ([FEATURE_BACH_SKELETON isEqualToString:feature]) {
        return  [BEFeatureItem
                 initWithTitle:@"feature_bach_skeleton"
                 icon:@"ic_feature_bach_skeleton"
                 config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance().typeW(BEBachSkeletonAlgorithmTask.BACH_SKELETON.algorithmKey)
                                   .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEBachSkeletonAlgorithmTask.BACH_SKELETON.algorithmKey]))
                 ];
    } else if ([FEATURE_CHROMA_KEYING isEqualToString:feature]) {
        return  [BEFeatureItem
                 initWithTitle:@"feature_chroma_keying"
                 icon:@"ic_feature_chroma_keying"
                 config:BEFeatureConfig
                    .newInstance()
                    .classW(BEAlgorithmVC.class)
                    .algorithmConfigW(BEAlgorithmConfig
                                      .newInstance().typeW(BEChromaKeyingAlgorithmTask.CHROMA_KEYING.algorithmKey)
                                   .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEChromaKeyingAlgorithmTask.CHROMA_KEYING.algorithmKey]))
                 ];
    }
#pragma mark ar
    else if ([FEATURE_AR_SCAN isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_scan"
                icon:@"ic_feature_ar_scan"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar_scan"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_SHOE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_shoe"
                icon:@"ic_feature_ar_shoe"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-shoe"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_HAT isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_hat"
                icon:@"ic_feature_ar_hat"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-hat"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionFront])
        ];
    } else if ([FEATURE_AR_SLAM isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_slam"
                icon:@"ic_feature_ar_scan"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-slam"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_OBJECT isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_object"
                icon:@"ic_feature_ar_object"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-object"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_LANDMARK isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_landmark"
                icon:@"ic_feature_ar_landmark"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-landmark"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_SKY_LAND isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_sky_land"
                icon:@"ic_feature_ar_sky_land"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-sky-land"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_RING isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_ring"
                icon:@"ic_feature_ar_ring"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-ring"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_GLASSES isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_glasses"
                icon:@"ic_feature_ar_glasses"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-glasses"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionFront])
        ];
    } else if ([FEATURE_AR_NAIL isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_ar_nail"
                icon:@"ic_feature_ar_nail"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-nail"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW([BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack])
        ];
    } else if ([FEATURE_AR_WATCH isEqualToString:feature]){
        BEVideoSourceConfig *videoSourceConfig = [BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack];
        videoSourceConfig.scale = 1.2f;
        return [BEFeatureItem
                initWithTitle:@"feature_ar_watch"
                icon:@"ic_feature_ar_watch"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-watch"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW(videoSourceConfig)
        ];

    } else if ([FEATURE_AR_BRACELEN isEqualToString:feature]){
        BEVideoSourceConfig *videoSourceConfig = [BEVideoSourceConfig initWithType:BEVideoSourceCamera position:AVCaptureDevicePositionBack];
        videoSourceConfig.scale = 1.2f;
        return [BEFeatureItem
                initWithTitle:@"feature_ar_bracelet"
                icon:@"ic_feature_ar_bracelet"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BEStickerVC.class)
                    .effectConfigW(BEEffectConfig
                                   .newInstance()
                                   .topBarModeW(BEBaseBarBack|BEBaseBarSwitch|BEBaseBarSetting)
                                   .stickerConfigW(BEStickerConfig
                                                   .newInstance(@"ar-try-bracelet"))
                                   .showResetAndCompareW(YES, YES))
                    .videoSourceConfigW(videoSourceConfig)
        ];

    }
#pragma mark sport
    else if ([FEATURE_SPORT_ASSISTANCE isEqualToString:feature]) {
        return [BEFeatureItem
                initWithTitle:@"feature_sport_assistance"
                icon:@"ic_feature_sport"
                config:BEFeatureConfig
                    .newInstance()
                    .classW(BESportsAssistantVC.class)
        ];
    }
#pragma mark lens
    else if ([FEATURE_VIDEO_SR isEqualToString:feature]) {
        if (@available(iOS 11, *)) {
            return [BEFeatureItem
                    initWithTitle:@"feature_video_sr"
                    icon:@"ic_feature_video_sr"
                    config:BEFeatureConfig
                        .newInstance()
                        .classW(BELensVC.class)
                        .videoSourceConfigW([BEVideoSourceConfig
                                             initWithType:BEVideoSourceCamera
                                             position:AVCaptureDevicePositionFront])
                        .lensConfigW([BELensConfig initWithType:VIDEO_SR open:YES])
            ];
        } else {
            return nil;
        }
    } else if ([FEATURE_ADAPTIVE_SHARPEN isEqualToString:feature]) {
        if (@available(iOS 11, *)) {
            return [BEFeatureItem
                    initWithTitle:@"feature_adaptive_sharpen"
                    icon:@"ic_feature_adaptive_sharpen"
                    config:BEFeatureConfig
                        .newInstance()
                        .classW(BELensVC.class)
                        .videoSourceConfigW([BEVideoSourceConfig
                                             initWithType:BEVideoSourceCamera
                                             position:AVCaptureDevicePositionFront])
                        .lensConfigW([BELensConfig initWithType:ADAPTIVE_SHARPEN open:YES])
            ];
        } else {
            return nil;
        }
    }
#if BEF_USE_CK
   else if ([FEATURE_CREATION_KIT isEqualToString:feature]) {
       return [BEFeatureItem
                      initWithTitle:@"feature_ck"
                      icon:@"ic_feature_video_sr"
                      config:BEFeatureConfig
                          .newInstance()
                          .classW(VEHomeViewController.class)
              ];
     }
#endif
#if ENABLE_STICKER_TEST
   else if ([FEATURE_STICKER_TEST isEqualToString:feature]) {
       return [BEFeatureItem
               initWithTitle:@"Test Sticker"
               icon:@"ic_feature_sticker"
               config:BEFeatureConfig.newInstance()
                        .classW(BEStickerTestVC.class)];
   }
#endif
    return nil;
}

@end
