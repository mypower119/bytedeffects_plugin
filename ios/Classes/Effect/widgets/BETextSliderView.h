//
//  TextSliderView.h
//  oc_demo
//
//  Created by QunZhang on 2019/8/3.
//  Copyright © 2019 wuruoye. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat DEFAULT_LINE_HEIGHT = 3;
static const CGFloat DEFAULT_CIRCLE_RADIUS = 19;
static const CGFloat DEFAULT_TEXT_SIZE = 12;
static const CGFloat DEFAULT_PADDING_LEFT = 5;
static const CGFloat DEFAULT_PADDING_RIGHT = 5;
static const CGFloat DEFAULT_PADDING_BOTTOM = 10;
static const CGFloat DEFAULT_TEXT_OFFSET = 30;
static const NSInteger DEFAULT_ANIMATION_TIME = 200;

@class BETextSliderView;
/**   {zh} 
 * TextSliderView 进度改变的回调
 */
/**   {en} 
 * Callbacks for TextSliderView progress changes
 */
@protocol BETextSliderViewDelegate <NSObject>

/**   {zh} 
 进度回调方法

 @param progress 进度值，0～1
 */
/**   {en} 
 Progress callback method

 @param progress  progress value, 0~ 1
 */
- (void) progressDidChange:(BETextSliderView *)sender progress:(CGFloat)progress;

@end

/**   {zh} 
 * 能够动态显示当前进度值的 Slider
 */
/**   {en} 
 * Slider that can dynamically display the current progress value
 */
IB_DESIGNABLE
@interface BETextSliderView : UIView

//   {zh} / 进度回调     {en} /Progress callback 
@property(nonatomic, weak) IBInspectable id<BETextSliderViewDelegate> delegate;

//   {zh} / 激活状态的颜色     {en} /Color of active state 
@property(nonatomic, strong) IBInspectable UIColor *activeLineColor;
// {zh} / 非激活状态的颜色 {en} /Inactive color
@property(nonatomic, strong) IBInspectable UIColor *inactiveLineColor;
//   {zh} / 圆形颜色     {en} /Round color 
@property(nonatomic, strong) IBInspectable UIColor *circleColor;
//   {zh} / 文字颜色     {en} /Text color 
@property(nonatomic, strong) IBInspectable UIColor *textColor;

//   {zh} / 线的高度     {en} Height of line 
@property(nonatomic) IBInspectable CGFloat lineHeight;
//   {zh} / 圆形的默认半径     {en} /The default radius of the circle 
@property(nonatomic) IBInspectable CGFloat circleRadius;
//   {zh} / 文字的大小     {en} /Text size 
@property(nonatomic) IBInspectable CGFloat textSize;
//   {zh} / 文字的偏移量，即相对于线的高度     {en} /The offset of the text, that is, the height relative to the line 
@property(nonatomic) IBInspectable CGFloat textOffset;

//   {zh} / 左边距     {en} /Left distance 
@property(nonatomic) IBInspectable CGFloat paddingLeft;
//   {zh} / 右边距     {en} /Right distance 
@property(nonatomic) IBInspectable CGFloat paddingRight;
//   {zh} / 底边距     {en} /Bottom margin 
@property(nonatomic) IBInspectable CGFloat paddingBottom;

//   {zh} / 动画速度，值越大越慢     {en} /Animation speed, the larger the value, the slower it is 
@property(nonatomic) IBInspectable NSInteger animationTime;

//   {zh} / 进度，0～1     {en} /Progress, 0~ 1 
@property(nonatomic) CGFloat progress;

@property(nonatomic) BOOL negativeable;


@end
