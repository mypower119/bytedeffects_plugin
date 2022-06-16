//
//  BEBackgroundBlurVC.m
//  Effect
//
//  Created by qun on 2021/5/27.
//

#import "BEBackgroundBlurVC.h"
#import "BEBackgroundBlurView.h"
#import "BEDeviceInfoHelper.h"
#import "TZImagePickerController.h"
#import "Common.h"

static NSString *RENDER_CACHE_TEXTURE_KEY = @"BCCustomBackground";
static NSString *MATTING_STICKER_PATH = @"background_blur";

@interface BEBackgroundBlurVC () <BEBackgroundBlurViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) BEBackgroundBlurView *BackgroundBlurView;

@end

@implementation BEBackgroundBlurVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (int)initSDK {
    int ret = [super initSDK];

    
    [self.manager setStickerPath:MATTING_STICKER_PATH];
    return ret;
}


#pragma mark - BEBoardBottomDelegate
- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    [self baseView:nil didTapRecord:nil];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    [self hideBottomView:self.BackgroundBlurView showBoard:YES];
}
- (void)boardBottomView:(BEBoardBottomView *)view didTapReset:(UIView *)sender{
    self.BackgroundBlurView.effectOn = NO;
    [self.BackgroundBlurView.bvBackgroundBlur setIsSelected:NO];
    [self resetToDefaultEffect:self.defaultEffectOn ? self.dataManager.buttonItemArrayWithDefaultIntensity : @[]];
}

#pragma mark - BEMattingStickerViewDelegate
- (void)BackgroundBlurView:(BEBackgroundBlurView *)view selected:(BOOL)selected {
    
    if (selected) {
        [self.manager setStickerPath:MATTING_STICKER_PATH];
        
    } else {
        [self.manager setStickerPath:@""];
    }
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    [self showBottomView:self.BackgroundBlurView target:self.view];
}

- (void)baseView:(BEBaseBarView *)view didTapReset:(UIView *)sender {
    self.BackgroundBlurView.effectOn = NO;
    [self.BackgroundBlurView.bvBackgroundBlur setIsSelected:NO];
    [self resetToDefaultEffect:self.defaultEffectOn ? self.dataManager.buttonItemArrayWithDefaultIntensity : @[]];
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.BackgroundBlurView.superview != nil) {
        [self hideBottomView:self.BackgroundBlurView showBoard:YES];
    }
}

#pragma mark - getter
- (BEBackgroundBlurView *)BackgroundBlurView {
    if (_BackgroundBlurView) {
        return _BackgroundBlurView;
    }
    
    _BackgroundBlurView = [[BEBackgroundBlurView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT))];
    _BackgroundBlurView.delegate = self;
    return _BackgroundBlurView;
}

@end
