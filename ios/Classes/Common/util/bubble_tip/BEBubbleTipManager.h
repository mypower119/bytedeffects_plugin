//
//  BEBubbleTipManager.h
//  Common
//
//  Created by qun on 2021/6/6.
//

#ifndef BEBubbleTipManager_h
#define BEBubbleTipManager_h

#import <UIKit/UIKit.h>

@interface BEBubbleTipManager : NSObject

@property (nonatomic, strong) UIView *container;
@property (nonatomic, assign) int topMargin;

- (instancetype)initWithContainer:(UIView *)container topMargin:(int)topMargin;

- (void)showBubble:(NSString *)title desc:(NSString *)desc duration:(NSTimeInterval)duration;

@end

#endif /* BEBubbleTipManager_h */
