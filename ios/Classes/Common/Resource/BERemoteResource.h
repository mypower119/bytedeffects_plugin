//
//  BERemoteResource.h
//  BECommon
//
//  Created by qun on 2021/10/19.
//

#ifndef BERemoteResourceItem_h
#define BERemoteResourceItem_h

#import "BEBaseResource.h"
#import "BEDataManager.h"
#import "BENetworkUtil.h"

@interface BEDownloadContext : NSObject

+ (instancetype)sInstance;

@property (nonatomic, strong) BEDataManager *dataManager;
@property (nonatomic, strong) BENetworkUtil *networkUtil;
@property (nonatomic, strong) dispatch_queue_t downloadQueue;

@end

@interface BERemoteResourceResult : BEResourceResult

+ (instancetype)resultWithPath:(NSString *)path fromCache:(BOOL)fromCache;

/// 是否从缓存中取得
@property (nonatomic, assign) BOOL isFromCache;

@end

typedef NS_ENUM(NSInteger, BERemoteResourceState) {
    BERemoteResourceStateUnknow,
    BERemoteResourceStateRemote,
    BERemoteResourceStateDownloading,
    BERemoteResourceStateCached
};

@interface BERemoteResource : BEBaseResource

/// 执行下载必须的环境，内含下载器、缓存器等
@property (nonatomic, strong) BEDownloadContext *context;
/// 下载的 URL
@property (nonatomic, strong) NSString *url;
/// 待下载文件的 md5，如果不需要进行 md5 校验（needCheckMd5 = NO），可以不传值
@property (nonatomic, strong) NSString *md5;

/// 当前的状态
@property (nonatomic, readonly) BERemoteResourceState state;
/// 下载进度，当前状态为 BERemoteResourceStateDownloading 时有效
@property (nonatomic, readonly) NSProgress *downloadProgress;

#pragma mark - 额外下载配置，可选设置
/// 是否需要解压，默认 YES
@property (nonatomic, assign) BOOL needUnzip;
/// 是否需要缓存路径，默认 YES
@property (nonatomic, assign) BOOL needCache;
/// 是否使用缓存路径，默认 YES
@property (nonatomic, assign) BOOL useCache;
/// 是否需要 check md5，默认 YES
@property (nonatomic, assign) BOOL needCheckMd5;
/// 下载参数，默认 nil
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *downloadParams;
/// 下载方法，GET/POST 等，默认 GET
@property (nonatomic, strong) NSString *downloadMethod;
@property (nonatomic, assign) BENetworkContentType requestContentType;
/// 文件下载路径，默认 NSDocumentDirectory
@property (nonatomic, assign) NSSearchPathDirectory downloadDirectory;

@end

#endif /* BERemoteResourceItem_h */
