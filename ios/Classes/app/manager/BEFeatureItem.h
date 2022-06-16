//
//  BEFeatureItem.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEFeatureItem_h
#define BEFeatureItem_h

#import "BEFeatureConfig.h"

//   {zh} / 首页功能项，主要定义了每一个小项的 UI 和对应的配置     {en} /Home function items, mainly define the UI and corresponding configuration of each item 
@interface BEFeatureItem : NSObject

+ (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon config:(BEFeatureConfig *)config;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) BEFeatureConfig *config;

@end

@interface BEFeatureGroup : BEFeatureItem

+ (instancetype)initWithTitle:(NSString *)title;
- (void) addChild:(BEFeatureItem *)item;

@property (nonatomic, strong) NSMutableArray<BEFeatureItem *> *children;

@end

#endif /* BEFeatureItem_h */
