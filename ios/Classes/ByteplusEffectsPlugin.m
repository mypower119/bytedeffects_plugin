#import "ByteplusEffectsPlugin.h"
#import "app/BEAppDelegate.h"
#import "Effect.h"
#import "BEFeatureConfig.h"
#import "BEBaseBarVC.h"
#import "BEFeatureItem.h"
#import "BEMainView.h"
#import "BELicenseHelper.h"
#import "BELocaleManager.h"
#import "BEMainDataManager.h"
#import "BEStickerVC.h"
#import "BEBeautyEffectVC.h"
#import "BEMainVC.h"
#import "BEVideoSourceProvider.h"

@interface ByteplusEffectsPlugin () <BEVideoSourceDelegate>
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navigationController;
@end

@implementation ByteplusEffectsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"byteplus_effects_plugin"
            binaryMessenger:[registrar messenger]];
  ByteplusEffectsPlugin* instance = [[ByteplusEffectsPlugin alloc] init];
  instance.channel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

- (void) checkLicenseReady {
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

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"pickImage" isEqualToString:call.method]) {
    result(@"Image path");
      
    [self handlePickImage:call];
      
//    BEMainVC *vc2 = [BEMainVC new];
//    [_navigationController pushViewController:vc2 animated:YES];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)handlePickImage:(FlutterMethodCall*)call {
    NSDictionary *value = [call arguments];
    NSString *featureType = value[@"feature_type"];
    
    BEFeatureItem *itemFeatured = [[BEMainDataManager new] featureItemWithName: featureType];
    [self didClickItem:(BEFeatureItem *)itemFeatured];
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
        NSLog(@"viewControllerClass must not be nil");
//        [self.view makeToast:@"viewControllerClass must not be nil"];
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
        [(BEBaseVC *)vc setDelegate:self];
        
    }
    
#if BEF_USE_CK
    if ([vc isKindOfClass:NSClassFromString(@"VEHomeViewController")]) {
        [[VESDKHelper shareManager] initConfigs];
    }
#endif
    
    [_navigationController pushViewController:vc animated:YES];
}

- (void) cameraBack:(NSString*) imagePath
{
    [_channel invokeMethod:@"CameraBack" arguments:imagePath];
}

- (void)didClickItem:(BEFeatureItem *)item {
    NSLog(@"did click item: %@", item);
    
    BEFeatureConfig *config = item.config;
    [self startViewController:config];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *scheme = [url scheme];
    NSString *host = [url host];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = application.windows.firstObject;
    
    FlutterViewController *controller = _window.rootViewController;
    _navigationController = [[[UINavigationController alloc] init]initWithRootViewController:controller];
    [_navigationController setNavigationBarHidden:YES animated:NO];
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];
    
    [self checkLicenseReady];
    
    return YES;
}

@end
