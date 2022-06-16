// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import <Foundation/Foundation.h>
#import "BEEffectResponseModel.h"
#import "BEEffectItem.h"
#import "BEComposerNodeModel.h"
#import "BETextSwitchItemView.h"

typedef NS_ENUM(NSInteger, BEEffectType) {
    BEEffectTypeLite,
    BEEffectTypeLiteNotAsia,
    BEEffectTypeStandard,
    BEEffectTypeStandardNotAsia,
};


//   {zh} / 特效 dataManager     {en} /Effect dataManager 
@interface BEEffectDataManager : NSObject

//   {zh} / 特效类型     {en} /Effect type 
@property (nonatomic, readonly) BEEffectType effectType;

//   {zh} / 风格妆功能项     {en} /Style makeup function item 
@property (nonatomic, strong) NSArray<BETextSwitchItem *> *styleMakeupSwitchItems;

- (instancetype)initWithType:(BEEffectType)type;

//   {zh} / @brief 美颜 tab     {en} /@Brief beauty tab 
- (NSArray<BEEffectCategoryModel *> *)effectCategoryModelArray;

//   {zh} / @brief 口红 tab     {en} /@Brief lipstick tab
- (NSArray<BEEffectCategoryModel *> *)effectCategoryModelLipstickArray;

//   {zh} / @brief 染发 tab     {en} /@Brief hairColor tab
- (NSArray<BEEffectCategoryModel *> *)effectCategoryModelHairColorArray;

//   {zh} / @brief 滤镜列表     {en} /@brief filter list 
- (NSArray<BEFilterItem *> *)filterArray;

//   {zh} / @brief 根据 BEEffectNode 取 BEEffectItem     {en} /@Briefing Pick BEEffectItem by BEEffectNode 
/// @param type BEEffectNode
- (BEEffectItem *)buttonItem:(BEEffectNode)type;

// {zh} / @brief 根据 BEEffectNode 取默认值 {en} /@brief Default value based on BEEffectNode
/// @param ID BEEffectNode
- (NSMutableArray<NSNumber *> *)defaultIntensity:(BEEffectNode)ID;

//   {zh} / @brief 获取默认美颜     {en} /@Briefing Get Default Beauty 
- (NSArray<BEEffectItem *> *)buttonItemArrayWithDefaultIntensity;

//   {zh} / @brief 获取染发色值     {en} /@Briefing Get hair color value
//   {zh} / @param key 素材中的功能 key     {en} /@param key function key in the material
//   {zh} / @param color 色值    {en} /@param  Color value
- (NSDictionary *)hairDyeFullColor:(NSString *)key ItemColor:(BEEffectColorItem *)color;

//   {zh} / @brief 获取染发位置     {en} /@Briefing Get hair dyeing location
//   {zh} / @param key 素材中的功能 key     {en} /@param key function key in the material
- (NSInteger)hairDyeFullIndex:(NSString *)key;

@end
