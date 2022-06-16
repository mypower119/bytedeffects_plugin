// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>
#import "BEEffectItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BEFilterItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *filterPath;
@property (nonatomic, copy) NSString *tipTitle;
@property (nonatomic, copy) NSString *tipDesc;

@end

@interface BEEffectCategoryModel : NSObject

@property (nonatomic, readonly) BEEffectNode type;
@property (nonatomic, readonly, copy) NSString *title;

+ (instancetype)categoryWithType:(BEEffectNode)type title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
