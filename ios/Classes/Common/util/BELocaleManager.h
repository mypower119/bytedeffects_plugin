//
//  BELocaleManager.h
//  app
//
//  Created by qun on 2021/7/5.
//

#ifndef BELocaleManager_h
#define BELocaleManager_h

#import <Foundation/Foundation.h>

// {zh} / 通过系统的 locale 信息，进行一些定制化的区分 {en} /Through the locale information of the system, make some customized distinctions
@interface BELocaleManager : NSObject

// {zh} / 是否打开美白、双眼皮、卧蚕 {en} Whether to open whitening, double eyelids, sleeping silkworm
@property (nonatomic, readonly, class) BOOL isSupportWhiten;

// {zh} / 是否打开人脸比对、人脸聚类、人脸属性（年龄、性别、颜值） {en} /Whether to open face comparison, face clustering, face attributes (age, gender, color value)
@property (nonatomic, readonly, class) BOOL isSupportFaceVerify;

// {zh} / 是否打开车牌识别 {en} /Whether to turn on license plate recognition
@property (nonatomic, readonly, class) BOOL isSupportCarBrandDetect;

@property (nonatomic, readonly, class) NSString *language;

+ (NSString *)convertLocaleLog:(NSString *)log;

@end

#endif /* BELocaleManager_h */
