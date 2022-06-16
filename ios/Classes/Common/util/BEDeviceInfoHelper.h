// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BEDeviceInfoHelper : NSObject

+ (BOOL) isIPhoneXSeries;

+ (BOOL) isHigherThanIPhone6s;

+ (CGFloat)statusBarHeight;

+ (BOOL)isIpad;

@end
