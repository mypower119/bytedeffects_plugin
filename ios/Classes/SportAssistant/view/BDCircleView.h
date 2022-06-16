//
//  BDCircleView.h
//  NewComponent
//
//  Created by liqing on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDCircleViewConfigure : NSObject

/** 圆环线条宽度 */
@property (nonatomic, assign) CGFloat circleLineWidth;
/** 圆环的颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 是否是顺时针 默认是NO:逆时针 */
@property (nonatomic, assign) BOOL isClockwise;
/** 渐变色方向 起始坐标 */
@property (nonatomic, assign) CGPoint startPoint;
/** 渐变色方向 结束坐标 */
@property (nonatomic, assign) CGPoint endPoint;
/** 渐变色的颜色数组 */
@property (nonatomic, strong) NSArray *colorArr;
/** 每个颜色的起始位置数组 注:每个元素 0 <= item < 1 */
@property (nonatomic, strong) NSArray *colorSize;

//注意: colorArr.count 和 colorSize.count 必须相等
//不相等时,渐变色最终显示出来的样子和期望的会有差异

@end


@interface BDCircleView : UIView
/**
 创建含有圆环的实例View
 @param frame 尺寸
 @param configure 配置属性
 @return 圆环所在的View
 */
- (instancetype)initWithFrame:(CGRect)frame configure:(BDCircleViewConfigure *)configure;

/** 百分比 */
@property (nonatomic, assign) CGFloat progress;

-(void) setBgCircleColor:(UIColor*)color;



@end

@interface BDDrawCircleView : UIView


@end

NS_ASSUME_NONNULL_END
