//
//  BEAlgorithmVC.m
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#import "BEAlgorithmVC.h"
#import "BEImageUtils.h"
#import "BEBaseBarView.h"
#import "BEAlgorithmView.h"
#import "BEAlgorithmUIFactory.h"
#import "BEAlgorithmTaskFactory.h"
#import "BEAlgorithmResourceHelper.h"
#import "UIViewController+BEAdd.h"
#import "BEDeviceInfoHelper.h"
#import "BEPreviewSizeManager.h"
#import "BEAlgorithmRender.h"
#import "BEBubbleTipManager.h"
#import "BEPopoverManager.h"
#import "BEVideoCapture.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "Common.h"

static NSString *const ALGORITHM_PERFORMANCE_KEY = @"algorithm_performance";

@interface BEAlgorithmVC () <BEBaseBarViewDelegate, BEAlgorithmViewDelegate, BEAlgorithmInfoProvider, BEPopoverManagerDelegate>

@property (nonatomic, assign) BOOL algorithmOn;

@property (nonatomic, strong) UIView *algorithmView;
@property (nonatomic, strong) BEBubbleTipManager *tipManager;
@property (nonatomic, strong) NSArray *popoverConfigs;

@property (nonatomic, strong) BEAlgorithmTask *algorithmTask;
@property (nonatomic, strong) id<BEAlgorithmUI> algorithmUI;
@property (nonatomic, strong) BEAlgorithmRender *algorithmRender;
@property (atomic, strong) NSMutableArray<BEAlgorithmUIRunnable> *algorithmRunnables;
@end

@implementation BEAlgorithmVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _algorithmOn = NO;
        _algorithmRunnables = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    self.algorithmConfig = (BEAlgorithmConfig *)self.configDict[ALGORITHM_CONFIG_KEY];
    if (self.algorithmConfig == nil) {
        NSLog(@"invalid algorithm config");
        return;
    }
    
    [super viewDidLoad];
    
    [self.view addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.baseView.showReset = NO;
    [self initView];
    
    if (self.algorithmConfig.showBoard) {
        [self showBottomView:self.algorithmView target:self.view];
    }
    
    NSInteger baseBarMode = self.algorithmConfig.topBarMode;
    if (self.videoSourceConfig.type != BEVideoSourceCamera) {
        baseBarMode &= ~BEBaseBarImagePicker;
        baseBarMode &= ~BEBaseBarSwitch;
    }
    [self.baseView showBar:baseBarMode];
}

- (void)initView {
    self.algorithmUI = [BEAlgorithmUIFactory create:self.algorithmConfig.algorithmKey];
    [self.algorithmUI initUI:self];
    
    if (self.algorithmUI.algorithmItem != nil) {
        NSMutableSet<BEAlgorithmKey *> *selectSet = [NSMutableSet set];
        for (BEAlgorithmKey *key in self.algorithmConfig.algorithmParams.allKeys) {
            NSObject *obj = self.algorithmConfig.algorithmParams[key];
            if ([obj isKindOfClass:[NSNumber class]] && [(NSNumber *)obj boolValue]) {
                [selectSet addObject:key];
            }
            
            [self algorithmOnEvent:key flag:[(NSNumber *)obj boolValue]];
        }
        [(BEAlgorithmView *)self.algorithmView setItem:self.algorithmUI.algorithmItem selectSet:selectSet];
    } else {
        self.algorithmOn = YES;
        id<BEAlgorithmUIGenerator> generator = self.algorithmUI.algorithmGenerator;
        self.algorithmView = generator.createView;
    }
}

#pragma mark - SDK，SDK 函数调用相关，重点代码
- (int)initSDK {
    int ret = BEF_RESULT_SUC;
    self.algorithmTask = [BEAlgorithmTaskFactory create:self.algorithmConfig.algorithmKey provider:[BEAlgorithmResourceHelper new] licenseProvider:[BELicenseHelper shareInstance]];
    ret = [self.algorithmTask initTask];
    if (ret != BEF_RESULT_SUC)
        return ret;
    
    self.algorithmRender = [[BEAlgorithmRender alloc] init];
    return ret;
}

