//
//  BEFileUtil.h
//  BECommon
//
//  Created by qun on 2021/10/20.
//

#ifndef BEFileUtil_h
#define BEFileUtil_h

#import <Foundation/Foundation.h>

@interface BEFileUtil : NSObject

+ (NSString *)md5OfFile:(NSString *)filePath;
+ (NSString *)documentFilePath:(NSString *)fileName;
+ (NSString *)filePathWithDirectory:(NSSearchPathDirectory)directory fileName:(NSString *)fileName;

@end

#endif /* BEFileUtil_h */
