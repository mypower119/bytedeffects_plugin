//
//  BEQRScanVC.m
//  Effect
//
//  Created by qun on 2021/6/3.
//

#import "BEQRScanVC.h"
#import "BEQRScanView.h"
#import "BEEffectManager.h"
#import "BEEffectResourceHelper.h"
#import "BEVideoCapture.h"
#import "BEQRScanResourceDownloadTask.h"
#import "UIView+Toast.h"

@interface BEQRScanVC () <BEQRScanViewDelegate, BEVideoMetadataDelegate, BEQRScanResourceDownloadDelegate>

@property (nonatomic, strong) BEQRScanView *scanView;
@property (nonatomic, strong) BEVideoCapture *videoCapture;
@property (nonatomic, strong) BEQRScanResourceDownloadTask *resourceDownloadTask;
@property (nonatomic, assign) BOOL startScan;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIAlertController *acVersionCheck;
@property (nonatomic, assign) BEQRScanResourceType currentResourceType;

@end

@implementation BEQRScanVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _startScan = YES;
        _resourceDownloadTask = [BEQRScanResourceDownloadTask new];
        _resourceDownloadTask.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  {zh} 隐藏一些无关 UI  {en} Hide some irrelevant UI
    self.effectBaseView.hidden = YES;
    [self.baseView hideBoard];
    [self.baseView showBar:0];
    [self.baseView showProfile:NO];
    
    [self.view addSubview:self.scanView];
    [self.scanView hideQRView:NO];
    
    self.videoCapture.metadelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - BEVideoMetadataDelegate
- (void)videoCapture:(BEVideoCapture *)camera didOutputQRCodeMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects {
    if (metadataObjects.count <= 0) {
        return;
    }
    
    NSData *info = [[metadataObjects.firstObject stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:info options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"json parser failed: %@", error);
        return;
    }
    
    if (self.startScan) {
        self.startScan = NO;
    } else {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.resourceDownloadTask.ignoreVersionRequire = NO;
        [self.resourceDownloadTask downloadResourceWithInfo:dict];
    });
}

#pragma mark - BEStickerDownloadDelegate
- (void)resourceDownloadTaskDidStart {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self presentViewController:self.alertController animated:YES completion:nil];
    });
}

- (void)resourceDownloadTask:(BEQRScanResourceDownloadTask *)task downloadFail:(NSError *)error {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
        if (error.code == BEQRScanResourceErrorCodeVersionNotMatch) {
            [self presentViewController:self.acVersionCheck animated:YES completion:nil];
            return;
        }
        
        self.startScan = YES;
        NSString *toast = error.localizedDescription;
        if (toast == nil) {
            toast = @"download resource fail";
        }
        
        [self.view makeToast:toast
                    duration:[CSToastManager defaultDuration]
                    position:[CSToastManager defaultPosition]];
    });
}

- (void)resourceDownloadTask:(BEQRScanResourceDownloadTask *)task downloadSucess:(NSString *)filePath resourceType:(BEQRScanResourceType)resourceType {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.scanView hideQRView:YES];
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
        
        self.currentResourceType = resourceType;
        if (resourceType == BEQRScanResourceTypeSticker) {
            [self.manager setStickerAbsolutePath:filePath];
        } else if (resourceType == BEQRScanResourceTypeFilter) {
            [self.manager setFilterAbsolutePath:filePath];
            CGFloat defaultIntensityProgress = 0.8f;
            [self.manager setFilterIntensity:defaultIntensityProgress];
            [self.scanView hideSliderView:NO defaultProgress:defaultIntensityProgress];
        }
        self.videoCapture.metadataRect = CGRectZero;
        self.videoCapture.metadataType = AVMetadataObjectTypeFace;
        self.videoCapture.devicePosition = AVCaptureDevicePositionFront;
    });
}

- (void)resourceDownloadTask:(BEQRScanResourceDownloadTask *)task progressDidChanged:(float)progress {
    progress = progress * 100;
    self.alertController.message = [[NSString stringWithFormat:@"%.0f", progress] stringByAppendingString:@"%"];
}

#pragma mark - BEQRScanViewDelegate
- (void)qrScanView:(BEQRScanView *)view didTapBack:(UIView *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)progressDidChange:(BETextSliderView *)sender progress:(CGFloat)progress {
    if (self.currentResourceType == BEQRScanResourceTypeFilter) {
        [self.manager setFilterIntensity:progress];
    }
}

#pragma mark - getter
- (BEQRScanView *)scanView {
    if (_scanView) {
        return _scanView;
    }
    
    _scanView = [[BEQRScanView alloc] initWithFrame:self.view.frame];
    _scanView.delegate = self;
    return _scanView;
}

- (BEVideoCapture *)videoCapture {
    if (_videoCapture) {
        return _videoCapture;
    }
    
    if ([self.videoSource isKindOfClass:[BEVideoCapture class]]) {
        _videoCapture = (BEVideoCapture *)self.videoSource;
    }
    
    return _videoCapture;
}

- (UIAlertController *)alertController {
    if (_alertController) {
        return _alertController;
    }
    
    _alertController = [UIAlertController
                        alertControllerWithTitle:NSLocalizedString(@"resource_download_progress", nil)
                        message:@""
                        preferredStyle:UIAlertControllerStyleAlert];
    return _alertController;
}

- (UIAlertController *)acVersionCheck {
    if (_acVersionCheck) {
        return _acVersionCheck;
    }
    
    _acVersionCheck = [UIAlertController
                       alertControllerWithTitle:NSLocalizedString(@"resource_version_not_match", nil)
                       message:@""
                       preferredStyle:UIAlertControllerStyleAlert];
    [_acVersionCheck addAction:[UIAlertAction
                                actionWithTitle:NSLocalizedString(@"confirm", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
        self.resourceDownloadTask.ignoreVersionRequire = YES;
        [self.resourceDownloadTask resume];
    }]];
    [_acVersionCheck addAction:[UIAlertAction
                                actionWithTitle:NSLocalizedString(@"cancel", nil)
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * _Nonnull action) {
        [self qrScanView:nil didTapBack:nil];
    }]];
    return _acVersionCheck;
}

@end
