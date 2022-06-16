//
//  BEButtonItemModel.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEButtonItem.h"
#import "BEComposerNodeModel.h"
#import "BESelectableCell.h"
#import "BEEffectColorItem.h"

//   {zh} / Composer 功能项对应的按钮配置     {en} /Composer function item corresponding to the button configuration 
//   {zh} / 包括 UI 配置，UI 与数据的联动相关功能     {en} /Including UI configuration, UI and data linkage related functions 
@interface BEEffectItem : BEButtonItem

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model showIntensityBar:(BOOL)showIntensityBar;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle colorset:(NSArray *)colorset;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle colorset:(NSArray *)colorset type:(BEEffectTpye)type;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle showIntensityBar:(BOOL)showIntensityBar;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model tipTitle:(NSString *)tipTitle showIntensityBar:(BOOL)showIntensityBar type:(BEEffectTpye)type;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc model:(BEComposerNodeModel *)model enableNegative:(BOOL)enableNegative;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect colorset:(NSArray *)colorset;

+ (instancetype)initWithID:(BEEffectNode)ID selectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect showIntensityBar:(BOOL)showIntensityBar;

+ (instancetype)initWithId:(BEEffectNode)ID;

+ (instancetype)initWithId:(BEEffectNode)ID children:(NSArray<BEEffectItem *> *)children;

+ (instancetype)initWithId:(BEEffectNode)ID children:(NSArray<BEEffectItem *> *)children enableMultiSelect:(BOOL)enableMultiSelect;

// {zh} / @brief 更新 UI 状态 {en} /@brief update UI status
- (void)updateState;

// {zh} / @brief 重置 item （强度值、选择项等） {en} /@brief reset items (intensity values, selections, etc.)
- (void)reset;

@property (nonatomic, assign) BEEffectNode ID;

/// Get intensity from it self or it's child been selected
@property (nonatomic, assign, readonly) NSArray<NSNumber *> *validIntensity;
/// Whether it is a valid node, which should have valid ComposerNodeModel
//@property (nonatomic, assign, readonly) BOOL isAvailableItem;
@property (nonatomic, assign, readonly) BEEffectItem *availableItem;

// {zh} / 是否展示滑杆，默认 YES {en} /Whether to show the slider, default YES
@property (nonatomic, assign) BOOL showIntensityBar;

// {zh} / 特殊贴纸类型 {en} /Special sticker type
@property (nonatomic, assign) BEEffectTpye type;

#pragma mark Only for leaf item, maybe
@property (nonatomic, strong, readonly) BEComposerNodeModel *model;
// {zh} / 各小项强度值 {en} /Each item intensity value
@property (nonatomic, strong) NSMutableArray<NSNumber *> *intensityArray;
// {zh} / 父结点 {en} /Parent node
@property (nonatomic, assign) BEEffectItem *parent;
// {zh} / 是否允许双向调节，默认 NO {en} /Whether to allow two-way adjustment, default NO
@property (nonatomic, assign) BOOL enableNegative;
// {zh} / 颜色列表，如口红等支持自定义颜色功能项，默认 nil {en} /Color list, such as lipstick, etc. Support custom color function items, default nil
@property (nonatomic, strong) NSArray<BEEffectColorItem *> *colorset;
// {zh} / 当前项选择的颜色索引值，默认为 nil，表示没有选择 {en} /The color index value selected by the current item, the default is nil, indicating that there is no selection
@property (nonatomic, assign) BEEffectColorItem *selectedColor;

#pragma mark Only for parent item
/// all the children in this item, such as white, sharp, smooth in beauty face
@property (nonatomic, strong) NSArray<BEEffectItem *> *children;
// {zh} / 当前结点的所有子节点，包括子节点的所有子节点 {en} /All children of the current node, including all children of the child node
@property (nonatomic, readonly) NSArray<BEEffectItem *> *allChildren;
/// current selected child item in this item, such as smooth in beauty face
@property (nonatomic, assign) BEEffectItem *selectChild;
/// whether it's children can be multi-selected
@property (nonatomic, assign) BOOL enableMultiSelect;
/// whether all chidren use the same intensity, only used when enableMultiSelect is NO
@property (nonatomic, assign) BOOL reuseChildrenIntensity;

/// relative cell of this item, used to change ui when intensity changed
@property (nonatomic, weak) BESelectableCell *cell;

@end
