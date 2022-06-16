//
//  BEGLUtils.h
//  BytedEffects
//
//  Created by qun on 2021/4/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEGLUtils_h
#define BEGLUtils_h

#import <OpenGLES/EAGL.h>

@interface BEGLUtils : NSObject

+ (EAGLContext *)createContextWithDefaultAPI:(EAGLRenderingAPI)api;

+ (EAGLContext *)createContextWithDefaultAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup;

@end


#endif /* BEGLUtils_h */
