//
//  BETextSwithView.h
//  Effect
//
//  Created by qun on 2021/5/26.
//

#ifndef BETextSwitchView_h
#define BETextSwitchView_h

#import <UIKit/UIKit.h>
#import "BETextSwitchItemView.h"

@interface BETextSwitchView : UIView

@property (nonatomic, weak) id<BETextSwitchItemViewDelegate> delegate;
@property (nonatomic, strong) NSArray<BETextSwitchItem *> *items;
@property (nonatomic, strong) BETextSwitchItem *selectItem;

@end

#endif /* BETextSwithView_h */
