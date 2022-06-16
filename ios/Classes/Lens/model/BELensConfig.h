//
//  BELensConfig.h
//  Lens
//
//  Created by wangliu on 2021/6/2.
//

#ifndef BELensConfig_h
#define BELensConfig_h

#import "BELensType.h"

FOUNDATION_EXPORT NSString *const LENS_CONFIG_KEY;

//   {zh} / 画质页面配置     {en} /Image quality page configuration 
@interface BELensConfig : NSObject

+ (instancetype)initWithType:(ImageQualityType)type open:(BOOL)open;

@property (nonatomic, assign) ImageQualityType type;
@property (nonatomic, assign) BOOL open;

//   {zh} / 是否默认开启底部菜单栏，默认 YES     {en} /Whether to open the bottom menu bar by default, default YES 
@property (nonatomic) BOOL showBoard;

@end


#endif /* BELensConfig_h */
