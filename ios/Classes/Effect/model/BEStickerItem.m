//
//  BEStickerItem.m
//  BEEffect
//
//  Created by qun on 2021/10/21.
//

#import "BEStickerItem.h"
#import "BELocaleManager.h"
#import "BEResourceManager.h"
#import "BERemoteResource.h"
#import "BELocalResource.h"
#import "YYModel.h"
#import "Common.h"

//static NSString *BASE_URL = @"http://sticker-distribution.bytedance.net";
static NSString *BASE_URL = @"https://assets.voleai.com";

NSString *stringFromDictionary(NSDictionary<NSString *, NSString *> *dict) {
    if (dict.count == 0) {
        return nil;
    }
    NSString *language = [BELocaleManager language];
    if ([[dict allKeys] containsObject:language]) {
        return [dict objectForKey:language];
    }
    return [dict allValues].firstObject;
}

@interface BEStickerItem ()

@end

@implementation BEStickerItem

- (NSString *)title {
    return stringFromDictionary(_titles);
}

- (NSString *)tip {
    return stringFromDictionary(_tips);
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic.allKeys containsObject:@"resource"]) {
        NSDictionary *resoureDict = dic[@"resource"];
        if ([resoureDict.allKeys containsObject:@"url"]) {
            self.resource = [BERemoteResource yy_modelWithDictionary:resoureDict];
        } else if ([resoureDict.allKeys containsObject:@"path"]) {
            self.resource = [BELocalResource yy_modelWithDictionary:resoureDict];
        }
    }
  return YES;
}

@end

@interface BEStickerGroup ()

@end

@implementation BEStickerGroup

- (NSString *)title {
    return stringFromDictionary(_titles);
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"items": [BEStickerItem class]
    };
}

@end

@interface BEStickerPage ()

@end

@implementation BEStickerPage

- (NSString *)title {
    return stringFromDictionary(_titles);
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"tabs": [BEStickerGroup class]
    };
}

@end

@interface BEStickerInfo : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) BEStickerPage *data;

@end

@implementation BEStickerInfo
@end

@interface BEStickerFetch () <BEResourceDelegate>

@property (nonatomic, assign) BOOL ignoreError;
@property (nonatomic, strong) BEStickerPage *localStickerPage;
@property (nonatomic, strong) BERemoteResource *remoteResource;

@end

@implementation BEStickerFetch

- (void)fetchPageWithType:(NSString *)type {
    NSString *systemVersion = @"iOS";
    NSString *systemLanguage = BELocaleManager.language;
    NSString *appVersion = SDK_CHEAT_APP_VERSION;
    NSString *resourceType = type;
    
    BERemoteResource *resource = [BERemoteResource new];
    resource.name = [NSString stringWithFormat:@"%@_%@_%@_%@", systemVersion, systemLanguage, appVersion, resourceType];
    resource.url = [BASE_URL stringByAppendingString:@"/material/load_config"];
    resource.needCheckMd5 = NO;
    resource.needUnzip = NO;
    resource.downloadMethod = @"POST";
    resource.requestContentType = URL_ENCODED;
    resource.downloadParams = @{
        @"system_version": systemVersion,
        @"system_language": systemLanguage,
        @"app_version": appVersion,
        @"resource_type": resourceType
    };
    
    _ignoreError = NO;
    _remoteResource = resource;
    [BEResourceManager.sInstance asyncGetResource:resource delegate:self];
}

- (BEStickerInfo *)stickerInfoWithFile:(BEResourceResult *)resourceResult {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:resourceResult.path];
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (error != nil) {
        NSLog(@"decode json error %@", error);
        return nil;
    }
    BEStickerInfo *stickerInfo = [BEStickerInfo yy_modelWithDictionary:obj];
    BEStickerPage *stickerPage = stickerInfo.data;
    
    if (stickerPage != nil) {
        // 给每一个 tab 添加一个关闭按钮
        BEStickerItem *closeSticker = [[BEStickerItem alloc] init];
        closeSticker.titles = @{@"zh": NSLocalizedString(@"close", nil)};
        closeSticker.icon = @"ic_close_icon";
        for (BEStickerGroup *group in stickerPage.tabs) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:group.items];
            [arr insertObject:closeSticker atIndex:0];
            group.items = [arr copy];
        }
    }
    
    return stickerInfo;
}

#pragma mark BEResourceDelegate
- (void)resource:(BEBaseResource *)resource didFail:(NSError *)error {
    NSLog(@"download %@ error %@", resource, error);
    if (!_ignoreError) {
        [self.delegate sitkcerFetch:self didFail:error];
    }
}

- (void)resource:(BEBaseResource *)resource didSuccess:(BEResourceResult *)resourceResult {
    assert([resourceResult isKindOfClass:[BERemoteResourceResult class]]);
    BERemoteResourceResult *result = (BERemoteResourceResult *)resourceResult;
    BEStickerInfo *stickerInfo = [self stickerInfoWithFile:result];
    BOOL available = stickerInfo != nil && stickerInfo.data != nil;
    BEStickerPage *stickerPage = available ? stickerInfo.data : nil;
    
    if (result.isFromCache) {
        if (available) {
            [self.delegate sitkcerFetch:self didFetchSticker:stickerPage fromCache:result.isFromCache];
            _localStickerPage = stickerPage;
            _ignoreError = YES;
        }
        
        BERemoteResource *remoteResource = (BERemoteResource *)resource;
        remoteResource.useCache = NO;
        
        [BEResourceManager.sInstance asyncGetResource:remoteResource delegate:self];
    } else {
        if (!available) {
            [self.delegate sitkcerFetch:self didFail:[NSError errorWithDomain:BEResourceDomain code:-1 userInfo:@{
                NSLocalizedDescriptionKey: stickerInfo == nil ? @"read json config fail" : stickerInfo.message
            }]];
            return;
        }
        if (_localStickerPage == nil || stickerPage.version > _localStickerPage.version) {
            [self.delegate sitkcerFetch:self didFetchSticker:stickerPage fromCache:NO];
        }
    }
}

@end

@interface BEStickerTransformPage ()

@end

@implementation BEStickerTransformPage

@end
