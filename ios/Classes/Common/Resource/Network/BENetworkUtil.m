//
//  BENetworkUtil.m
//  Effect
//
//  Created by qun on 2021/6/4.
//

#import "BENetworkUtil.h"
#import <AFNetworking/AFHTTPSessionManager.h>

static BENetworkUtil *sInstance = nil;

@interface BENetworkUtil ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@property (nonatomic, strong) AFJSONRequestSerializer *jsonSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpSerializer;

@end

@implementation BENetworkUtil

+ (BENetworkUtil *)sInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [BENetworkUtil new];
    });
    return sInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _jsonSerializer = [AFJSONRequestSerializer serializer];
        _httpSerializer = [AFHTTPRequestSerializer serializer];
        _jsonSerializer.timeoutInterval = 15.f;
        _httpSerializer.timeoutInterval = 15.f;
        _manager.requestSerializer = _jsonSerializer;
        
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachabilityManager startMonitoring];
    }
    return self;
}

- (void)dealloc
{
    [_reachabilityManager stopMonitoring];
    _reachabilityManager = nil;
}

- (NSDictionary *)post:(NSString *)url withParams:(NSDictionary *)params error:(NSError *__autoreleasing *)error {
    NSDictionary *response = [self sendPostRequestSync:url content:params error:error];
    return response;
}

- (NSURLSessionDownloadTask *)createDownloadTaskWithURL:(NSString *)url method:(NSString *)method params:(NSDictionary<NSString *,NSString *> *)params contentType:(BENetworkContentType)contentType downloadDelegate:(id<BENetworkDownloadDelegate>)delegate {
    NSMutableURLRequest *request = nil;
    NSError *error = nil;
    if (contentType == JSON) {
        request = [self.jsonSerializer requestWithMethod:method
                                               URLString:url
                                              parameters:params
                                                   error:&error];
    } else {
        request = [self.httpSerializer requestWithMethod:method
                                               URLString:url
                                              parameters:params
                                                   error:&error];
    }
    
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept-Encoding"];
    
    if (request == nil) {
        return nil;
    }
    
    __weak typeof(delegate) weakDelegate = delegate;
    NSURLSessionDownloadTask *task = [self.manager
                                      downloadTaskWithRequest:request
                                      progress:^(NSProgress * _Nonnull downloadProgress) {
        if (!weakDelegate) {
            NSLog(@"delegate is nil for url %@", request.URL);
            return;
        }
        __strong typeof(weakDelegate) strongDelegate = weakDelegate;
        if (strongDelegate.progressCallbackQueue) {
            dispatch_async(strongDelegate.progressCallbackQueue, ^{
                [strongDelegate processDidChanged:downloadProgress];
            });
        } else {
            [strongDelegate processDidChanged:downloadProgress];
        }
    }
                                      destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!weakDelegate) {
            NSLog(@"delegate is nil for url %@", request.URL);
            return nil;
        }
        return [weakDelegate destinationUrl];
    }
                                      completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!weakDelegate) {
            NSLog(@"delegate is nil for url %@", request.URL);
            return;
        }
        __strong typeof(weakDelegate) strongDelegate = weakDelegate;
        if (strongDelegate.callbackQueue) {
            dispatch_async(strongDelegate.callbackQueue, ^{
                [strongDelegate downloadDidComplete:response filePath:filePath error:error];
            });
        } else {
            [strongDelegate downloadDidComplete:response filePath:filePath error:error];
        }
    }];
    return task;
}

- (id)sendPostRequestSync:(NSString*)url content:(id)content error:(NSError *__autoreleasing *)error {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSObject *data;
    [self.manager POST:url parameters:content headers:nil progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        data = responseObject;
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull er) {
        *error = er;
        data = nil;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return data;
}

- (BOOL)isNetworkAvailable {
    return _reachabilityManager.isReachable;
}

@end