- (void)processWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(int)rotation timeStamp:(double)timeStamp {
    //    {zh} 执行插入的 runnable        {en} Execute inserted runnable  
    if (self.algorithmRunnables.count > 0) {
        for (BEAlgorithmUIRunnable runnable in self.algorithmRunnables) {
            runnable();
        }
        [self.algorithmRunnables removeAllObjects];
    }
    
    BEPixelBufferInfo *pixelBufferInfo = [self.imageUtils getCVPixelBufferInfo:pixelBuffer];
    if (pixelBufferInfo.format != BE_BGRA) {
        pixelBuffer = [self.imageUtils transforCVPixelBufferToCVPixelBuffer:pixelBuffer outputFormat:BE_BGRA];
    }
    
    //    {zh} 如果传入图片有旋转，先进行旋转        {en} If the incoming picture has rotation, rotate first  
    if (rotation != 0) {
        pixelBuffer = [self.imageUtils rotateCVPixelBuffer:pixelBuffer rotation:rotation];
    }
    
    //    {zh} 将输入的 CVPixelBuffer 转换成纹理        {en} Convert input CVPixelBuffer to texture  
    BEPixelBufferGLTexture *texture = [self.imageUtils transforCVPixelBufferToTexture:pixelBuffer];
    
    if (self.algorithmOn) {
        //    {zh} 将输入的 CVPixelBuffer 转换成 buffer        {en} Convert the input CVPixelBuffer to a buffer  
        BEBuffer *buffer = [self.imageUtils transforCVPixelBufferToBuffer:pixelBuffer outputFormat:BE_BGRA];
        
        //    {zh} 设置通用参数        {en} Set general parameters  
        if (self.videoSourceConfig.type == BEVideoSourceCamera) {
            [self.algorithmTask setConfig:BEAlgorithmTask.ALGORITHM_FOV p:[NSNumber numberWithFloat:[(BEVideoCapture *)self.videoSource currentFOV]]];
        }
        //    {zh} 执行算法检测        {en} Execution algorithm detection  
        id result = [self.algorithmTask process:buffer.buffer width:buffer.width height:buffer.height stride:buffer.bytesPerRow format:[self pixelFormatWithFormat:buffer.format] rotation:[self getDeviceOrientation]];
        
        //    {zh} 绘制算法检测结果到目标纹理        {en} Draw algorithm detection result to target texture  
        if (result != nil) {
            [self.algorithmRender setRenderTargetTexture:texture.texture width:texture.width height:texture.height resizeRatio:1];
            [self.algorithmRender drawAlgorithmResult:result];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //    {zh} 更新 sizeManager，并将算法检测结果传递给 AlgorithmUI        {en} Update sizeManager and pass algorithm detection results to AlgorithmUI  
            [[BEPreviewSizeManager singletonInstance] updateViewWidth:self.view.frame.size.width viewHeight:self.view.frame.size.height previewWidth:texture.width previewHeight:texture.height fitCenter:self.videoSourceConfig.type != BEVideoSourceCamera];
            [self.algorithmUI onReceiveResult:result];
        });
    }
    
    //    {zh} 将最终纹理绘制到屏幕上        {en} Draw the final texture to the screen
    [self drawGLTextureOnScreen:texture rotation:0];
    
    if (rotation != 0) {
        CVPixelBufferRelease(pixelBuffer);
    }
}

- (void)destroySDK {
    [self.algorithmRender destroy];
    [self.algorithmTask destroyTask];
}

- (bef_ai_rotate_type)rotateTypeWithRotation:(int)rotation {
    rotation = rotation % 360;
    switch (rotation) {
        case 0:
            return BEF_AI_CLOCKWISE_ROTATE_0;
        case 90:
            return BEF_AI_CLOCKWISE_ROTATE_90;
        case 180:
            return BEF_AI_CLOCKWISE_ROTATE_180;
        case 270:
            return BEF_AI_CLOCKWISE_ROTATE_270;
    }
    return BEF_AI_CLOCKWISE_ROTATE_0;
}

- (bef_ai_pixel_format)pixelFormatWithFormat:(BEFormatType)format {
    switch (format) {
        case BE_RGBA:
            return BEF_AI_PIX_FMT_RGBA8888;
        case BE_BGRA:
            return BEF_AI_PIX_FMT_BGRA8888;
        default:
            break;
    }
    return BEF_AI_PIX_FMT_RGBA8888;
}

