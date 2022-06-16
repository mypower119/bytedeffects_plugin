//
//  BEEffectVC.m
//  Effect
//
//  Created by qun on 2021/5/17.
//

#import "BEEffectVC.h"
#import "BEImageUtils.h"
#import "BEEffectManager.h"
#import "BEEffectResourceHelper.h"
#import "BELicenseHelper.h"
#import "BEBaseBarView.h"
#import "BEGestureManager.h"
#import "BEPreviewSizeManager.h"
#import "Masonry.h"
#import "Common.h"

static NSString *const EFFECT_DEFAULT_KEY = @"effect_default";
static NSString *const EFFECT_PERFORMANCE_KEY = @"effect_performance";

@interface BEEffectVC ()

@property (nonatomic, assign) BOOL effectOn;
@property (nonatomic, strong) NSArray *popoverConfigs;
@property (nonatomic, strong) NSMutableSet *allIntensityItem;

@end

@implementation BEEffectVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _effectOn = YES;
        _defaultEffectOn = YES;
        _allIntensityItem = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad {
    self.effectConfig = (BEEffectConfig *)self.configDict[EFFECT_CONFIG_KEY];
    if (self.effectConfig == nil) {
        NSLog(@"invalid effect config");
        return;
    }
    
    [super viewDidLoad];
    
    [self.view addSubview:self.effectBaseView];
    [self.effectBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.effectConfig.showBoard) {
        [self baseView:nil didTapOpen:nil];
    }
    
    [self.gestureManager attachView:self.baseView];
    
    NSInteger baseBarMode = self.effectConfig.topBarMode;
    if (self.videoSourceConfig.type != BEVideoSourceCamera) {
        baseBarMode &= ~BEBaseBarImagePicker;
        baseBarMode &= ~BEBaseBarSwitch;
    }
    [self.baseView showBar:baseBarMode];
    self.baseView.showReset = YES;
}

#pragma mark - sdk lifecycle
- (int)initSDK {
    self.manager = [[BEEffectManager alloc] initWithResourceProvider:[BEEffectResourceHelper new] licenseProvider:[BELicenseHelper shareInstance]];
    int ret = [self.manager initTask];
    if (ret == BEF_RESULT_SUC){
        if (self.defaultEffectOn) {
            [self resetToDefaultEffect:self.dataManager.buttonItemArrayWithDefaultIntensity];
        } else if (self.effectConfig.isAutoTest) {
            [self setEffectWithConfig:self.effectConfig];
        }
    }
    self.manager.delegate = self;
    
    return ret;
}

//  {zh} 对于 iphoneX 以上机型，右边的重置/对比按钮的 touchDown 事件会不时被系统的  {en} For iPhone X and above, the touchDown event of the reset/contrast button on the right will be
//  {zh} 某个手势事件影响，导致 touchDown 事件延迟 1s 左右出现，重写这个方法，  {en} A gesture event affects, causing the touchDown event to appear with a delay of about 1s. Override this method,
//  {zh} 返回 UIRectEdgeRight，可以使右边框的手势优先于系统手势响应  {en} Returns UIRectEdgeRight to make the gesture on the right border take precedence over the system gesture response
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return UIRectEdgeRight;
}

- (void)processWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(int)rotation timeStamp:(double)timeStamp {
    BEPixelBufferInfo *pixelBufferInfo = [self.imageUtils getCVPixelBufferInfo:pixelBuffer];
    if (pixelBufferInfo.format != BE_BGRA) {
        pixelBuffer = [self.imageUtils transforCVPixelBufferToCVPixelBuffer:pixelBuffer outputFormat:BE_BGRA];
    }
    if (rotation != 0) {
        //  {zh} 特效 SDK 接收的纹理必须是正的，所以在调用 SDK 之前，需要先行旋转一下  {en} The texture received by the special effects SDK must be positive, so before calling the SDK, you need to rotate it first
        pixelBuffer = [self.imageUtils rotateCVPixelBuffer:pixelBuffer rotation:rotation];
    }
    
    id<BEGLTexture> texture = [self.imageUtils transforCVPixelBufferToTexture:pixelBuffer];
    id<BEGLTexture> outTexture = nil;
    if (self.effectOn) {
        outTexture = [self.imageUtils getOutputPixelBufferGLTextureWithWidth:texture.width height:texture.height format:BE_BGRA];
        
        self.manager.frontCamera = self.videoSource.frontCamera;
        int ret = [self.manager processTexture:texture.texture outputTexture:outTexture.texture width:texture.width height:texture.height rotate:[self getDeviceOrientation] timeStamp:timeStamp];
        if (ret != BEF_RESULT_SUC) {
            outTexture = texture;
        }
//        int outputTexture = outTexture.texture;de
//        CVPixelBufferRef outputPixelBuffer = outTexture.pixelBuffer;
    } else {
        outTexture = texture;
    }
    
    [self drawGLTextureOnScreen:outTexture rotation:0];
    
    if (rotation != 0) {
        CVPixelBufferRelease(pixelBuffer);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BEPreviewSizeManager singletonInstance] updateViewWidth:self.view.frame.size.width viewHeight:self.view.frame.size.height previewWidth:outTexture.width previewHeight:outTexture.height fitCenter:self.videoSourceConfig.type != BEVideoSourceCamera];
    });
}

