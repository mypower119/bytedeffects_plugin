//
//  BEFileUtil.m
//  BECommon
//
//  Created by qun on 2021/10/20.
//

#import "BEFileUtil.h"
#import <CommonCrypto/CommonDigest.h>

//#define MD5_ALG_TYPE_1
#define MD5_ALG_TYPE_2
//#define MD5_ALG_TYPE_3

@implementation BEFileUtil

+ (NSString *)md5OfFile:(NSString *)filePath {
#if defined(MD5_ALG_TYPE_1)
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL
#elif defined(MD5_ALG_TYPE_2)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(data.bytes, (CC_LONG)data.length, digest);
        NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
            [md5 appendFormat:@"%02x", digest[i]];
        }
        return md5;
    }
#endif
    return nil;
}

+ (NSString *)documentFilePath:(NSString *)fileName {
    NSString *documentDir = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] path];
    return [documentDir stringByAppendingString:fileName];
}

+ (NSString *)filePathWithDirectory:(NSSearchPathDirectory)directory fileName:(NSString *)fileName {
    NSString *documentDir = [[[NSFileManager defaultManager] URLForDirectory:directory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] path];
    return [documentDir stringByAppendingString:fileName];
}

@end
