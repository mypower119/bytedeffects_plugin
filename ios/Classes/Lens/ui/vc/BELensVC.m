//
//  BELensVC.m
//  Lens
//
//  Created by wangliu on 2021/6/2.
//

#import "BELensVC.h"
#import "BELensView.h"
#import "BELensResourceHelper.h"
#import "BEDeviceInfoHelper.h"
#import "BEImageQualityProcessManager.h"
#import "BEVideoCapture.h"
#import "BEBubbleTipManager.h"
#import "BELicenseHelper.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "CommonSize.h"

static NSString *const LENS_PRESET_KEY = @"lens_preset";
static NSString *const LENS_PERFORMANCE_KEY = @"lens_performance";

@interface BELensVC () <BELensViewDelegate>

@property (nonatomic, strong) UIView *lensView;
@property (atomic, assign) BOOL algorithmOn;
@property (nonatomic, strong) NSArray *popoverConfigs;

@property (nonatomic, strong) BEImageQualityProcessManager *imageQualityManager;
@property (nonatomic, strong) BEBubbleTipManager *tipManager;

@end

@implementation BELensVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _algorithmOn = NO;
    }
    return self;
}

- (void)viewDidLoad {
    self.lensConfig = (BELensConfig *)self.configDict[LENS_CONFIG_KEY];
    if (self.lensConfig == nil) {
        NSLog(@"invalid lens config");
        return;
    }
    
    [super viewDidLoad];
    
    if (self.lensConfig.showBoard) {
        [self showBottomView:self.lensView target:self.view];
    }
}

#pragma mark - SDK
- (int)initSDK {
    self.imageQualityManager = [[BEImageQualityProcessManager alloc] initWithProvider:[BELicenseHelper shareInstance]];
    
    switch (self.lensConfig.type) {
        case VIDEO_SR:
            [self.imageQualityManager setEnableVideoSr:YES];
            break;
        case ADAPTIVE_SHARPEN:
            [self.imageQualityManager setEnableAdaptiveSharpen:YES];
        default:
            break;
    }
    self.algorithmOn = self.lensConfig.open;
    return 0;
}

- (void)processWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(int)rotation timeStamp:(double)timeStamp {
    //    {zh} 将输入的 CVPixelBuffer 转换成纹理        {en} Convert input CVPixelBuffer to texture  
    id<BEGLTexture> texture;
    CVPixelBufferRef imageQualityProcessedBuffer = nil;
    
    if (@available(iOS 11.0, *)) {
        if(self.algorithmOn){
            {
                ImageQualityProcessData input, output;

                input.data.pixelBuffer = pixelBuffer;
                input.type = ImageQualityDataTypeCVPixelBuffer;

                ImageQualityProcessFinishStatus status = [self.imageQualityManager imageQualityProcess:&input output:&output];

                //Mean internal has produce a pixelbuffer, and we need to release it
                if (status == ImageQualityProcessFinishStatusSuccessNewPixelBuffer){
                    imageQualityProcessedBuffer = output.data.pixelBuffer;
                }else if (status == ImageQualityProcessFinishStatusSuccess){
                    pixelBuffer = output.data.pixelBuffer;
                }else if (status == ImageQualityProcessFinishStatusDoNothing){ // Do nothing, write here to keep it clear
                }
            }
            if (imageQualityProcessedBuffer != pixelBuffer && imageQualityProcessedBuffer){
                texture = [self.imageUtils transforCVPixelBufferToTexture:imageQualityProcessedBuffer];
            }else {
                texture = [self.imageUtils transforCVPixelBufferToTexture:pixelBuffer];
            }
        } else {
            texture = [self.imageUtils transforCVPixelBufferToTexture:pixelBuffer];
        }
    } else {
        texture = [self.imageUtils transforCVPixelBufferToTexture:pixelBuffer];
    }
    
    [self drawGLTextureOnScreen:texture rotation:rotation];
    
    if (imageQualityProcessedBuffer != pixelBuffer && imageQualityProcessedBuffer) {
        CFRelease(imageQualityProcessedBuffer);
    }
}

- (void)destroySDK {
    
}

#pragma mark - BEPopoverManagerDelegate
- (void)popover:(BEPopoverManager *)manager configDidChange:(NSObject *)config key:(NSString *)key {
    if (key == LENS_PRESET_KEY) {
        //  {zh} 分辨率  {en} Resolution
        BESwitchItemConfig *cf = (BESwitchItemConfig *)config;
        AVCaptureSessionPreset preset = [self sessionPresets][cf.selectIndex];
        if (self.videoSourceConfig.type == BEVideoSourceCamera) {
            [(BEVideoCapture *)self.videoSource setSessionPreset:preset];
        }
    } else if (key == LENS_PERFORMANCE_KEY) {
        //  {zh} 性能  {en} Performance
        BESingleSwitchConfig *cf = (BESingleSwitchConfig *)config;
        [self showProfile:cf.isOn];
    }
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    [self showBottomView:self.lensView target:self.view];
}

