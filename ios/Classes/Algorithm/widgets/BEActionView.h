//
//  BEActionView.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/16.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>


/** {zh} 
 用于展示动作信息的 view
 内部使用 UICollectionView 展示列表
 */
/** {en} 
 A view for displaying action information
 Display list internally using UICollectionView
 */
@interface BEActionView : UIView

@property (nonatomic, strong) UIColor *highlightTextColor;
@property (nonatomic, strong) UIColor *normalTextColor;

/** {zh} 
 初始化函数

 @param titles 列表标签
 @param col 行数
 @param frame frame
 @return 实例
 */
/** {en} 
 Initialization function

 @param titles  list tag
 @param col  number of lines
 @param frame frame
 @return  instance
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles column:(NSInteger)col frame:(CGRect)frame;

/** {zh} 
 清空选择
 */
/** {en} 
 Clear selection
 */
- (void)clearSelect;

/** {zh} 
 设置选择项

 @param select 索引
 */
/** {en} 
 Set the selection

 @param select  index
 */
- (void)setSelect:(NSInteger)select;

@end
