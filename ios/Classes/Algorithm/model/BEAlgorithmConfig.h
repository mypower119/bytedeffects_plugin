//
//  BEAlgorithmConfig.h
//  Algorithm
//
//  Created by qun on 2021/5/23.
//

#ifndef BEAlgorithmConfig_h
#define BEAlgorithmConfig_h

#import <Foundation/Foundation.h>
#import "BEAlgorithmKey.h"

FOUNDATION_EXTERN NSString *ALGORITHM_CONFIG_KEY;

//   {zh} / 算法页面配置     {en} /Algorithm page configuration 
@interface BEAlgorithmConfig : NSObject

+ (BEAlgorithmConfig * (^)(void))newInstance;
- (BEAlgorithmConfig * (^)(NSString *))typeW;
- (BEAlgorithmConfig * (^)(NSDictionary<NSString*, NSObject*> *))paramsW;
- (BEAlgorithmConfig * (^)(NSInteger))topBarModeW;

//   {zh} / 算法类型，如 face/hand 等     {en} /Algorithm type, such as face/hand, etc 
@property (nonatomic, copy) NSString *type;

//   {zh} / 算法默认参数     {en} /Algorithm default parameters 
@property (nonatomic, copy) NSDictionary<NSString *, NSObject *> *params;

//   {zh} / 是否默认开启底部菜单栏，默认 YES     {en} /Whether to open the bottom menu bar by default, default YES 
@property (nonatomic, assign) BOOL showBoard;

//   {zh} / 顶部菜单栏样式，默认 BEBaseBarAll     {en} /Top menu bar style, default BEBaseBarAll
@property (nonatomic, assign) NSInteger topBarMode;

@property (nonatomic, readonly) BEAlgorithmKey *algorithmKey;
@property (nonatomic, readonly) NSDictionary<BEAlgorithmKey *, NSObject *> *algorithmParams;

@end

#endif /* BEAlgorithmConfig_h */
