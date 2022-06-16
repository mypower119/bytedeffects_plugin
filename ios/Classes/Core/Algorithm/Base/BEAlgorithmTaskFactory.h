//
//  BEAlgorithmTaskFactory.h
//  Core
//
//  Created by qun on 2021/5/17.
//

#ifndef BEAlgorithmTaskFactory_h
#define BEAlgorithmTaskFactory_h

#import "BEAlgorithmTask.h"
#import "BELicenseHelper.h"

typedef BEAlgorithmTask *(^BEAlgorithmTaskGenerator) (id<BEAlgorithmResourceProvider>, id<BELicenseProvider>);

@interface BEAlgorithmTaskFactory : NSObject

//   {zh} / @brief 注册算法     {en} /@brief registration algorithm 
//   {zh} / @param key 算法 key     {en} /@param key algorithm key 
//   {zh} / @param generator 算法生产者     {en} /@param generator algorithm producer 
+ (void)register:(BEAlgorithmKey *)key generator:(BEAlgorithmTaskGenerator)generator;

//   {zh} / @brief 创建算法     {en} /@brief creation algorithm 
//   {zh} / @param key 算法 key     {en} /@param key algorithm key 
//   {zh} / @param provider 资源路径提供类     {en} /@param provider resource path provider class 
+ (BEAlgorithmTask *)create:(BEAlgorithmKey *)key provider:(id<BEAlgorithmResourceProvider>)provider licenseProvider:(id<BELicenseProvider>) licenseProvider;

@end

#endif /* BEAlgorithmTaskFactory_h */
