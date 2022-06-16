//
//  BEStickerConfig.h
//  Effect
//
//  Created by qun on 2021/5/25.
//

#ifndef BEStickerConfig_h
#define BEStickerConfig_h

#import <Foundation/Foundation.h>

//   {zh} / 贴纸相关配置     {en} /Sticker related configuration 
@interface BEStickerConfig : NSObject

+ (BEStickerConfig * (^)(NSString *))newInstance;
- (BEStickerConfig * (^)(NSString *))stickerPathW;

//   {zh} / 贴纸类型，如 BETypeSticker/BETypeAnimoji 等     {en} /Sticker type such as BETypeSticker/BETypeAnimoji etc 
@property (nonatomic, assign) NSString *type;

//   {zh} / 默认贴纸路径     {en} /Default sticker path 
@property (nonatomic, copy) NSString *stickerPath;

@end


#endif /* BEStickerConfig_h */
