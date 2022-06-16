//
//  BEMainDataManager.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEMainDataManager_h
#define BEMainDataManager_h

#import <Foundation/Foundation.h>
#import "BEFeatureItem.h"

//   {zh} / 首页 dataManager，主要用于主页功能项列表的提供     {en} /Home dataManager, mainly used to provide a list of home page feature items 
@interface BEMainDataManager : NSObject

- (NSArray<BEFeatureGroup *> *)getFeatureItems:(NSString *)name;
- (BEFeatureItem *)featureItemWithName:(NSString *)feature;

@end

#endif /* BEMainDataManager_h */
