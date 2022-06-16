//
//  BEStickerVC.m
//  Effect
//
//  Created by qun on 2021/5/25.
//

#import "BEStickerVC.h"
#import "BEStickerView.h"
#import "BEComposerNodeModel.h"
#import "BEDeviceInfoHelper.h"
#import "BEStickerItem.h"
#import "BEResourceManager.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "BELocalResource.h"
#import "BERemoteResource.h"
#import "TZImagePickerController.h"
#import "BEStickerTransformView.h"
#import "BEFaceVerifyAlgorithmTask.h"
#import "BEAlgorithmResourceHelper.h"
#import "BELicenseHelper.h"
#import "BEAlgorithmTask.h"
#import "BEAlgorithmTaskFactory.h"
#import "Common.h"

@interface BEStickerVC () <BEStickerViewDelegate, BEStickerFetchDelegate, BEResourceDelegate, TZImagePickerControllerDelegate, BEStickerTransformViewDelegate>

@property (nonatomic, strong) BEStickerView *stickerBoardView;
@property (nonatomic, strong) BEStickerFetch *stickerFetch;
@property (nonatomic, strong) BEStickerItem *loadingSticker;
@property (nonatomic, strong) NSMutableDictionary<BEBaseResource *, NSArray<NSIndexPath *> *> *resourceIndexDict;

@property (nonatomic, strong) BEResourceResult *resourceResult;
@property (nonatomic, strong) TZImagePickerController *imagePickerController;

@property (nonatomic, assign) BOOL transformBool;
@property (nonatomic, assign) BOOL msgcapBool;

@property (nonatomic, strong) BEStickerTransformView *transformView;
@property (nonatomic, strong) NSMutableSet<BEEffectItem *> *selectNodes;

@end

@implementation BEStickerVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stickerFetch = [BEStickerFetch new];
        _stickerFetch.delegate = self;
        _selectNodes = [NSMutableSet set];
        _resourceIndexDict = [NSMutableDictionary dictionary];
    }
    return self;
}
#pragma mark - public
- (void)resetToDefaultEffect:(NSArray<BEEffectItem *> *)items {
    [super resetToDefaultEffect:items];

    [self.selectNodes removeAllObjects];
    [self.selectNodes addObjectsFromArray:items];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transformBool = NO;
    self.msgcapBool = NO;
//    [self.stickerBoardView setGroups:[self stickerPageWithLocalResource:@[
//        @"test", @"./manhuanansheng",
//    ]].tabs];
    [_stickerFetch fetchPageWithType:self.effectConfig.stickerConfig.type];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.loadingSticker = nil;
    [self.resourceIndexDict removeAllObjects];
    [BEResourceManager.sInstance clearLoadingResource];
//    [BEResourceManager.sInstance clearCache];
}

- (void)dealloc {
    [self.transformView removeFromSuperview];
}

#pragma mark - BEStickerFetchDelegate
- (void)sitkcerFetch:(BEStickerFetch *)fetch didFetchSticker:(BEStickerPage *)stickerPage fromCache:(BOOL)fromCache {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stickerBoardView setGroups:stickerPage.tabs];
    });
}

- (void)sitkcerFetch:(BEStickerFetch *)fetch didFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.domain == BEResourceDomain && error.code == BEResourceErrorCodeNetworkUnavailable) {
            [self.view makeToast:NSLocalizedString(@"network_needed", nil)];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        }
    });
}

#pragma mark - BEResourceDelegate
- (void)resourceDidStart:(BEBaseResource *)resource {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateResourceUI:resource];
    });
}

- (void)resource:(BEBaseResource *)resource didUpdateProgress:(NSProgress *)progress {
    [self updateResourceUI:resource];
}

- (void)resource:(BEBaseResource *)resource didFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([NSURLErrorDomain isEqualToString:error.domain] && error.code == NSURLErrorCancelled) {
            // 下载任务被取消，只更新 UI，不报错
            [self updateResourceUI:resource];
        } else {
            if (error.domain == BEResourceDomain && error.code == BEResourceErrorCodeNetworkUnavailable) {
                [self.view makeToast:NSLocalizedString(@"network_needed", nil)];
            } else {
                [self.view makeToast:[error localizedDescription]];
            }
            [self updateResourceUI:resource];
        }
        [self.resourceIndexDict removeObjectForKey:resource];
    });
}

