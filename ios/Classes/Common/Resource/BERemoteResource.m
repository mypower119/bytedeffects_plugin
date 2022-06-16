//
//  BERemoteResource.m
//  BECommon
//
//  Created by qun on 2021/10/19.
//

#import "BERemoteResource.h"
#import "BEFileUtil.h"
#import "SSZipArchive.h"

static const NSInteger MAX_NETWORK_RETRY_COUNT = 3;
static BEDownloadContext *sDownloadContext = nil;

@implementation BEDownloadContext

+ (instancetype)sInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDownloadContext = [BEDownloadContext new];
    });
    return sDownloadContext;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataManager = [BEDataManager new];
        _networkUtil = [BENetworkUtil sInstance];
        _downloadQueue = dispatch_queue_create("download queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

@end

@implementation BERemoteResourceResult

+ (instancetype)resultWithPath:(NSString *)path fromCache:(BOOL)fromCache {
    BERemoteResourceResult *result = [BERemoteResourceResult new];
    result.path = path;
    result.isFromCache = fromCache;
    return result;
}

@end

@interface BEInnerResourceDelegate : NSObject <BEResourceDelegate>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) BEResourceResult *resourcePath;
@property (nonatomic, copy) void(^progressBlock)(NSProgress *progress);

@end

@implementation BEInnerResourceDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)resource:(BEBaseResource *)item didSuccess:(BEResourceResult *)resourcePath {
    _resourcePath = resourcePath;
    dispatch_semaphore_signal(_semaphore);
}

- (void)resource:(BEBaseResource *)item didFail:(NSError *)error {
    _error = error;
    dispatch_semaphore_signal(_semaphore);
}

- (void)resource:(BEBaseResource *)item didUpdateProgress:(NSProgress *)progress {
    _progressBlock(progress);
}

@end

@interface BERemoteResource () <BENetworkDownloadDelegate>

@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) NSInteger retryCount;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, assign) BOOL isKnowCached;

@end

@implementation BERemoteResource

@synthesize state = _state;
@synthesize downloadProgress = _downloadProgress;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _context = [BEDownloadContext sInstance];
        _isCanceled = NO;
        _isKnowCached = NO;
        _state = BERemoteResourceStateUnknow;
        
        _needUnzip = YES;
        _needCache = YES;
        _needCheckMd5 = YES;
        _useCache = YES;
        _downloadParams = nil;
        _downloadMethod = @"GET";
        _downloadDirectory = NSDocumentDirectory;
        _requestContentType = URL_ENCODED;
    }
    return self;
}

#pragma mark public

- (BEResourceResult *)syncGetResource:(NSError *__autoreleasing *)error {
    _isCanceled = NO;
    BEInnerResourceDelegate *innerDelegate = [BEInnerResourceDelegate new];
    self.delegate = innerDelegate;
    [self asyncGetResource];
    dispatch_semaphore_wait(innerDelegate.semaphore, DISPATCH_TIME_FOREVER);
    *error = innerDelegate.error;
    return innerDelegate.resourcePath;
}

- (void)asyncGetResource {
    _isCanceled = NO;
    _retryCount = 0;
    if (self.context == nil) {
        [self.delegate resource:self
                       didFail:[self errorWithCode:BEResourceErrorCodeDefault desc:@"context must not be nil"]];
        return;
    }
    dispatch_async(self.context.downloadQueue, ^{
        BEDownloadResourceItem *item = self.useCache ? [self cachedItem] : nil;
        
        if (item == nil) {
            [self fetchRemoteReource];
            return;
        } else {
            BOOL ret = [self fetchLocalResource:item];
            if (ret) {
                return;
            }
            
            NSLog(@"fetch local resource failed, try to featch remote resource");
            [self fetchRemoteReource];
        }
    });
}

- (void)cancel {
    dispatch_async(self.context.downloadQueue, ^{
        self->_state = BERemoteResourceStateUnknow;
        self.isCanceled = YES;
        
        if (self.downloadTask) {
            [self.downloadTask cancel];
            self.downloadTask = nil;
        }
    });
}

- (BERemoteResourceState)state {
    if (_state == BERemoteResourceStateUnknow) {
        BEDownloadResourceItem *item = [self.context.dataManager downloadResourceItemWithName:self.name];
        BOOL isCached = item != nil && [item.md5 isEqualToString:self.md5];
        _state = isCached ? BERemoteResourceStateCached : BERemoteResourceStateRemote;
    }
    return _state;
}

#pragma mark BENetworkDownloadDelegate
- (dispatch_queue_t)callbackQueue {
    return self.context.downloadQueue;
}

- (dispatch_queue_t)progressCallbackQueue {
    return dispatch_get_main_queue();
}

- (void)processDidChanged:(NSProgress *)progress {
    _downloadProgress = progress;
    if ([self.delegate respondsToSelector:@selector(resource:didUpdateProgress:)]) {
        [self.delegate resource:self didUpdateProgress:progress];
    }
}

- (NSURL *)destinationUrl {
    return [NSURL URLWithString:[@"file://" stringByAppendingString:[BEFileUtil filePathWithDirectory:_downloadDirectory fileName:[self fileName]]]];
}

