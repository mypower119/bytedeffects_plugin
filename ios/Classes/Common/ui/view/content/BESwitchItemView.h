//
//  BESwitchItemView.h
//  Common
//
//  Created by qun on 2021/6/6.
//

#ifndef BESwitchItemView_h
#define BESwitchItemView_h

#import <UIKit/UIKit.h>

@interface BESwitchItemConfig : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *key;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items selectIndex:(NSInteger)index;
- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items selectIndex:(NSInteger)index key:(NSString *)key;

@end

@class BESwitchItemView;
@protocol BESwitchItemViewDelegate <NSObject>

- (void)switchItemView:(BESwitchItemView *)view didSelect:(NSInteger)index;

@end

// {zh} / 实现一个多选的 view，主要用于 popover 中的设置，如分辨率设置 {en} /Implement a multi-select view, mainly used for settings in popover, such as resolution settings
@interface BESwitchItemView : UIView

@property (nonatomic, weak) id<BESwitchItemViewDelegate> delegate;

@property (nonatomic, strong) BESwitchItemConfig *config;

@end

#endif /* BESwitchItemView_h */
