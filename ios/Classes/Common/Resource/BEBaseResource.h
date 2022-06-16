//
//  BEBaseResource.h
//  BECommon
//
//  Created by qun on 2021/10/19.
//

#ifndef BEResourceItem_h
#define BEResourceItem_h

#import <Foundation/Foundation.h>

@class BEBaseResource;
@class BEResourceResult;
@protocol BEResourceDelegate <NSObject>

- (void)resource:(BEBaseResource *)resource didSuccess:(BEResourceResult *)resourceResult;
- (void)resource:(BEBaseResource *)resource didFail:(NSError *)error;
@optional
- (void)resourceDidStart:(BEBaseResource *)resource;
- (void)resource:(BEBaseResource *)resource didUpdateProgress:(NSProgress *)progress;

@end

@interface BEResourceResult : NSObject

+ (instancetype)resultWithPath:(NSString *)path;

@property (nonatomic, copy) NSString *path;

@end

@interface BEBaseResource : NSObject <NSCopying>

/// 资源 ID
@property (nonatomic, strong) NSString *name;

@property (nonatomic, weak) id<BEResourceDelegate> delegate;

/// @brief 同步请求资源，会堵塞当前线程
/// @param error 错误信息回传
- (BEResourceResult *)syncGetResource:(NSError *__autoreleasing *)error;

/// @brief 异步请求资源
- (void)asyncGetResource;

- (void)cancel;

@end

#endif /* BEResourceItem_h */

extern NSString *BEResourceDomain;
typedef NS_ENUM(NSInteger, BEResourceErrorCode) {
    BEResourceErrorCodeDefault = -1,
    BEResourceErrorCodeNetworkUnavailable = -2,
    BEResourceErrorCodeMd5CheckError = -3,
    BEResourceErrorCodeUnzipError = -4,
    BEResourceErrorCodeAddCacheError = -5,
};