- (bef_ai_rotate_type)getDeviceOrientation {
    if (self.videoSourceConfig.type != BEVideoSourceCamera) {
        return 0;
    }
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return BEF_AI_CLOCKWISE_ROTATE_0;

        case UIDeviceOrientationPortraitUpsideDown:
            return BEF_AI_CLOCKWISE_ROTATE_180;

        case UIDeviceOrientationLandscapeLeft:
            return BEF_AI_CLOCKWISE_ROTATE_270;

        case UIDeviceOrientationLandscapeRight:
            return BEF_AI_CLOCKWISE_ROTATE_90;

        default:
            return BEF_AI_CLOCKWISE_ROTATE_0;
    }
}

- (void)destroySDK {
    [self.manager destroyTask];
}

#pragma mark - SDK method
- (void)resetToDefaultEffect:(NSArray<BEEffectItem *> *)items {
    [self.manager setFilterPath:@""];
    [self.manager setStickerPath:@""];
    
    //  {zh} 清空历史项  {en} Clear history
    for (BEEffectItem *item in [self.allIntensityItem copy]) {
        [self updateComposerNodeIntensity:item];
    }
    [self.allIntensityItem removeAllObjects];
    
    [self updateComposerNode:items];
    for (BEEffectItem *item in items) {
        [self updateComposerNodeIntensity:item];
    }
}

- (void)updateComposerNode:(NSArray<BEEffectItem *> *)items {
    NSMutableArray<NSString *> *nodes = [NSMutableArray arrayWithCapacity:items.count];
    NSMutableArray<NSString *> *tags = [NSMutableArray arrayWithCapacity:items.count];
    for (BEEffectItem *item in items) {
        [nodes addObject:item.model.path];
        [tags addObject:item.model.tag == nil ? @"" : item.model.tag];
    }
    
    [self.videoSource pause];
    [self lockSDK];
    [self.manager updateComposerNodes:nodes withTags:tags];
    [self unlockSDK];
    [self.videoSource resume];
}

- (void)updateComposerNodeIntensity:(BEEffectItem *)item {
    [self.allIntensityItem addObject:item];
    [self.videoSource pause];
    [self lockSDK];
    for (int i = 0; i < item.model.keyArray.count; i++) {
        [self.manager updateComposerNodeIntensity:item.model.path key:item.model.keyArray[i] intensity:[item.intensityArray[i] floatValue]];
    }
    [self unlockSDK];
    [self.videoSource resume];
}

- (void)refreshEffect {
    if (self.defaultEffectOn) {
        [self updateComposerNode:self.dataManager.buttonItemArrayWithDefaultIntensity];
        for (BEEffectItem *item in self.dataManager.buttonItemArrayWithDefaultIntensity) {
            [self updateComposerNodeIntensity:item];
        }
    } else {
        [self updateComposerNode:@[]];
    }
}

- (void)setEffectWithConfig:(BEEffectConfig *)config {
    if (config.filterName != nil) {
        [self.manager setFilterPath:config.filterName];
        [self.manager setFilterIntensity:config.filterIntensity];
    }
    
    if (config.stickerConfig != nil && config.stickerConfig.stickerPath != nil) {
        [self.manager setStickerPath:config.stickerConfig.stickerPath];
    }
    
    if (config.composerNodes != nil) {
        NSMutableArray<NSString *> *nodes = [NSMutableArray array];
        NSMutableArray<NSString *> *tags = [NSMutableArray array];
        for (BEComposerNodeModel *model in config.composerNodes) {
            [nodes addObject:model.path];
            [tags addObject:model.tag == nil ? @"" : model.tag];
        }
        
        [self.manager updateComposerNodes:nodes withTags:tags];
        for (BEComposerNodeModel *model in config.composerNodes) {
            for (int i = 0; i < model.keyArray.count; i++) {
                [self.manager updateComposerNodeIntensity:model.path key:model.keyArray[i] intensity:[model.valueArray[i] floatValue]];
            }
        }
    }
}

