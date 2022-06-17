#import "ByteplusEffectsPlugin.h"

@interface ByteplusEffectsPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
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

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"pickImage" isEqualToString:call.method]) {
    result(@"Image path");
    [_channel invokeMethod:@"CameraBack" arguments:@"Image path"];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

@end
