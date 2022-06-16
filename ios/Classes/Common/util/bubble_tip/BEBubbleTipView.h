//
//  BEBubbleTipView.h
//  Common
//
//  Created by qun on 2021/6/6.
//

#ifndef BEBubbleTipView_h
#define BEBubbleTipView_h

#import <UIKit/UIkit.h>

@interface BEBubbleTipView : UIView

// {zh} / 展示的位置 {en} /Display location
@property (nonatomic, assign) NSInteger tipIndex;

//   {zh} / 展示结束时的回调，可能会被取消     {en} /Callback at the end of the show, may be cancelled 
@property (nonatomic, strong) dispatch_block_t completeBlock;

//   {zh} / completeBlock 是否已经被调用（已经被调用的 block 不能取消）     {en} /CompleteBlock has been called (block that has been called cannot be cancelled) 
@property (nonatomic, assign) BOOL blockInvoked;

// {zh} / 是否需要重新展示，即是否需要展示时的动画，默认 YES {en} /Whether you need to redisplay, that is, whether you need to display the animation when the default YES
@property (nonatomic, assign) BOOL needReshow;

- (void)update:(NSString *)title desc:(NSString *)desc;

@end

#endif /* BEBubbleTipView_h */
