//
//  BETextSwithItemView.h
//  Effect
//
//  Created by qun on 2021/5/26.
//

#ifndef BETextSwitchItemView_h
#define BETextSwitchItemView_h

#import <UIKit/UIKit.h>

@interface BETextSwitchItem : NSObject

+ (instancetype)initWithTitle:(NSString *)title pointColor:(UIColor *)pointColor highlightTextColor:(UIColor *)highlightTextColor normalTextColor:(UIColor *)normalTextColor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, strong) UIColor *highlightTextColor;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, assign) CGFloat minTextWidth;

@end

@class BETextSwitchItemView;
@protocol BETextSwitchItemViewDelegate <NSObject>

- (void)textSwitchItemView:(BETextSwitchItemView *)view didSelect:(BETextSwitchItem *)item;

@end

@interface BETextSwitchItemView : UIView

@property (nonatomic, weak) id<BETextSwitchItemViewDelegate> delegate;
@property (nonatomic, strong) BETextSwitchItem *item;
@property (nonatomic, assign) BOOL selected;

@end

#endif /* BETextSwithItemView_h */
