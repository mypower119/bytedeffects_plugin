//
//  Effect.h
//  Effect
//
//  Created by qun on 2021/5/17.
//

#import <Foundation/Foundation.h>
#import "CommonSize.h"
#import "Core.h"

//! Project version number for Effect.
FOUNDATION_EXPORT double EffectVersionNumber;

//! Project version string for Effect.
FOUNDATION_EXPORT const unsigned char EffectVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Effect/PublicHeader.h>

#define BEBLOCK_INVOKE(block, ...) (block ? block(__VA_ARGS__) : 0)

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) btd_keywordify __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) btd_keywordify __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) btd_keywordify __typeof__(object) object = weak##_##object;
#else
#define strongify(object) btd_keywordify __typeof__(object) object = block##_##object;
#endif
#endif

#define BEColorWithARGBHex(hex) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:((hex&0xFF000000)>>24)/255.0]
#define BEColorWithRGBAHex(hex,alpha) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:alpha]
#define BEColorWithRGBHex(hex) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:1]

FOUNDATION_EXTERN NSString *const BEEffectAr_try_lipstick;
FOUNDATION_EXTERN NSString *const BEEffectAr_hair_color;


FOUNDATION_EXTERN NSString *const BEEffectButtonItemSelectNotification;
FOUNDATION_EXTERN NSString *const BEEffectNotificationUserInfoKey;
FOUNDATION_EXTERN NSString *const BEEffectFilterDidChangeNotification;
FOUNDATION_EXTERN NSString *const BEEffectFilterIntensityDidChangeNotification;
FOUNDATION_EXTERN NSString *const BEEffectUpdateComposerNodesNotification;
FOUNDATION_EXTERN NSString *const BEEffectUpdateComposerNodeIntensityNotification;
