//
//  BEFeatureConfig.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEFeatureConfig_h
#define BEFeatureConfig_h

#import <Foundation/Foundation.h>
#import "BEEffectConfig.h"
#import "BEAlgorithmConfig.h"
#import "BEVideoSourceConfig.h"
#import "BELensConfig.h"

//   {zh} / 首页功能项配置，定义了一个按钮点击之后的事件，     {en} /Home function item configuration, defines the event after a button is clicked, 
//   {zh} / 在这里定义了一些诸如特效配置、算法配置、启动的 ViewController 等信息     {en} /Some information such as effect configuration, algorithm configuration, starting ViewController is defined here 
@interface BEFeatureConfig : NSObject

// {zh} / 视频源配置 {en} /Video source configuration
@property (nonatomic, strong) BEVideoSourceConfig *videoSourceConfig;

// {zh} / 特效功能配置 {en} /Effect function configuration
@property (nonatomic, strong) BEEffectConfig *effectConfig;

// {zh} / 算法功能配置 {en} /Algorithm function configuration
@property (nonatomic, strong) BEAlgorithmConfig *algorithmConfig;

// {zh} / 画质功能配置 {en} /Image quality function configuration
@property (nonatomic, strong) BELensConfig *lensConfig;

// {zh} / 待启动的 ViewController {en} /ViewController to be started
@property (nonatomic, strong) Class viewControllerClass;

+ (BEFeatureConfig * (^)(void))newInstance;
- (BEFeatureConfig * (^)(id))videoSourceConfigW;
- (BEFeatureConfig * (^)(id))effectConfigW;
- (BEFeatureConfig * (^)(id))algorithmConfigW;
- (BEFeatureConfig * (^)(id))lensConfigW;
- (BEFeatureConfig * (^)(Class))classW;

@end

#endif /* BEFeatureConfig_h */
