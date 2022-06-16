//
//  BEDeviceInfoHelper.m
//  BytedEffects
//
//  Created by Archie Zhou on 30/10/2019.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEDeviceInfoHelper.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@implementation BEDeviceInfoHelper

+ (BOOL) isIPhoneXSeries
{
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSArray *devicesX = [NSArray arrayWithObjects:@"iPhone10,3",@"iPhone10,6", @"iPhone11,8", @"iPhone11,2", @"iPhone11,4",
                         @"iPhone11,6", @"iPhone11,6", @"iPhone12,1", @"iPhone12,3", @"iPhone12,5", nil];
    
    for(int i = 0; i < devicesX.count - 1; i++)
    {
        if([phoneType  isEqualToString:devicesX[i]])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL) isHigherThanIPhone6s
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSArray *devicesLower6 = [NSArray arrayWithObjects:@"iPhone6,1",@"iPhone6,2", @"iPhone7,1", @"iPhone7,2", @"iPhone8,1",
                              @"iPhone8,2", nil];
    
    for(int i = 0; i < devicesLower6.count - 1; i++)
    {
        if([phoneType  isEqualToString:devicesLower6[i]])
        {
            return NO;
        }
    }
    
    return YES;
}

+ (CGFloat)statusBarHeight {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

+ (BOOL)isIpad

{
    NSString *deviceType = [UIDevice currentDevice].model;
    return [deviceType isEqualToString:@"iPad"];
}



@end