- (void)downloadDidComplete:(NSURLResponse *)response filePath:(NSURL *)filePath error:(NSError *)error {
    if (_isCanceled) {
        NSLog(@"resource %@ canceled", self);
        [self.delegate resource:self didFail:error];
        return;
    }
    
    if (error) {
        if (![self checkIfRetry]) {
            [self.delegate resource:self didFail:error];
            _state = BERemoteResourceStateRemote;
        }
        return;
    }

    BOOL ret = NO;
    if (_needCheckMd5) {
        // md5 校验
        ret = [self checkDownloadFile:[filePath path] md5:self.md5];
        if (!ret) {
            _state = BERemoteResourceStateRemote;
            error = [self errorWithCode:BEResourceErrorCodeMd5CheckError desc:@"md5 check fail"];
            if (![self checkIfRetry]) {
                [self.delegate resource:self didFail:error];
            }
            return;
        }
    }
    
    NSString *destination = [filePath path];
    if (_needUnzip) {
        // 解压
        NSString *unzipFilePath = [destination stringByDeletingPathExtension];
        ret = [self unzipResource:destination destination:unzipFilePath];
        if (!ret) {
            [self.delegate resource:self didFail:[self errorWithCode:BEResourceErrorCodeUnzipError desc:@"unzip fail"]];
            _state = BERemoteResourceStateRemote;
            return;
        }
        destination = unzipFilePath;
    }
    
    if (_needCache) {
        // 加入缓存
        if ([self.context.dataManager addResourceItem:self.name path:[self fileName] md5:self.md5]) {
            _state = BERemoteResourceStateCached;
        } else {
            [self.delegate resource:self didFail:[self errorWithCode:BEResourceErrorCodeAddCacheError desc:@"add cache fail"]];
            _state = BERemoteResourceStateRemote;
            return;
        }
    }
    
    // 回调
    [self.delegate resource:self didSuccess:[BERemoteResourceResult resultWithPath:destination fromCache:NO]];
}

#pragma mark protected
- (BOOL)checkIfRetry {
    if (_retryCount++ < MAX_NETWORK_RETRY_COUNT) {
        [self fetchRemoteReource];
        return YES;
    }
    return NO;
}

- (void)fetchRemoteReource {
    BENetworkUtil *network = self.context.networkUtil;
    
    if (!network.isNetworkAvailable) {
        _state = BERemoteResourceStateUnknow;
        [self.delegate resource:self didFail:[self errorWithCode:BEResourceErrorCodeNetworkUnavailable desc:@"network is not available"]];
        return;
    }
    
    NSError *error;
    NSString *filePath = [BEFileUtil filePathWithDirectory:_downloadDirectory fileName:[self fileName]];
    if (![self prepareFilePath:filePath error:&error]) {
        _state = BERemoteResourceStateUnknow;
        [self.delegate resource:self didFail:error];
        return;
    }
    
    _downloadTask = [network createDownloadTaskWithURL:self.url
                   method:self.downloadMethod
                   params:self.downloadParams
              contentType:self.requestContentType
         downloadDelegate:self];
    [_downloadTask resume];
    
    _state = BERemoteResourceStateDownloading;
    if ([self.delegate respondsToSelector:@selector(resourceDidStart:)]) {
        [self.delegate resourceDidStart:self];
    }
}

- (BOOL)fetchLocalResource:(BEDownloadResourceItem *)item {
    NSString *filePath = [BEFileUtil filePathWithDirectory:_downloadDirectory fileName:item.path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }
    
    if (_needCheckMd5) {
        if (![self checkDownloadFile:filePath md5:self.md5]) {
            return NO;
        }
    }
    
    if (_needUnzip) {
        filePath = [filePath stringByDeletingPathExtension];
    }
    
    [self.delegate resource:self didSuccess:[BERemoteResourceResult resultWithPath:filePath fromCache:YES]];
    return YES;
}

- (BEDownloadResourceItem *)cachedItem {
    return [self.context.dataManager downloadResourceItemWithName:self.name];
}

- (BOOL)prepareFilePath:(NSString *)filePath error:(NSError *__autoreleasing *)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [filePath stringByDeletingLastPathComponent];
    
    if (![fileManager fileExistsAtPath:directory]) {
        BOOL suc = [fileManager createDirectoryAtPath:directory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:error];
        
        if (!suc) {
            return NO;
        }
    }
    
    if ([fileManager fileExistsAtPath:filePath]) {
        BOOL suc = [fileManager removeItemAtPath:filePath error:error];
        
        if (!suc) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)checkDownloadFile:(NSString *)filePath md5:(NSString *)md5 {
    NSString *fileMd5 = [BEFileUtil md5OfFile:filePath];
    return fileMd5 != nil && [fileMd5 isEqualToString:md5];
}

- (BOOL)unzipResource:(NSString *)filePath destination:(NSString *)destination {
    return [SSZipArchive unzipFileAtPath:filePath toDestination:destination];
}

- (NSString *)fileName {
    return [NSString stringWithFormat:@"/resource/%@%@", self.name, _needUnzip ? @".zip" : @""];
}

- (NSError *)errorWithCode:(NSInteger)errorCode desc:(NSString *)desc {
    return [NSError errorWithDomain:BEResourceDomain code:errorCode userInfo:@{
        NSLocalizedDescriptionKey: desc
    }];
}

@end
