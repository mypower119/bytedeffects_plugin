//
//  BEResourceManager.h
//  BECommon
//
//  Created by qun on 2021/10/21.
//

#ifndef BEResourceManager_h
#define BEResourceManager_h

#import "BEBaseResource.h"

/// @brief 资源管理类
/// @details 统一负责本地、远程资源的获取，并对其进行管理，如限制最大请求数量等
@interface BEResourceManager : NSObject

@property (nonatomic, class, readonly) BEResourceManager *sInstance;

/// @brief 同步请求资源
/// @param resource 资源表示
/// @param error 错误信息回传
- (BEResourceResult *)syncGetResource:(BEBaseResource *)resource error:(NSError *__autoreleasing *)error;

/// @brief 异步请求资源
/// @param resource 资源表示
/// @param delegate 回调 delegate
- (void)asyncGetResource:(BEBaseResource *)resource delegate:(id<BEResourceDelegate>)delegate;

- (void)clearLoadingResource;
- (void)clearCache;

@end

#endif /* BEResourceManager_h */
