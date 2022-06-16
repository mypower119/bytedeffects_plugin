//
//  BEStickerDownloadTask.h
//  Effect
//
//  Created by qun on 2021/6/4.
//

#ifndef BEStickerDownloadTask_h
#define BEStickerDownloadTask_h

#import "BENetworkUtil.h"

typedef NS_ENUM(NSInteger, BEQRScanResourceErrorCode) {
    BEQRScanResourceErrorCodeDefault = -1,
    BEQRScanResourceErrorCodeVersionNotMatch = -2,
};

typedef NS_ENUM(NSInteger, BEQRScanResourceType) {
    BEQRScanResourceTypeUnknow,
    BEQRScanResourceTypeSticker,
    BEQRScanResourceTypeFilter,
};

@class BEQRScanResourceDownloadTask;
@protocol BEQRScanResourceDownloadDelegate

- (void)resourceDownloadTaskDidStart;
- (void)resourceDownloadTask:(BEQRScanResourceDownloadTask *)task downloadSucess:(NSString *)filePath resourceType:(BEQRScanResourceType)resourceType;
- (void)resourceDownloadTask:(BEQRScanResourceDownloadTask *)task downloadFail:(NSError *)error;
- (void)resourceDownloadTask:(BEQRScanResourceDownloadTask *)task progressDidChanged:(float)progress;

@end

@interface BEQRScanResourceDownloadTask : NSObject

@property (nonatomic, weak) id<BEQRScanResourceDownloadDelegate> delegate;
@property (nonatomic, assign) BOOL ignoreVersionRequire;

- (void)downloadResourceWithInfo:(NSDictionary *)info;
- (void)resume;

@end

#endif /* BEStickerDownloadTask_h */