- (void)resource:(BEBaseResource *)resource didSuccess:(BEResourceResult *)resourceResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 只有最后选择的贴纸，才会被设置给 SDK
        if (self.loadingSticker.resource == resource) {
            self.resourceResult = resourceResult;
            [self.manager setStickerAbsolutePath:resourceResult.path];
            [self didSelectItem:self.loadingSticker];
            self.loadingSticker = nil;
        }
        
        // 如果这是从远程新下载的资源，则需要更新资源列表，刷新本地资源状态
        if ([resourceResult isKindOfClass:[BERemoteResourceResult class]] && ![(BERemoteResourceResult *)resourceResult isFromCache]) {
            [self updateResourceUI:resource];
        }
        [self updateResourceUI:resource];
        [self.resourceIndexDict removeObjectForKey:resource];
    });
}

- (void)updateResourceUI:(BEBaseResource *)resource {
    NSArray<NSIndexPath *> *indexArr = [self.resourceIndexDict objectForKey:resource];
    assert(indexArr == nil || indexArr.count == 2);
    if (indexArr) {
        [self.stickerBoardView refreshTabIndex:indexArr[0] withTabContentIndex:indexArr[1]];
    }
}

#pragma mark - BEStickerViewDelegate
- (BOOL)tabPickerView:(BETabStickerPickerView *)pickerView willSelectItem:(BEStickerItem *)item atTabIndex:(NSIndexPath *)tabIndex withContentIndex:(NSIndexPath *)contentIndex {
    if (self.transformBool == YES) {
        BEBuffer *buffer = [self.imageUtils transforUIImageToBEBuffer:[UIImage imageNamed:@""]];
        [self.manager setRenderCacheTexture:@"pixelLoopInput" buffer:buffer];
    }
    if (item.resource && [item.resource isKindOfClass:[BERemoteResource class]]) {
        if ([self.resourceIndexDict allKeys].count != 0) {
            [self.resourceIndexDict removeObjectForKey:self.loadingSticker.resource];
            self.loadingSticker = nil;
        }
        _loadingSticker = item;
        [self.resourceIndexDict setObject:@[tabIndex, contentIndex] forKey:item.resource];
        [BEResourceManager.sInstance asyncGetResource:item.resource delegate:self];
        return NO;
    }
    
    NSString *stickerPath = @"";
    if (item.resource) {
        NSError *error = nil;
        BEResourceResult *result = [BEResourceManager.sInstance syncGetResource:item.resource error:&error];
        if (error) {
            NSLog(@"get resource fail: %@", error.localizedDescription);
        } else {
            stickerPath = result.path;
        }
    }
    [self.manager setStickerPath:stickerPath];
    
    [self didSelectItem:item withTabIndex:tabIndex tabContentIndex:contentIndex];
    return YES;
}

