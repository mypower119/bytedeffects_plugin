//
//  BEButtonView.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/13.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BEButtonView;
@protocol BEButtonViewDelegate <NSObject>

- (void)buttonViewDidTap:(BEButtonView *)view;

@end

// {zh} / 按钮 View，实现了一个有 icon、title 和标记点的 View {en} /Button View, which implements a View with icons, titles and markup points
@interface BEButtonView : UIView

@property (nonatomic, weak) id<BEButtonViewDelegate> delegate;
@property (nonatomic, assign) BOOL selected;

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg title:(NSString *)title expand:(BOOL)expand withPoint:(BOOL)withPoint;

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg;

- (void)setPointOn:(BOOL)isOn;

@end