#pragma mark - BEEffectBaseViewDelegate
- (void)effectBaseView:(BEEffectBaseView *)view onTouchDownCompare:(UIView *)sender {
    self.effectOn = NO;
}

- (void)effectBaseView:(BEEffectBaseView *)view onTouchUpCompare:(UIView *)sender {
    self.effectOn = YES;
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapSetting:(UIView *)sender {
    [self showPopoverViewWithConfigs:self.popoverConfigs anchor:sender];
}

- (void)baseView:(BEBaseBarView *)view didTapReset:(UIView *)sender {
    [self resetToDefaultEffect:self.defaultEffectOn ? self.dataManager.buttonItemArrayWithDefaultIntensity : @[]];
}

- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {}

#pragma mark - BEBoardBottomViewDelegate
- (BOOL)boardBottomViewShowReset:(BEBoardBottomView *)view {
    return self.effectConfig.showResetButton;
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapReset:(UIView *)sender {
    [self resetToDefaultEffect:self.defaultEffectOn ? self.dataManager.buttonItemArrayWithDefaultIntensity : @[]];
}

#pragma mark - BEPopoverManagerDelegate
- (void)popover:(BEPopoverManager *)manager configDidChange:(NSObject *)config key:(NSString *)key {
    if (key == EFFECT_DEFAULT_KEY) {
        //  {zh} 默认美颜  {en} Default Beauty
        BESingleSwitchConfig *cf = (BESingleSwitchConfig *)config;
        self.defaultEffectOn = cf.isOn;
        [self refreshEffect];
    } else if (key == EFFECT_PERFORMANCE_KEY) {
        //  {zh} 性能  {en} Performance
        BESingleSwitchConfig *cf = (BESingleSwitchConfig *)config;
        [self showProfile:cf.isOn];
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
    view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, view.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-view.frame.size.height, [UIScreen mainScreen].bounds.size.width, view.frame.size.height);
    }];
}

- (void)hideBottomView:(UIView *)view showBoard:(BOOL)isShowBoard {
    self.gestureManager.enable = YES;
//    UIView *target = view.superview;
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if (isShowBoard == YES) {
            [self.baseView showBoard];
        }
    }];
}

#pragma mark - BEGestureDelegate
- (void)gestureManager:(BEGestureManager *)manager onGesture:(BEGestureType)gesture x:(CGFloat)x y:(CGFloat)y dx:(CGFloat)dx dy:(CGFloat)dy factor:(CGFloat)factor {
    [super gestureManager:manager onGesture:gesture x:x y:y dx:dx dy:dy factor:factor];
    
    switch (gesture) {
        case BEGestureTypeTap:
        {
            x = [[BEPreviewSizeManager singletonInstance] viewToPreviewXFactor:x];
            y = [[BEPreviewSizeManager singletonInstance] viewToPreviewYFactor:y];
            [self.manager processGestureEvent:BEF_AI_GESTURE_TAP x:x y:y dx:dx dy:dy factor:factor];
        }
            break;
        case BEGestureTypeRotate:
        {
            [self.manager processGestureEvent:BEF_AI_GESTURE_ROTATE x:x y:y dx:dx dy:dy factor:factor];
        }
            break;
        case BEGestureTypeScale:
        {
            [self.manager processGestureEvent:BEF_AI_GESTURE_SCALE x:x y:y dx:dx dy:dy factor:factor];
        }
            break;
        case BEGestureTypePan:
        {
            x = [[BEPreviewSizeManager singletonInstance] viewToPreviewXFactor:x];
            y = [[BEPreviewSizeManager singletonInstance] viewToPreviewYFactor:y];
            dx = [[BEPreviewSizeManager singletonInstance] viewToPreviewXFactor:dx];
            dy = [[BEPreviewSizeManager singletonInstance] viewToPreviewYFactor:dy];
            [self.manager processGestureEvent:BEF_AI_GESTURE_PAN x:x y:y dx:dx dy:dy factor:factor];
        }
            break;
        case BEGestureTypeLongPress:
        {
            x = [[BEPreviewSizeManager singletonInstance] viewToPreviewXFactor:x];
            y = [[BEPreviewSizeManager singletonInstance] viewToPreviewYFactor:y];
            [self.manager processGestureEvent:BEF_AI_GESTURE_LONG_PRESS x:x y:y dx:dx dy:dy factor:factor];
        }
            break;
        default:
            break;
    }
}

