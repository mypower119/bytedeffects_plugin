//
//  BEAlgorithmUIFactory.h
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#ifndef BEAlgorithmUIFactory_h
#define BEAlgorithmUIFactory_h

#import "BEAlgorithmUI.h"

typedef id<BEAlgorithmUI> (^BEAlgorithmUIFactoryGenerator) (void);

@interface BEAlgorithmUIFactory : NSObject

//   {zh} / @brief 注册 AlgorithmUI     {en} /@Brief Registration AlgorithmUI 
+ (void)register:(BEAlgorithmKey *)key generator:(BEAlgorithmUIFactoryGenerator)generator;
//   {zh} / @brief 根据 AlgorithmTaskKey 生成 AlgorithmUI     {en} /@Brief Generate AlgorithmUI from AlgorithmTaskKey 
+ (id<BEAlgorithmUI>)create:(BEAlgorithmKey *)key;

@end

#endif /* BEAlgorithmUIFactory_h */
