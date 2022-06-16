//
//  BEAutoTestManager.h
//  app
//
//  Created by qun on 2021/7/6.
//

#ifndef BEAutoTestManager_h
#define BEAutoTestManager_h

//#if BEF_AUTO_TEST

#import <Foundation/Foundation.h>
#import "BEFeatureConfig.h"

@interface BEAutoTestManager : NSObject

+ (BEFeatureConfig *)featureConfigFromDucoments;
+ (void)stopAutoTest;

@end

//#endif

#endif /* BEAutoTestManger_h */