- (void)gestureManager:(BEGestureManager *)manager onTouchEvent:(BETouchEvent)event x:(CGFloat)x y:(CGFloat)y force:(CGFloat)force majorRadius:(CGFloat)majorRadius pointerId:(NSInteger)pointerId pointerCount:(NSInteger)pointerCount {
    x = [[BEPreviewSizeManager singletonInstance] viewToPreviewXFactor:x];
    y = [[BEPreviewSizeManager singletonInstance] viewToPreviewYFactor:y];
    switch (event) {
        case BETouchEventBegan:
            [self.manager processTouchEvent:BEF_AI_TOUCH_EVENT_BEGAN x:x y:y force:force majorRadius:majorRadius pointerId:(int)pointerId pointerCount:(int)pointerCount];
            break;
        case BETouchEventMoved:
            [self.manager processTouchEvent:BEF_AI_TOUCH_EVENT_MOVED x:x y:y force:force majorRadius:majorRadius pointerId:(int)pointerId pointerCount:(int)pointerCount];
            break;
        case BETouchEventStationary:
            [self.manager processTouchEvent:BEF_AI_TOUCH_EVENT_STATIONARY x:x y:y force:force majorRadius:majorRadius pointerId:(int)pointerId pointerCount:(int)pointerCount];
            break;
        case BETouchEventEnded:
            [self.manager processTouchEvent:BEF_AI_TOUCH_EVENT_ENDED x:x y:y force:force majorRadius:majorRadius pointerId:(int)pointerId pointerCount:(int)pointerCount];
            break;
        case BETouchEventCanceled:
            [self.manager processTouchEvent:BEF_AI_TOUCH_EVENT_CANCELLED x:x y:y force:force majorRadius:majorRadius pointerId:(int)pointerId pointerCount:(int)pointerCount];
            break;
        default:
            break;
    }
}
- (BOOL)msgProc:(unsigned int)unMsgID arg1:(int)nArg1 arg2:(int)nArg2 arg3:(const char *)cArg3{
    return NO;
}

#pragma mark - getter
- (BEEffectBaseView *)effectBaseView {
    if (_effectBaseView) {
        return _effectBaseView;
    }
    
    _effectBaseView = [[BEEffectBaseView alloc] initWithButtomMargin:BEF_DESIGN_SIZE(BEF_BOARD_BOTTOM_BOTTOM_MARGIN + BEF_BOARD_CONTENT_HEIGHT + BEF_SWITCH_TAB_HEIGHT + BEF_BOARD_BOTTOM_HEIGHT)];
    _effectBaseView.delegate = self;
    [_effectBaseView updateShowCompare:self.effectConfig.showCompareButton];
    return _effectBaseView;
}

- (BEEffectDataManager *)dataManager {
    if (_dataManager == nil) {
        _dataManager = [[BEEffectDataManager alloc] initWithType:self.effectConfig.effectType];
    }
    return _dataManager;
}

- (NSArray *)popoverConfigs {
    if (_popoverConfigs) {
        return _popoverConfigs;
    }
    
    _popoverConfigs = @[
        [[BESingleSwitchConfig alloc] initWithTitle:@"default_effect" isOn:YES key:EFFECT_DEFAULT_KEY],
        [[BESingleSwitchConfig alloc] initWithTitle:@"profile" isOn:NO key:EFFECT_PERFORMANCE_KEY],
    ];
    return _popoverConfigs;
}

- (BEBubbleTipManager *)tipManager {
    if (_tipManager) {
        return _tipManager;
    }
    
    _tipManager = [[BEBubbleTipManager alloc] initWithContainer:self.view topMargin:100];
    return _tipManager;
}

- (BOOL)defaultEffectOn {
    if (self.effectConfig.isAutoTest) {
        return NO;
    }
    return _defaultEffectOn;
}

@end
