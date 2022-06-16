//
//  BESingleSwitchView.h
//  Common
//
//  Created by qun on 2021/6/6.
//

#ifndef BESingleSwitchView_h
#define BESingleSwitchView_h

#import <UIKit/UIKit.h>

@interface BESingleSwitchConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, copy) NSString *key;

- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn;
- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn key:(NSString *)key;

@end

@class BESingleSwitchView;
@protocol BESingleSwitchViewDelegate <NSObject>

- (void)switchView:(BESingleSwitchView *)view isOn:(BOOL)isOn;

@end

// {zh} / 实现一个单选的 view，主要用于 popover 中的设置，如是否开启性能展示 {en} /Implement a radio view, mainly used for settings in popover, such as whether to turn on performance display
@interface BESingleSwitchView : UIView

@property (nonatomic, weak) id<BESingleSwitchViewDelegate> delegate;
@property (nonatomic, strong) BESingleSwitchConfig *config;

@end

#endif /* BESingleSwitchView_h */
