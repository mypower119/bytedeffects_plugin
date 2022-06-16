// Copyright (C) 2018 Beijing Bytedance Network Technology Co., Ltd.
#import "BEAppDelegate.h"
#import "BEMainVC.h"
//#import <Bugly/Bugly.h>
#import <UIKit/UIKit.h>

@interface BEAppDelegate ()

@end

@implementation BEAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    BEMainVC *vc = [BEMainVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
//    [Bugly startWithAppId:@"73d477ebbf"];

    return YES;
}

@end
