//
//  BEStickerDownloadTask.m
//  Effect
//
//  Created by qun on 2021/6/4.
//

#import "BEQRScanResourceDownloadTask.h"
#import "BERemoteResource.h"
#import "BEResourceManager.h"
#import "SSZipArchive.h"
#import "YYModel.h"
#import "Common.h"

static NSString *const BASE_URL = @"https://cv-tob.bytedance.com";
//static NSString *const BASE_URL = @"http://imuse-boe.bytedance.net";
static NSString *const ENCRYPT_URL = @"/sticker_mall_tob/v1/encrypt_sdk";
static NSString *const DOWNLOAD_URL = @"/sticker_mall_tob/v1/download_effect";
static NSString *const SDK_VERSION = @"18.8.8";
static NSString *const AUTH_FILE_PATH = @"https://tosv.byted.org/obj/ies-effect-mall-admin/7f90a488b4a9f8de1cb47b4d40ff3313";

@interface BEQRResourceType : NSObject

@property (nonatomic, assign) NSInteger enumType;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL enableQrcode;

@end

@implementation BEQRResourceType

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"enumType": @"enum"
    };
}

@end

@interface BEQRResourceInfo : NSObject

@property (nonatomic, strong) NSString *secId;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) BEQRResourceType *goodsType;
@property (nonatomic, strong) BEQRResourceType *goodsSubType;

@end

@implementation BEQRResourceInfo
@end

@interface BEQRScanResourceDownloadTask () <BEResourceDelegate>

@property (nonatomic, strong) BENetworkUtil *network;
@property (nonatomic, assign) BEQRScanResourceType resourceType;
@property (nonatomic, strong) NSDictionary *lastDownloadParams;

@end

@implementation BEQRScanResourceDownloadTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        _network = [BENetworkUtil sInstance];
        _ignoreVersionRequire = NO;
    }
    return self;
}

- (void)resume {
    if (_lastDownloadParams == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self downloadResourceWithInfo:self.lastDownloadParams];
    });
}

- (void)downloadResourceWithInfo:(NSDictionary *)dict {
    _lastDownloadParams = dict;
    BEQRResourceInfo *info = [BEQRResourceInfo yy_modelWithDictionary:dict];
    
    if (info == nil) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithDesc:@"decode info fail"]];
        return;
    }
    
    if (info.secId == nil) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithDesc:@"secId not found"]];
        return;
    }
    
    BEQRScanResourceType resourceType = [self be_resourceTypeFor:info];
    if (resourceType == BEQRScanResourceTypeUnknow) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithDesc:@"unknow resource type"]];
        return;
    }
    self.resourceType = resourceType;
    
    if (info.sdkVersion && [self be_greaterThanAppVersion:info.sdkVersion] && !_ignoreVersionRequire) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithErrorCode:BEQRScanResourceErrorCodeVersionNotMatch desc:@"sdk version is too low to use this resource"]];
        return;
    }
    
    NSError *error = nil;
    NSDictionary *encryptParams = @{
        @"secId": info.secId,
        @"sdkVersion": SDK_VERSION,
        @"authFile": AUTH_FILE_PATH
    };
    NSDictionary *encryptResponse = [self.network post:[NSString stringWithFormat:@"%@%@", BASE_URL, ENCRYPT_URL] withParams:encryptParams error:&error];
    if (error != nil) {
        [self.delegate resourceDownloadTask:self downloadFail:[error copy]];
        return;
    }
    
    if (encryptResponse == nil || encryptResponse[@"base_response"] == nil) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithDesc:@"error when get encrypted url"]];
        return;
    }
    
    if (![encryptResponse[@"base_response"][@"code"]  isEqual: @(0)]) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithDesc:encryptResponse[@"base_response"][@"message"]]];
        return;
    }
    
    if (encryptResponse[@"data"] == nil || encryptResponse[@"data"][@"encryptUrl"] == nil) {
        [self.delegate resourceDownloadTask:self downloadFail:[self be_errorWithDesc:@"invalid data or encryptUrl"]];
        return;
    }
    
    [self.delegate resourceDownloadTaskDidStart];
    NSString *encryptUrl = encryptResponse[@"data"][@"encryptUrl"];
    BERemoteResource *resource = [BERemoteResource new];
    resource.url = [NSString localizedStringWithFormat:@"%@/%@", BASE_URL, DOWNLOAD_URL];
    resource.name = [[encryptUrl lastPathComponent] stringByDeletingPathExtension];
    resource.needCheckMd5 = NO;
    resource.useCache = NO;
    resource.needCache = NO;
    resource.downloadParams = @{ @"encryptUrl": encryptUrl };
    resource.downloadMethod = @"POST";
    resource.requestContentType = JSON;
    resource.downloadDirectory = NSCachesDirectory;
    
    [BEResourceManager.sInstance asyncGetResource:resource delegate:self];
}

