//
//  BEVideoClsUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEVideoClsUI.h"
#import "BEC1InfoVC.h"
#import "BETextSizeUtils.h"
#import "BEVideoClsAlgorithmTask.h"

static int TOP_N = 1;
static int MIN_WIDTH = 120;

@interface BEVideoClsUI ()

@property (nonatomic, strong)BEC1InfoVC *vcInfo;

@end

@implementation BEVideoClsUI

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];
    
    CHECK_ARGS_AVAILABLE(1, self.provider)
    [self.provider showOrHideVC:self.vcInfo show:flag];
}

- (void)onReceiveResult:(BEVideoClsAlgorithmResult *)result {
    if (result == nil || result.videoInfo == nil) {
        return;
    }
    
    bef_ai_video_cls_ret videoInfo = *result.videoInfo;
    
    int max = -1;
    for (int i = 0; i < videoInfo.n_classes; i++) {
        if (videoInfo.classes[i].confidence > videoInfo.classes[i].thres && (max < 0 || videoInfo.classes[i].confidence > videoInfo.classes[max].confidence)) {
            max = i;
        }
    }
    if (max < 0) {
        [self.vcInfo updateInfo:NSLocalizedString(@"tab_video_cls", nil) value:NSLocalizedString(@"video_cls_no_results", nil)];
    } else {
        bef_ai_video_cls_type c = videoInfo.classes[max];
        NSString *title = [self types][c.id];
        NSString *value = [NSString stringWithFormat:@"%.2f", c.confidence];
        NSString *text = [title stringByAppendingFormat:@"test%@", value];
        CGFloat width = MAX([BETextSizeUtils calculateTextWidth:text size:13], MIN_WIDTH);
        [self.vcInfo updateInfo:title value:value];
    }
}

- (BEAlgorithmItem *)algorithmItem {
    BEAlgorithmItem *videoCls = [[BEAlgorithmItem alloc] initWithSelectImg:@"ic_videocls_highlight"
                                                               unselectImg:@"ic_videocls_normal"
                                                                     title:@"feature_video_cls"
                                                                      desc:@""];
    videoCls.key = BEVideoClsAlgorithmTask.VIDEO_CLS;
    return videoCls;
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
        @"human", @"baby", @"kid", @"half-selfie", @"full-selfie", @"multi-person", @"kid-parent", @"kid-show",
        @"crowd", @"dinner", @"wedding", @"avatar", @"homelife", @"yard,balcony", @"furniture,appliance",
        @"urbanlife", @"supermarket", @"streets", @"parks", @"campus", @"building", @"bridges", @"station",
        @"transportation", @"car", @"train", @"plane", @"entertainment", @"ktv,bar", @"mahjomg", @"amusement-park",
        @"drama,cross-talk,cinema", @"concert,music-festival", @"museum", @"food", @"food-show", @"snacks",
        @"home-foods", @"fruit", @"drinks", @"japanese-food", @"hot-pot", @"barbecue", @"noodles", @"cake",
        @"cooking", @"natural-scene", @"mountain", @"rivers,lakes,sea", @"road", @"grass", @"waterfull",
        @"desert", @"forest", @"snow", @"fileworks", @"sky", @"cultural-scene", @"animals", @"pets", @"livestock",
        @"plants", @"flowers", @"pets-plants", @"ball", @"soccer", @"basketball", @"badminton", @"tennis",
        @"pingpong", @"billiard", @"keep-fit", @"yoga", @"track-and-field", @"extreme-sports", @"water-sports",
        @"swim", @"dance", @"singing", @"game", @"cartoon", @"cosplay", @"texts", @"papers", @"cards", @"sensitive",
        @"sex", @"synthesis@"];
    });
    return arr;
}

@end
