//
//  BEPopoverVC.h
//  Common
//
//  Created by qun on 2021/6/17.
//

#ifndef BEPopoverVC_h
#define BEPopoverVC_h

#import <UIKit/UIKit.h>
#import "BEPopoverManager.h"

//   {zh} / 自定义的弹窗 ViewController     {en} /Custom pop-up ViewController 
@interface BEPopoverVC : UIViewController

@property (nonatomic, weak) id<BEPopoverManagerDelegate> delegate;
@property (nonatomic, strong) NSArray *configs;
@property (nonatomic, strong) UIView *anchorView;

@end

#endif /* BEPopoverVC_h */
