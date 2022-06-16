//
//  BENetworkUtil.h
//  Effect
//
//  Created by qun on 2021/6/4.
//

#ifndef BENetworkUtil_h
#define BENetworkUtil_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BENetworkContentType) {
    JSON,
    URL_ENCODED,
};

@protocol BENetworkDownloadDelegate <NSObject>

- (NSURL *)destinationUrl;
- (void)processDidChanged:(NSProgress *)progress;
- (void)downloadDidComplete:(NSURLResponse *)response filePath:(NSURL *)filePath error:(NSError *)error;
- (dispatch_queue_t)callbackQueue;
- (dispatch_queue_t)progressCallbackQueue;

@end

@interface BENetworkUtil : NSObject

@property (nonatomic, class, readonly) BENetworkUtil *sInstance;

- (BOOL)isNetworkAvailable;

- (NSDictionary *)post:(NSString *)url withParams:(NSDictionary *)params error:(NSError **)error;

- (NSURLSessionDownloadTask *)createDownloadTaskWithURL:(NSString *)url
                                    method:(NSString *)method
                                    params:(NSDictionary<NSString *, NSString *> *)params
                               contentType:(BENetworkContentType)contentType
                          downloadDelegate:(id<BENetworkDownloadDelegate>)delegate;

@end

#endif /* BENetworkUtil_h */