#pragma mark - BEResourceDelegate
- (void)resource:(BEBaseResource *)resource didUpdateProgress:(NSProgress *)progress {
    [self.delegate resourceDownloadTask:self progressDidChanged:progress.fractionCompleted];
}

- (void)resource:(BEBaseResource *)resource didSuccess:(BEResourceResult *)resourceResult {
    [self.delegate resourceDownloadTask:self downloadSucess:resourceResult.path resourceType:self.resourceType];
}

- (void)resource:(BEBaseResource *)resource didFail:(NSError *)error {
    [self.delegate resourceDownloadTask:self downloadFail:[error copy]];
}

#pragma mark - private
- (NSError *)be_errorWithErrorCode:(BEQRScanResourceErrorCode)errorCode desc:(NSString *)desc {
    return [NSError errorWithDomain:@"com.bytedance.labcv.demo"
                               code:errorCode
                           userInfo:@{
        NSLocalizedDescriptionKey: desc
    }];
}

- (NSError *)be_errorWithDesc:(NSString *)desc {
    return [NSError errorWithDomain:@"com.bytedance.labcv.demo"
                               code:-1
                           userInfo:@{
        NSLocalizedDescriptionKey: desc
    }];
}

- (BEQRScanResourceType)be_resourceTypeFor:(BEQRResourceInfo *)info {
    if (info.goodsType == nil || info.goodsSubType == nil) {
        return BEQRScanResourceTypeUnknow;
    }
    
    if ([@"cv" isEqualToString:info.goodsType.key] && [@"filter" isEqualToString:info.goodsSubType.key]) {
        return BEQRScanResourceTypeFilter;
    } else if ([@"cv" isEqualToString:info.goodsType.key] && [@"effect" isEqualToString:info.goodsSubType.key]) {
        return BEQRScanResourceTypeSticker;
    }
    
    return BEQRScanResourceTypeUnknow;
}

- (BOOL)be_greaterThanAppVersion:(NSString *)sdkVersion {
    NSString *appVersion = SDK_CHEAT_APP_VERSION;
    return [self be_compareString:appVersion with:sdkVersion] == NSOrderedAscending;
}

- (NSComparisonResult)be_compareString:(NSString *)a with:(NSString *)b {
    NSArray *arrA = [a componentsSeparatedByString:@"."];
    NSArray *arrB = [b componentsSeparatedByString:@"."];
    
    NSInteger maxLength = MIN(arrA.count, arrB.count);
    for (int i = 0; i < maxLength; i++) {
        int iA = [arrA[i] intValue];
        int iB = [arrB[i] intValue];
        if (iA > iB) {
            return NSOrderedDescending;
        } else if (iA < iB) {
            return NSOrderedAscending;
        }
    }
    
    if (arrA.count == arrB.count) return NSOrderedSame;
    return arrA.count > arrB.count ? NSOrderedDescending : NSOrderedAscending;
}

@end
