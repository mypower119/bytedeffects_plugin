//
//  BELocaleManager.m
//  app
//
//  Created by qun on 2021/7/5.
//

#import "BELocaleManager.h"

@interface BELocaleItem : NSObject
// {zh} / 语种 {en} /Language
@property (nonatomic, strong) NSString *language;
// {zh} / 语种细分，如中文-简体，中文-繁体，为 nil 表示可以与其他任意值匹配 {en} /Language subdivisions, such as Chinese-Simplified, Chinese-Traditional, nil means can match any other value
@property (nonatomic, strong) NSString *secondaryLanguage;
// {zh} / 地区，为 nil 表示可以与其他任意值匹配 {en} /Region, nil means it can match any other value
@property (nonatomic, strong) NSString *country;

// {zh} / @brief 根据系统语言初始化 {en} /@BriefInitial according to system language
// {zh} / @details 假定系统语言只有两种形式，语种-地区 和 语种-细分语种-地区， {en} /@Details assumes that there are only two forms of system language, language-region, and language-subdivision language-region,
// {zh} / 那么就直接根据 - 分割成数组，就可以拿到每一个变量的值，进而与配置的白名单比对 {en} /Then divide it into arrays directly according to-, you can get the value of each variable, and then compare it with the configured whitelist
// {zh} / @param languageString 系统输出的默认语言 {en} /@param languageString system output default language
- (instancetype)initWithLanguageString:(NSString *)languageString;
- (instancetype)initWithLanguage:(NSString *)language secondaryLanguage:(NSString *)secondaryLanguage country:(NSString *)country;

@end

@implementation BELocaleItem

- (instancetype)initWithLanguageString:(NSString *)languageString {
    self = [super init];
    if (self) {
        NSArray *arr = [languageString componentsSeparatedByString:@"-"];
        if (arr.count == 2) {
            self.language = arr[0];
            self.country = arr[1];
        } else if (arr.count == 3) {
            self.language = arr[0];
            self.secondaryLanguage = arr[1];
            self.country = arr[2];
        } else {
            NSLog(@"invalid language %@, need re-check language", languageString);
        }
    }
    
    return self;
}

- (instancetype)initWithLanguage:(NSString *)language secondaryLanguage:(NSString *)secondaryLanguage country:(NSString *)country {
    self = [super init];
    if (self) {
        self.language = language;
        self.secondaryLanguage = secondaryLanguage;
        self.country = country;
    }
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![[self class] isEqual:[other class]]) {
        return NO;
    } else {
        BELocaleItem *o = other;
        if (![self.language isEqualToString:o.language]) {
            return NO;
        }
        if (self.secondaryLanguage != nil && o.secondaryLanguage != nil) {
            if (![self.secondaryLanguage isEqualToString:o.secondaryLanguage]) {
                return NO;
            }
        }
        if (self.country != nil && o.country != nil) {
            if (![self.country isEqualToString:o.country]) {
                return NO;
            }
        }
        return YES;
    }
}

- (NSUInteger)hash
{
    return [self.language hash];
}

@end

@interface BELocaleManager ()

@property (nonatomic, class, readonly) NSSet *whitenAllowList;
@property (nonatomic, class, readonly) NSSet *faceVerifyAllowList;
@property (nonatomic, class, readonly) NSSet *carBrandAllowList;
@property (nonatomic, class, readonly) BELocaleItem *localeIdentifier;

@end

@implementation BELocaleManager

+ (BOOL)isSupportWhiten {
    return [[self whitenAllowList] containsObject:[self localeIdentifier]];
}

+ (BOOL)isSupportFaceVerify {
    return [[self faceVerifyAllowList] containsObject:[self localeIdentifier]];
}

+ (BOOL)isSupportCarBrandDetect {
    return [[self carBrandAllowList] containsObject:[self localeIdentifier]];
}

+ (NSString *)language {
    return [self localeIdentifier].language;
}

