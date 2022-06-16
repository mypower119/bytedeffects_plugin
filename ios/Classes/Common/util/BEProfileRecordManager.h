//
//  BEProfileRecordManager.h
//  Common
//
//  Created by qun on 2021/6/7.
//

#ifndef BEProfileRecordManager_h
#define BEProfileRecordManager_h

#import <Foundation/Foundation.h>

@interface BEProfileRecordManager : NSObject

- (void)record;
- (double)frameTime;
- (int)frameCount;

@end

#endif /* BEProfileRecordManager_h */
