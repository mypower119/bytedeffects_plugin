//
//  BEAvatarManager.h
//  Core
//
//  Created by qun on 2021/5/17.
//

#ifndef BEAvatarManager_h
#define BEAvatarManager_h

#import <Foundation/Foundation.h>
#import "bef_effect_ai_api.h"

@protocol BEAvatarResourceProvider <NSObject>

- (const char *)licensePath;

@end

@interface BEAvatarManager : NSObject

- (instancetype)initWithProvider:(id<BEAvatarResourceProvider>)provider;

- (int)initTask;

- (int)process:(int)texture width:(int)width height:(int)height rotation:(bef_ai_rotate_type)rotation timeStamp:(double)timeStamp;

- (int)destroyTask;

- (void)setAvatar:(NSString *)avatarPath;

- (BOOL)sendMsg:(unsigned int)msgID arg1:(long)arg1 arg2:(long)arg2 arg3:(const char *)arg3;

@end

#endif /* BEAvatarManager_h */