- (void)didSelectItem:(BEStickerItem *)item {
    NSArray<NSIndexPath *> *indexArr = [self.resourceIndexDict objectForKey:item.resource];
    assert(indexArr == nil || indexArr.count == 2);
    if (indexArr) {
        [self didSelectItem:item withTabIndex:indexArr[0] tabContentIndex:indexArr[1]];
    } else {
        NSLog(@"could not found index of item");
        [self didSelectItem:item withTabIndex:[NSIndexPath indexPathForRow:0 inSection:0] tabContentIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}
- (void)didSelectItem:(BEStickerItem *)item withTabIndex:(NSIndexPath *)tabIndex tabContentIndex:(NSIndexPath *)contentIndex {
    [self.stickerBoardView setSelectTabIndex:tabIndex withTabContentIndex:contentIndex];
    [self.tipManager showBubble:item.title desc:nil duration:2];
    if ([item.type containsString:@"msgcap"]) {
        self.msgcapBool = YES;
        [self.effectBaseView updateShowCompare:NO];
    } else {
        self.msgcapBool = NO;
        [self.effectBaseView updateShowCompare:YES];
    }
    if ([item.type containsString:@"hideboard"]) {
        [self hideBottomView:self.stickerBoardView showBoard:YES];
    }
    if ([item.key isEqualToString:@"pixelLoopInput"]) {
        self.transformBool = YES;
        self.transformView.hidden = NO;
    }
    else {
        self.transformBool = NO;
        self.transformView.hidden = YES;
    }
    if (item.tip != nil && ![item.tip isEqualToString:@""]) {
        [self.view hideToast];
        CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        toastStyle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        toastStyle.cornerRadius = 4;
        toastStyle.messageFont = [UIFont systemFontOfSize:16];
        toastStyle.verticalPadding = 16;
        toastStyle.horizontalPadding = 16;
        [self.view makeToast:item.tip
                    duration:2
                    position:CSToastPositionCenter
                       style:toastStyle];
    }
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    if (self.transformView.hidden == NO) {
        [self.transformView showStickerTransformView];
    }
    [self showBottomView:self.stickerBoardView target:self.view];
}
- (void)baseView:(BEBaseBarView *)view didTapReset:(UIView *)sender {
    [self.resourceIndexDict removeAllObjects];
    self.loadingSticker = nil;
    [self.manager setStickerPath:@""];
    if (self.transformView.hidden == NO) {
        self.transformView.hidden = YES;
        [self.transformView showStickerTransformView];
    }
    
    [self.stickerBoardView setSelectTabIndex:[NSIndexPath indexPathForRow:0 inSection:0] withTabContentIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)baseView:(BEBaseBarView *)view didTapRecord:(UIView *)sender {
    if (self.msgcapBool == YES) {
        [self.manager sendCaptureMessage];
    }
    else {
        [super baseView:nil didTapRecord:nil];
    }
}

//- (void)baseView:(BEBaseBarView *)view didTapBack:(UIView *)sender {
//    BEBuffer *buffer = [self.imageUtils transforUIImageToBEBuffer:[UIImage imageNamed:@""]];
//    [self.manager setRenderCacheTexture:@"pixelLoopInput" buffer:buffer];
////        [self showBottomView:self.stickerBoardView target:self.view];
////        // 只有最后选择的贴纸，才会被设置给 SDK
////        [self.baseView showBar:BEBaseBarAll];
////        [self.baseView hideBoard];
////        [self.effectBaseView updateShowCompare:YES];
//    [self.manager setStickerAbsolutePath:@""];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.manager setStickerAbsolutePath:self.resourceResult.path];
//        [self didSelectItem:self.loadingSticker];
//    });
//}
- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.stickerBoardView.superview != nil) {
        if (self.transformView.hidden == NO) {
            [self.transformView hideStickerTransformView];
        }
        [self hideBottomView:self.stickerBoardView showBoard:YES];
    }
}

#pragma mark - BEBoardBottomDelegate
- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    if (self.transformView.hidden == NO) {
        [self.transformView hideStickerTransformView];
    }
    [self hideBottomView:self.stickerBoardView showBoard:YES];
}
- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    if (self.msgcapBool == YES) {
        [self.manager sendCaptureMessage];
    }
    else {
        [self baseView:nil didTapRecord:nil];
    }
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapReset:(UIView *)sender {
    [super boardBottomView:view didTapReset:sender];
    [self.resourceIndexDict removeAllObjects];
    self.loadingSticker = nil;
    [self.manager setStickerPath:@""];
    if (self.transformView.hidden == NO) {
        self.transformView.hidden = YES;
    }
    [self.stickerBoardView setSelectTabIndex:[NSIndexPath indexPathForRow:0 inSection:0] withTabContentIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
}
#pragma mark - BEStickerTransformViewDelegate
- (void)stickerTransformView:(NSString *)img{
    if ([img isEqualToString:@"addPhoto"]) {
        TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        vc.autoDismiss = YES;
        vc.allowPickingVideo = NO;
        vc.allowPickingGif = NO;
        vc.allowPickingOriginalPhoto = NO;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        self.imagePickerController = vc;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        if ([self isphoto:[UIImage imageNamed:img]]) {
            [self resetRenderCacheWithImage:[UIImage imageNamed:img]];
        }
    }
}
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.imagePickerController == picker) {
        if (photos.count == 1) {
            if (isSelectOriginalPhoto) {
                [[TZImageManager manager] getOriginalPhotoWithAsset:assets[0] completion:^(UIImage *photo, NSDictionary *info) {
                    if ([[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue]) return;
                    if ([self isphoto:photo]) {
                        [self resetRenderCacheWithImage:photo];
                    }
                }];
            } else {
                if ([self isphoto:photos[0]]) {
                    [self resetRenderCacheWithImage:photos[0]];
                }
            }
        }
        return;
    }
    
    if ([super respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [super imagePickerController:picker didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto];
    }
}
- (BOOL)isphoto:(UIImage *)image{

    int width = (int)CGImageGetWidth(image.CGImage);
    int height = (int)CGImageGetHeight(image.CGImage);
    int bytesPerRow = 4 * width;
    unsigned char *buffer = malloc(bytesPerRow * height);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(buffer, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGContextRelease(context);
    
    BEAlgorithmKey *algorithmKey = [BEAlgorithmKey create:@"face" isTask:YES];
        int ret = BEF_RESULT_SUC;
        BEAlgorithmTask *algorithmTask = [BEAlgorithmTaskFactory create:algorithmKey provider:[BEAlgorithmResourceHelper new] licenseProvider:[BELicenseHelper shareInstance]];
        ret = [algorithmTask initTask];
        if (ret != BEF_RESULT_SUC) {
            return NO;
        }
        BEFaceAlgorithmTask *task = (BEFaceAlgorithmTask *)algorithmTask;
        BEFaceAlgorithmResult *faceRet = nil;
        for (int i=0; i<4; i++) {
            faceRet = [task process:(unsigned char *)buffer width:(int)width height:(int)height stride:bytesPerRow format:BEF_AI_PIX_FMT_BGRA8888 rotation:BEF_AI_CLOCKWISE_ROTATE_0];
            if (faceRet.faceInfo->face_count>0) {
                break;
            }
        }
        free(buffer);
        if (faceRet.faceInfo->face_count <= 0) {
            [self.view makeToast:NSLocalizedString(@"no_face_detected", nil)
                        duration:2
                        position:CSToastPositionCenter];
            [algorithmTask destroyTask];
            task = nil;
            return NO;
        }else  if (faceRet.faceInfo->face_count > 1) {
            [self.view makeToast:NSLocalizedString(@"face_more_than_one", nil)
                        duration:2
                        position:CSToastPositionCenter];
            [algorithmTask destroyTask];
            task = nil;
            return NO;
        }
        [algorithmTask destroyTask];
        task = nil;
        return YES;
}
- (void)resetRenderCacheWithImage:(UIImage *)image {
    BEBuffer *buffer = [self.imageUtils transforUIImageToBEBuffer:image];
    [self.manager setRenderCacheTexture:@"pixelLoopInput" buffer:buffer];
    if (self.transformView.hidden == NO) {
        [self.transformView hideStickerTransformView];
    }
    [self hideBottomView:self.stickerBoardView showBoard:YES];
}

#pragma mark - RenderMsgDelegate
- (BOOL)msgProc:(unsigned int)unMsgID arg1:(int)nArg1 arg2:(int)nArg2 arg3:(const char *)cArg3 {
    BELog(@"message received, type: %d, arg: %d, %d, %s", unMsgID, nArg1, nArg2, cArg3);
    if(unMsgID == 0x00000030)
    {
        if (self.stickerBoardView.superview != nil) {
            [self hideBottomView:self.stickerBoardView showBoard:YES];
        }else
        {
            [self showBottomView:self.stickerBoardView target:self.view];
        }
        return YES;
    }
    else if(unMsgID == 0x45 && cArg3 != NULL)
    {
        UIImage* img = [self.manager getCapturedImageWithKey:cArg3];
        if (img ) {
            [self saveImageToLocal:img];
        }
        return YES;
    }
    
    return NO;
}


#pragma mark - getter
- (BEStickerView *)stickerBoardView {
    if (_stickerBoardView) {
        return _stickerBoardView;
    }
    
    _stickerBoardView = [[BEStickerView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT))];
    _stickerBoardView.delegate = self;
    return _stickerBoardView;
}

- (BEStickerPage *)stickerPageWithLocalResource:(NSArray *)info {
    assert(info.count % 2 == 0);
    
    BEStickerItem *closeItem = [BEStickerItem new];
    closeItem.titles = @{
      @"zh": @"close",
    };
    closeItem.icon = @"ic_close_icon";
    
    NSMutableArray<BEStickerItem *> *items = [NSMutableArray array];
    [items addObject:closeItem];
    
    for (int i = 0; i < info.count; i += 2) {
        NSString *name = info[i];
        NSString *path = info[i+1];
        
        BEStickerItem *item = [BEStickerItem new];
        item.titles = @{
            @"zh": name
        };
        item.icon = @"ic_close_icon";
        item.resource = [BELocalResource initWithPath:path];
        [items addObject:item];
    }
    
    BEStickerGroup *testGroup = [BEStickerGroup new];
    testGroup.titles = @{
        @"zh": @"Test Sticker"
    };
    testGroup.items = items;
    
    BEStickerPage *page = [BEStickerPage new];
    page.tabs = @[testGroup];
    return page;
}

- (BEStickerTransformView *)transformView{
    if (_transformView == nil) {
        _transformView = [[BEStickerTransformView alloc] initWithFrame:CGRectMake(6, [UIScreen mainScreen].bounds.size.height-BEF_FACE_CLUSTER_BOARD_HEIGHT-64, [UIScreen mainScreen].bounds.size.width-12, 64)];
        _transformView.delegate = self;
        _transformView.hidden = YES;
        [_transformView initStickerTransformView];
        [self.view addSubview:_transformView];
        
    }
    return _transformView;
}

@end