- (int)getDeviceOrientation {
    if (self.videoSourceConfig.type != BEVideoSourceCamera) {
        return 0;
    }
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return 0;

        case UIDeviceOrientationPortraitUpsideDown:
            return 180;

        case UIDeviceOrientationLandscapeLeft:
            return 270;

        case UIDeviceOrientationLandscapeRight:
            return 90;

        default:
            return 0;
    }
}

#pragma mark - BEAlgorithmButtonViewDelegate，底部算法按钮点击回调
- (void)algorithmButtonView:(BEAlgorithmButtonView *)view onItem:(BEAlgorithmItem *)item selected:(BOOL)selected {
    [self algorithmOnEvent:item.key flag:selected];
    
    if (selected) {
        [self.tipManager showBubble:NSLocalizedString(item.tipTitle, nil) desc:NSLocalizedString(item.tipDesc, nil) duration:2.0];
    }
}

- (void)algorithmOnEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    if ([key isEqual:self.algorithmConfig.algorithmKey]) {
        //    {zh} 当 key 为 task key 的时候，决定当前页面是否开启算法        {en} When the key is the task key, decide whether the current page opens the algorithm  
        self.algorithmOn = flag;
    }
    [self.algorithmUI onEvent:key flag:flag];
}

#pragma mark - BEAlgorithmInfoProvider，算法 UI 展示所需函数
- (void)showOrHideVC:(UIViewController *)vc show:(BOOL)show {
    if (show) {
        [self displayContentController:vc inView:self.view];
    } else {
        [self hideContentController:vc];
    }
}

- (CGSize)imageSize {
    return self.videoSource.videoSize;
}

- (int)imageRotation {
    //    {zh} 输入的 CVPixelBuffer 会被强制转正，所以此处直接传 0        {en} The input CVPixelBuffer will be forced to become a full member, so pass 0 directly here  
    return 0;
}

- (void)addAlgorithmUIRunnable:(BEAlgorithmUIRunnable)runnable {
    [self.algorithmRunnables addObject:runnable];
}

#pragma mark - BEBaseViewDelegate，通用按钮部分的回调，包括展开底部栏，上部按钮点击事件
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    [self showBottomView:self.algorithmView target:self.view];
}

- (void)baseView:(BEBaseBarView *)view didTapSetting:(UIView *)sender {
    [self showPopoverViewWithConfigs:self.popoverConfigs anchor:sender];
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.algorithmView.superview != nil) {
        [self hideBottomView:self.algorithmView];
    }
}

#pragma mark - BEPopoverManagerDelegate
- (void)popover:(BEPopoverManager *)manager configDidChange:(NSObject *)config key:(NSString *)key {
    if (key == ALGORITHM_PERFORMANCE_KEY) {
        BESingleSwitchConfig *cf = (BESingleSwitchConfig *)config;
        [self showProfile:cf.isOn];
    }
}

#pragma mark - BEBoardBottomViewDelegate，底部展开栏通用按钮回调
- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    [self hideBottomView:self.algorithmView];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    [self baseView:nil didTapRecord:nil];
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
- (UIView *)algorithmView {
    if (_algorithmView) {
        return _algorithmView;
    }
    
    BEAlgorithmView *algorithmView = [[BEAlgorithmView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT))];
    algorithmView.delegate = self;
    _algorithmView = algorithmView;
    return _algorithmView;
}

- (BEBubbleTipManager *)tipManager {
    if (_tipManager) {
        return _tipManager;
    }
    
    _tipManager = [[BEBubbleTipManager alloc] initWithContainer:self.view topMargin:100];
    return _tipManager;
}

- (NSArray *)popoverConfigs {
    if (_popoverConfigs) {
        return _popoverConfigs;
    }
    
    _popoverConfigs = @[
        [[BESingleSwitchConfig alloc] initWithTitle:@"profile" isOn:NO key:ALGORITHM_PERFORMANCE_KEY],
    ];
    return _popoverConfigs;
}

- (NSString *)viewControllerKey {
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass(self.class), self.algorithmConfig.type];
}


@end
