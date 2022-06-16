//
//  BEEffectConfig.h
//  Effect
//
//  Created by qun on 2021/5/23.
//

#ifndef BEEffectConfig_h
#define BEEffectConfig_h

#import <Foundation/Foundation.h>
#import "BEStickerConfig.h"
#import "BEEffectDataManager.h"

FOUNDATION_EXTERN NSString *const EFFECT_CONFIG_KEY;


@interface BEEffectBeautyConfigItem : NSObject

- (instancetype)initWithTitle:(NSString *)title type:(BEEffectType)type;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BEEffectType effecType;

@end

// {zh} / 特效页面配置 {en} /Effect page configuration
@interface BEEffectConfig : NSObject

+ (BEEffectConfig * (^)(void))newInstance;
- (BEEffectConfig * (^)(BOOL, BOOL))showResetAndCompareW;
- (BEEffectConfig * (^)(id))stickerConfigW;
- (BEEffectConfig * (^)(BEEffectType))effectTypeW;
- (BEEffectConfig * (^)(id))titleW;
- (BEEffectConfig * (^)(NSInteger))topBarModeW;

//   {zh} / 是否默认开启底部菜单栏，默认 YES     {en} /Whether to open the bottom menu bar by default, default YES 
@property (nonatomic) BOOL showBoard;

@property (nonatomic, strong) NSString *title;

//   {zh} / 是否展示重置按钮，默认 YES     {en} /Whether to show the reset button, the default YES 
@property (nonatomic) BOOL showResetButton;

//   {zh} / 是否展示对比按钮，默认 YES     {en} /Whether to show the comparison button, the default YES 
@property (nonatomic) BOOL showCompareButton;

//   {zh} / 顶部菜单栏样式，默认 BEBaseBarAll     {en} /Top menu bar style, default BEBaseBarAll
@property (nonatomic, assign) NSInteger topBarMode;

// {zh} / 贴纸相关配置 {en} /Sticker related configuration
@property (nonatomic, strong) BEStickerConfig *stickerConfig;
// {zh} / 特效类型，如 lite、standard {en} /Effect types, such as lite, standard
@property (nonatomic, assign) BEEffectType effectType;

#pragma mark - 自动化测试相关
// {zh} / 是否处于自动化测试模式，当处于自动化测试模式时，默认美颜会关闭，默认 NO {en} /Whether in automated test mode, when in automated test mode, the default beauty will be turned off, the default NO
@property (nonatomic, assign, readonly) BOOL isAutoTest;
// {zh} / 需要开启的特效，每三个为一组，依次为 path、key、node {en} /Special effects that need to be turned on, every three are a group, followed by path, key, node
@property (nonatomic, strong) NSArray<BEComposerNodeModel *> *composerNodes;
// {zh} / 滤镜路径 {en} /Filter path
@property (nonatomic, strong) NSString *filterName;
// {zh} / 滤镜强度 {en} /Filter strength
@property (nonatomic, assign) CGFloat filterIntensity;

@end

#endif /* BEEffectConfig_h */
