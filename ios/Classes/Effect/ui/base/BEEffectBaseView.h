//
//  BEEffectBaseView.h
//  Effect
//
//  Created by qun on 2021/5/25.
//

#ifndef BEEffectBaseView_h
#define BEEffectBaseView_h

#import <UIKit/UIKit.h>

@class BEEffectBaseView;
@protocol BEEffectBaseViewDelegate <NSObject>

- (void)effectBaseView:(BEEffectBaseView *)view onTouchDownCompare:(UIView *)sender;
- (void)effectBaseView:(BEEffectBaseView *)view onTouchUpCompare:(UIView *)sender;

@end

@interface BEEffectBaseView : UIView

@property (nonatomic, weak) id<BEEffectBaseViewDelegate> delegate;

- (instancetype)initWithButtomMargin:(int)bottomMargin;

- (void)updateShowCompare:(BOOL)showCompare;

- (void)updateButtomMargin:(int)bottomMargin delay:(NSTimeInterval)delay;

@end

#endif /* BEEffectBaseView_h */
