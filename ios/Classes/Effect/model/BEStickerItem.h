//
//  BEStickerItem.h
//  BEEffect
//
//  Created by qun on 2021/10/21.
//

#ifndef BEStickerItem_h
#define BEStickerItem_h

#import "BEBaseResource.h"

@interface BEStickerItem : NSObject

@property (nonatomic, strong) BEBaseResource *resource;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *titles;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *tips;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *tip;

@end

@interface BEStickerGroup : NSObject

@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *titles;
@property (nonatomic, strong) NSArray<BEStickerItem *> *items;

@property (nonatomic, readonly) NSString *title;

@end

@interface BEStickerPage : NSObject

@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *titles;
@property (nonatomic, strong) NSArray<BEStickerGroup*> *tabs;

@property (nonatomic, readonly) NSString *title;

@end

@class BEStickerFetch;
@protocol BEStickerFetchDelegate <NSObject>

- (void)sitkcerFetch:(BEStickerFetch *)fetch didFetchSticker:(BEStickerPage *)stickerPage fromCache:(BOOL)fromCache;
- (void)sitkcerFetch:(BEStickerFetch *)fetch didFail:(NSError *)error;

@end

@interface BEStickerFetch : NSObject

@property (nonatomic, weak) id<BEStickerFetchDelegate> delegate;

/// @brief 根据贴纸类型获取贴纸项
/// @param type 贴纸类型
- (void)fetchPageWithType:(NSString *)type;

@end

@interface BEStickerTransformPage : NSObject

@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *materialImg;

@end

#endif /* BEStickerItem_h */
