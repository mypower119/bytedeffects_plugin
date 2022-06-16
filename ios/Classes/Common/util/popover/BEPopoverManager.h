//
//  BEPopoverManager.h
//  Common
//
//  Created by qun on 2021/6/7.
//

#ifndef BEPopoverManager_h
#define BEPopoverManager_h

#import "BESingleSwitchView.h"
#import "BESwitchItemView.h"

@class BEPopoverManager;
@protocol BEPopoverManagerDelegate <NSObject>

- (void)popover:(BEPopoverManager *)manager configDidChange:(NSObject *)config key:(NSString *)key;

@end

@interface BEPopoverManager : NSObject

@property (nonatomic, weak) id<BEPopoverManagerDelegate> delegate;
@property (nonatomic, strong) NSArray *configs;

@property (nonatomic, readonly) UIView *contentView;

@end

#endif /* BEPopoverManager_h */
