// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import "BEEffectResponseModel.h"
#import "NSString+BEAdd.h"

@implementation BEFilterItem

//- (void)setImageName:(NSString *)imageName{
//    _imageName = [NSString stringWithFormat:@"iconFilter%@", [imageName be_transformToPinyin]];
//}

- (NSString *)tipTitle {
    if (!_tipTitle) {
        return _title;
    }
    return _tipTitle;
}

@end

@implementation  BEEffectCategoryModel

+ (instancetype)categoryWithType:(BEEffectNode)type title:(NSString *)title {
    return [[self alloc] initWithType:type title:title];
}

- (instancetype)initWithType:(BEEffectNode)type title:(NSString *)title {
    if (self = [super init]) {
        _type = type;
        _title = title;
    }
    return self;
}

@end