+ (NSString *)convertLocaleLog:(NSString *)log {
    NSArray *splitLogs = [self splitLog:log];
    if (splitLogs.count <= 1) {
        return log;
    }
    BELocaleItem *item = [self localeIdentifier];
    //  {zh} 首选当前系统语言  {en} Preferred current system language
    NSString *msg = [self extractLog:item.language from:splitLogs];
    if (msg != nil) {
        return msg;
    }
    //  {zh} 次选英语  {en} Second choice English
    msg = [self extractLog:@"en" from:splitLogs];
    if (msg != nil) {
        return msg;
    }
    //  {zh} 第一项兜底  {en} First item
    msg = splitLogs[0][1];
    return [msg stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

#pragma mark - getter
+ (NSSet *)whitenAllowList {
    static dispatch_once_t onceToken;
    static NSSet *list;
    dispatch_once(&onceToken, ^{
        list = [NSSet setWithArray:@[
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"CN"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hant" country:@"CN"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"HK"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"MO"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"SG"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"TW"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hant" country:@"HK"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hant" country:@"MO"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hant" country:@"SG"],
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hant" country:@"TW"],
            [[BELocaleItem alloc] initWithLanguage:@"km" secondaryLanguage:nil country:nil],
            [[BELocaleItem alloc] initWithLanguage:@"lo" secondaryLanguage:nil country:nil],
            [[BELocaleItem alloc] initWithLanguage:@"en" secondaryLanguage:nil country:@"MY"],
            [[BELocaleItem alloc] initWithLanguage:@"en" secondaryLanguage:nil country:@"PH"],
            [[BELocaleItem alloc] initWithLanguage:@"en" secondaryLanguage:nil country:@"SG"],
            [[BELocaleItem alloc] initWithLanguage:@"id" secondaryLanguage:nil country:nil],
            [[BELocaleItem alloc] initWithLanguage:@"ja" secondaryLanguage:nil country:nil],
            [[BELocaleItem alloc] initWithLanguage:@"ko" secondaryLanguage:nil country:nil],
            [[BELocaleItem alloc] initWithLanguage:@"ms" secondaryLanguage:nil country:@"NY"],
            [[BELocaleItem alloc] initWithLanguage:@"ms" secondaryLanguage:nil country:@"BN"],
            [[BELocaleItem alloc] initWithLanguage:@"th" secondaryLanguage:nil country:nil],
            [[BELocaleItem alloc] initWithLanguage:@"vi" secondaryLanguage:nil country:nil],
        ]];
    });
    return list;
}

+ (NSSet *)faceVerifyAllowList {
    static dispatch_once_t onceToken;
    static NSSet *list;
    dispatch_once(&onceToken, ^{
        list = [NSSet setWithArray:@[
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"CN"],
        ]];
    });
    return list;
}

+ (NSSet *)carBrandAllowList {
    static dispatch_once_t onceToken;
    static NSSet *list;
    dispatch_once(&onceToken, ^{
        list = [NSSet setWithArray:@[
            [[BELocaleItem alloc] initWithLanguage:@"zh" secondaryLanguage:@"Hans" country:@"CN"],
        ]];
    });
    return list;
}

+ (BELocaleItem *)localeIdentifier {
    static dispatch_once_t onceToken;
    static BELocaleItem *identifier;
    dispatch_once(&onceToken, ^{
        identifier = [[BELocaleItem alloc] initWithLanguageString:[NSLocale preferredLanguages][0]];
    });
    return identifier;
}

+ (NSArray *)splitLog:(NSString *)log {
    NSArray *s1 = [log componentsSeparatedByString:@"{"];
    if (s1.count <= 1) {
        NSLog(@"could not split log %@, return directly", log);
        return @[];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *s2 in s1) {
        if ([s2 isEqualToString:@""]) {
            continue;
        }
        NSArray *s3 = [s2 componentsSeparatedByString:@"}"];
        if (s3.count != 2) {
            NSLog(@"could not parse single language %@, skip", s2);
            continue;
        }
        [result addObject:s3];
    }
    return result;
}

+ (NSString *)extractLog:(NSString *)language from:(NSArray *)arr {
    for (NSArray *ar in arr) {
        if ([ar[0] isEqualToString:language]) {
            return ar[1];
        }
    }
    return nil;
}

@end
