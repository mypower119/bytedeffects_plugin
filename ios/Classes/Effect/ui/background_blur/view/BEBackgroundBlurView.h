//
//  BEBackgroundBlurView.h
//  Effect
//
//  Created by qun on 2021/5/27.
//

#ifndef BEBackgroundBlurView_h
#define BEBackgroundBlurView_h

#import <UIKit/UIKit.h>
#import "BETitleBoardView.h"
#import "BESelectableButton.h"

@class BEBackgroundBlurView;
@protocol BEBackgroundBlurViewDelegate <BETitleBoardViewDelegate>

- (void)BackgroundBlurView:(BEBackgroundBlurView *)view selected:(BOOL)selected;

@end

@interface BEBackgroundBlurView : UIView

@property (nonatomic, weak) id<BEBackgroundBlurViewDelegate> delegate;
@property (nonatomic, strong) BESelectableButton *bvBackgroundBlur;
@property (nonatomic, assign) BOOL effectOn;

@end

#endif /* BEBackgroundBlurView_h */
