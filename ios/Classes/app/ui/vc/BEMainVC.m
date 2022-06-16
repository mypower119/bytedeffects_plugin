//
//  BEMainVC.m
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//
#import "BEMainVC.h"
#import "BEMainView.h"
#import "BEMainDataManager.h"
#import "BEEffectVC.h"
#import "BEBeautyEffectVC.h"
#import "BEStickerVC.h"
#import "BEStyleMakeupVC.h"
#import "BEMattingStickerVC.h"
#import "BEBackgroundBlurVC.h"
#import "BEAlgorithmVC.h"
#import "BEQRScanVC.h"
#import "BESearchVC.h"
#import "BENetworkUtil.h"
#if BEF_AUTO_TEST
#import "BEAutoTestManager.h"
#endif
#import "UIView+Toast.h"
#if BEF_USE_CK
#import <CreationKit/CreationKit.h>
#endif
#import "BEEffectResourceHelper.h"
#import "BELicenseHelper.h"
#import "bef_effect_ai_api.h"
#import "BELocaleManager.h"

@interface BEMainVC () <BEMainDelegate>

@property (nonatomic, strong) BEMainView *vMain;

@end

@implementation BEMainVC

- (void)dealloc
{
#if BEF_AUTO_TEST
    [BEAutoTestManager stopAutoTest];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.vMain;
    [self.vMain setFeatureItems:[[BEMainDataManager new] getFeatureItems:@"custom_config"]];
    
#if BEF_AUTO_TEST
    BEFeatureConfig *config = [BEAutoTestManager featureConfigFromDucoments];
    if (config != nil) {
        [self startViewController:config];
    } else {
        NSLog(@"extract BEFeatureConfig from documents fails, please recheck");
    }
#endif
    
    if (![[BENetworkUtil sInstance] isNetworkAvailable]) {
        NSLog(@"network is not available");
    }
    
    [self checkLicenseReady];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)checkLicenseReady {
    if ([BELicenseHelper shareInstance].licenseMode != ONLINE_LICENSE) {
        return;
    }
    
    UIAlertView* waittingAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"request_license_progress", nil)
                                               message: @""
                                              delegate: nil
                                     cancelButtonTitle: nil
                                     otherButtonTitles: nil];
      
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
    [waittingAlert addSubview:activityView];
    [activityView startAnimating];
      
    dispatch_queue_t licenseQueue = dispatch_queue_create("check license task", NULL);
    dispatch_async(licenseQueue, ^{
        
        if (![[BELicenseHelper shareInstance] checkLicenseOK:[BELicenseHelper shareInstance].licensePath])
            [[BELicenseHelper shareInstance] updateLicensePath];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (waittingAlert != nil) {
                [waittingAlert dismissWithClickedButtonIndex:0 animated:YES];
            }
            if ([BELicenseHelper shareInstance].errorCode != 0) {
                NSString* log = [BELocaleManager convertLocaleLog:[BELicenseHelper shareInstance].errorMsg];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"request_license_fail", nil) message:log delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
                [alertView show];
            }
                
        });
    });
    
    [waittingAlert show];
}

#pragma mark - BEMainDelegate
- (void)startViewController:(BEFeatureConfig *)config {
    BEEffectConfig *effectConfig = config.effectConfig;
    BEAlgorithmConfig *algorithmConfig = config.algorithmConfig;
    BEVideoSourceConfig *sourceConfig = config.videoSourceConfig;
    BELensConfig *lensConfig = config.lensConfig;
    
    if (sourceConfig == nil) {
        sourceConfig = [BEVideoSourceConfig new];
        sourceConfig.type = BEVideoSourceCamera;
    }
    
    if (algorithmConfig == nil) {
        NSString *type = @"faceCluster";
        algorithmConfig = [BEAlgorithmConfig new];
        algorithmConfig.type = type;
        algorithmConfig.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(YES), type, nil];
    }
    
    if (effectConfig == nil) {
        effectConfig = [BEEffectConfig new];
    }
    
    if (config.viewControllerClass == nil) {
        [self.view makeToast:@"viewControllerClass must not be nil"];
        return;
    }
    
    NSDictionary<NSString *, NSObject *> *configDict =
        [NSDictionary dictionaryWithObjectsAndKeys:
         sourceConfig, VIDEO_SOURCE_CONFIG_KEY,
         effectConfig, EFFECT_CONFIG_KEY,
         algorithmConfig, ALGORITHM_CONFIG_KEY,
         lensConfig, LENS_CONFIG_KEY, nil];
    
    UIViewController *vc = [[config.viewControllerClass alloc] init];
    if ([vc isKindOfClass:[BEBaseVC class]]) {
        [(BEBaseVC *)vc setConfigDict:configDict];
    }
    
#if BEF_USE_CK
    if ([vc isKindOfClass:NSClassFromString(@"VEHomeViewController")]) {
        [[VESDKHelper shareManager] initConfigs];
    }
#endif

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickItem:(BEFeatureItem *)item {
    NSLog(@"did click item: %@", item);
    
    BEFeatureConfig *config = item.config;
    [self startViewController:config];
}

#pragma mark - BETopBarViewDelegate
- (void)topBarView:(BETopBarView *)view didTapSearch:(UIView *)sender {
//    BESearchVC *vc = [BESearchVC new];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)topBarView:(BETopBarView *)view didTapQRScan:(UIView *)sender {
    BEFeatureConfig *config = [BEFeatureConfig new];
    BEVideoSourceConfig *videoSourceConfig = [BEVideoSourceConfig new];
    videoSourceConfig.type = BEVideoSourceCamera;
    videoSourceConfig.devicePosition = AVCaptureDevicePositionBack;
    config.videoSourceConfig = videoSourceConfig;
    config.viewControllerClass = [BEQRScanVC class];
    [self startViewController:config];
}

#pragma mark - getter
- (BEMainView *)vMain {
    if (_vMain == nil) {
        _vMain = [[BEMainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _vMain.delegate = self;
    }
    return _vMain;
}

@end
