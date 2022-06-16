//
//  BEPopoverView.h
//  Common
//
//  Created by qun on 2021/6/17.
//

#ifndef BEPopoverView_h
#define BEPopoverView_h

#import <UIKit/UIKit.h>

@class BEPopoverView;
@protocol BEPopoverViewDelegate <NSObject>

- (void)popoverViewDidTouch:(BEPopoverView *)sender;

@end

@interface BEPopoverView : UIView

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView sourceRect:(CGRect)sourceRect;

@property (nonatomic, weak) id<BEPopoverViewDelegate> delegate;

@end

#endif /* BEPopoverView_h */
