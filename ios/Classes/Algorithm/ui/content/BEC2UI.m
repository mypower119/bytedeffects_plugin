//
//  BEC2UI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEC2UI.h"
#import "BEC1InfoVC.h"
#import "BETextSizeUtils.h"
#import "BEC2AlgorithmTask.h"

static int TOP_N = 1;
static int MIN_WIDTH = 120;

@interface BEC2UI ()

@property (nonatomic, strong)BEC1InfoVC *vcInfo;

@end

@implementation BEC2UI

- (void)onReceiveResult:(BEC2AlgorithmResult *)result {
    if (result == nil || result.c2Info == nil) {
        return;
    }
    
    bef_ai_c2_ret c2Info = *result.c2Info;
    int max = -1;
    for (int i = 0; i < c2Info.n_classes; i++) {
        if (c2Info.items[i].satisfied && (max < 0 || c2Info.items[i].confidence > c2Info.items[max].confidence)) {
            max = i;
        }
    }
    if (max < 0) {
        [self.vcInfo updateInfo:NSLocalizedString(@"tab_c2", nil) value:NSLocalizedString(@"video_cls_no_results", nil)];
    } else {
        bef_ai_c2_category_item c = c2Info.items[max];
        NSString *title = [self types][c.id];
        NSString *value = [NSString stringWithFormat:@"%.2f", c.confidence];
        [self.vcInfo updateInfo:title value:value];
    }
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *c2 = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_c2_highlight"
                                                         unselectImg:@"ic_c2_normal"
                                                               title:@"tab_c2"
                                                                desc:@"c2_desc"];
    c2.key = BEC2AlgorithmTask.C2;
    return c2;
}

- (BEC1InfoVC *)vcInfo {
    if (_vcInfo == nil) {
        _vcInfo = [BEC1InfoVC new];
    }
    return _vcInfo;
}

- (NSArray *)types {
    static NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[
        @"car_c1", @"cat_c1", @"bus_station", @"Giraffe", @"vegetables", @"Cave", @"jiehunzhao",
        @"sr_camera", @"yinger", @"zhongcan", @"lawn", @"soccer_field", @"selfie_c1", @"GaoTie",
        @"broadleaf_forest", @"Americal_Fast_Food", @"islet", @"dining_hall", @"formal_garden",
        @"carrousel", @"food_court", @"Pc_game", @"card_data", @"Pig", @"golf_course", @"mianshi",
        @"Peacock", @"ertong", @"supermarket", @"sushi", @"badminton_indoor", @"Panda", @"ruin", @"TingYuan",
        @"Graduation", @"ZhanDao", @"tennis_outdoor", @"snacks", @"DuoRouZhiWu", @"ocean_liner", @"Snooker",
        @"hill_c1", @"GongDian", @"beach_c1", @"QuanJiaFu", @"dog_c1", @"bankcard", @"Swimming", @"godfish",
        @"grill", @"LuYing", @"fountain", @"flower_c1", @"rabbit", @"Hamster", @"desert", @"banquet_hall",
        @"farm", @"Tortoise", @"Ski", @"downtown", @"moutain_path", @"street_c1", @"HaiXian", @"Bonfire",
        @"movie_theater", @"PaoBu", @"park", @"mobilephone", @"Monument", @"Elepant", @"hotpot", @"KingPenguin",
        @"natural_river", @"text_c1", @"tv", @"cartoon_c1", @"swimming_pool_indoor", @"lake_c1", @"mountain_snowy",
        @"fruit", @"gymnasimum", @"skyscraper", @"amusement_arcade", @"Soccerball", @"big_neg", @"statue_c1",
        @"xiangcunjianzhu", @"shineijiudianjucan", @"group_c1", @"cake", @"creek", @"ShaLa", @"nightscape_c1",
        @"bridge", @"ocean", @"DiTie", @"shiwaiyoulechagn", @"train_station", @"tree_c1", @"baseball", @"Tiger",
        @"temple", @"gujianzhu", @"Card_game", @"throne_room", @"xuejing", @"tower", @"bazaar_outdoor",
        @"basketball_court_indoor", @"QinZiSheYing", @"drink", @"ktv", @"athletic_field", @"screen",
        @"note_labels", @"pure_text", @"puzzle", @"qrcode", @"scrawl_mark", @"solidcolor_bg", @"tv_screen"];
    });
    return arr;
}

@end