- (void)baseView:(BEBaseBarView *)view didTapSetting:(UIView *)sender {
    [self showPopoverViewWithConfigs:self.popoverConfigs anchor:sender];
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.lensView.superview != nil) {
        [self hideBottomView:self.lensView];
    }
}

#pragma mark - BEBoardBottomViewDelegate
- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    [self hideBottomView:self.lensView];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    [self baseView:nil didTapRecord:nil];
}

#pragma mark - BELensViewDelegate
- (void)selectableButton:(BESelectableButton *)button didTap:(UITapGestureRecognizer *)sender {
    button.isSelected = !button.isSelected;
    self.algorithmOn = button.isSelected;
    
    [self.tipManager showBubble:NSLocalizedString([self buttonItem].title, nil) desc:nil duration:2];
    
    if (self.lensConfig.type == VIDEO_SR || self.lensConfig.type == ADAPTIVE_SHARPEN) {
        if (@available(iOS 11.0, *)) {
//            if (self.lensConfig.type == VIDEO_SR) {
//                self.imageQualityManager.enableVideoSr = self.algorithmOn;
//            } else if (self.lensConfig.type == ADAPTIVE_SHARPEN) {
//                self.imageQualityManager.enableAdaptiveSharpen = self.algorithmOn;
//            }
        } else {
            if (self.algorithmOn) {
                [self.view makeToast:NSLocalizedString(@"video_sr_ios_version", nil)];
            }
        }
    }
}

#pragma mark - others
- (void)updateBottomView:(UIView *)view withSize:(CGSize)size {
    if (!view.superview) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
        [view.superview layoutIfNeeded];
    }];
}

- (void)showBottomView:(UIView *)view target:(UIView *)target {
    self.gestureManager.enable = NO;
    [self.baseView hideBoard];
    [target addSubview:view];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(target);
        make.top.equalTo(target.mas_bottom);
        make.height.mas_equalTo(view.frame.size.height);
    }];
    [target layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(target);
            make.height.mas_equalTo(view.frame.size.height);
        }];
        [target layoutIfNeeded];
    }];
}

- (void)hideBottomView:(UIView *)view {
    self.gestureManager.enable = YES;
    UIView *target = view.superview;
    [UIView animateWithDuration:0.3 animations:^{
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(target);
            make.top.equalTo(target.mas_bottom);
            make.height.mas_equalTo(view.frame.size.height);
        }];
        [target layoutIfNeeded];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self.baseView showBoard];
    }];
}

#pragma mark - getter
- (UIView *)lensView {
    if (_lensView) {
        return _lensView;
    }

    BELensView *lensView = [[BELensView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT))];
    lensView.delegate = self;
    lensView.item = [self buttonItem];
    lensView.isOpen = self.lensConfig.open;
    _lensView = lensView;
    return _lensView;
}

- (BEButtonItem *)buttonItem {
    switch (self.lensConfig.type) {
        case VIDEO_SR:
            return [[BEButtonItem alloc] initWithSelectImg:@"ic_video_sr_highlight"
                                               unselectImg:@"ic_video_sr_normal"
                                                     title:@"feature_video_sr"
                                                      desc:@""];
        case ADAPTIVE_SHARPEN:
            return [[BEButtonItem alloc] initWithSelectImg:@"ic_adaptive_sharp_highlight"
                                               unselectImg:@"ic_adaptive_sharp_normal"
                                                     title:@"feature_adaptive_sharpen"
                                                      desc:@""];
        default:
            return nil;
    }
}

- (NSArray *)popoverConfigs {
    if (_popoverConfigs) {
        return _popoverConfigs;
    }
    
    NSMutableArray *configs = [NSMutableArray array];
    if (self.videoSourceConfig.type == BEVideoSourceCamera) {
        [configs addObject:[[BESwitchItemConfig alloc]
                            initWithTitle:@"resolution" items:@[@"1280*720", @"640*480"] selectIndex:[[self sessionPresets] indexOfObject:AVCaptureSessionPreset1280x720] key:LENS_PRESET_KEY]];
    }
    [configs addObject:[[BESingleSwitchConfig alloc]
                        initWithTitle:@"profile" isOn:NO key:LENS_PERFORMANCE_KEY]];
    _popoverConfigs = [configs copy];
    return _popoverConfigs;
}

- (NSArray *)sessionPresets {
    return @[AVCaptureSessionPreset1280x720, AVCaptureSessionPreset640x480];
}

- (BEBubbleTipManager *)tipManager {
    if (_tipManager) {
        return _tipManager;
    }
    
    _tipManager = [[BEBubbleTipManager alloc] initWithContainer:self.view topMargin:100];
    return _tipManager;
}

- (NSString *)viewControllerKey {
    return [NSString stringWithFormat:@"%@_%ld", NSStringFromClass(self.class), self.lensConfig.type];
}

@end


