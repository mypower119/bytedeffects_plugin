//
//  BEBubbleTipManager.m
//  Common
//
//  Created by qun on 2021/6/6.
//

#import "BEBubbleTipManager.h"
#import "BEBubbleTipView.h"
#import "Masonry.h"

static const int TIP_HEIGHT = 40;
static const double ANIMATION_DURATION = 0.2;
static const int MAX_SHOWING_TIP = 1;

@interface BEBubbleTipManager ()

@property (nonatomic, strong) NSMutableArray<BEBubbleTipView *> *showingView;
@property (nonatomic, strong) NSMutableArray<BEBubbleTipView *> *cachedView;

@end

@implementation BEBubbleTipManager

- (instancetype)initWithContainer:(UIView *)container topMargin:(int)topMargin {
    self = [super init];
    if (self) {
        _container = container;
        _topMargin = topMargin;
        
        _showingView = [NSMutableArray array];
        _cachedView = [NSMutableArray array];
    }
    return self;
}

- (void)showBubble:(NSString *)title desc:(NSString *)desc duration:(NSTimeInterval)duration {
    BEBubbleTipView *view = [self be_getBubbleView];
    
    int tipIndex = [self be_getAvailableIndex];
    view.tipIndex = tipIndex;
    view.frame = [self be_getFrameWithIndex:tipIndex];
    
    [self be_updateBubble:view title:title desc:desc];
    
    [self be_show:view duration:duration];
}

#pragma mark - private
- (BEBubbleTipView *)be_getBubbleView {
    if (self.showingView.count >= MAX_SHOWING_TIP) {
        BEBubbleTipView *view = [self.showingView lastObject];
        [self.showingView removeLastObject];
        if (view != nil) {
            if (view.completeBlock != nil && !view.blockInvoked) {
                dispatch_block_cancel(view.completeBlock);
                view.needReshow = NO;
                return view;
            } else {
                //    {zh} 如果 block 已经被调用，它便无法被取消了，意味着 ANIMATION_DURATION        {en} If block has been called, it cannot be canceled, which means ANIMATION_DURATION  
                //  {zh} 时间之后这个 view 必然会被回收，所以只能重新找一个新的 view 来用了  {en} This view will inevitably be recycled after time, so we can only find a new view to use
                [view removeFromSuperview];
            }
        }
    }
    
    if (self.cachedView.count > 0) {
        BEBubbleTipView *view = self.cachedView.lastObject;
        [self.cachedView removeLastObject];
        view.needReshow = YES;
        return view;
    }
    
    return [BEBubbleTipView new];
}

- (void)be_recycleView:(BEBubbleTipView *)view {
    [view removeFromSuperview];
    view.completeBlock = nil;
    [self.showingView removeObject:view];
    [self.cachedView addObject:view];
}

- (int)be_getAvailableIndex {
    NSMutableSet<NSNumber *> *usingIndex = [NSMutableSet set];
    for (BEBubbleTipView *view in self.showingView) {
        [usingIndex addObject:[NSNumber numberWithInteger:view.tipIndex]];
    }
    
    int i = 0;
    for (; i < usingIndex.count; i++) {
        if (![usingIndex containsObject:[NSNumber numberWithInt:i]]) {
            break;
        }
    }
    
    return i;
}

- (CGRect)be_getFrameWithIndex:(int)index {
    int x = 0;
    int y = index * TIP_HEIGHT + self.topMargin;
    int width = self.container.frame.size.width;
    int height = TIP_HEIGHT;
    return CGRectMake(x, y, width, height);
}

- (void)be_updateBubble:(BEBubbleTipView *)view title:(NSString *)title desc:(NSString *)desc {
    [view update:title desc:desc];
}

- (void)be_show:(BEBubbleTipView *)view duration:(NSTimeInterval)duration {
    [self.container addSubview:view];
    [self.showingView insertObject:view atIndex:0];
    
    __weak BEBubbleTipView *weakV = view;
    
    if (view.needReshow) {
        view.alpha = 0.f;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            __strong UIView *strongV = weakV;
            if (strongV == nil) {
                return;
            }
            
            strongV.alpha = 1.f;
        }];
    }
    
    dispatch_block_t completeBlock = dispatch_block_create(0, ^{
        __strong BEBubbleTipView *strongV = weakV;
        if (strongV == nil) {
            return;
        }
        
        strongV.blockInvoked = YES;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            strongV.alpha = 0.f;
        } completion:^(BOOL finished) {
            __strong BEBubbleTipView *strongV = weakV;
            if (strongV == nil) {
                return;
            }
            
            [self be_recycleView:strongV];
        }];
    });
    view.completeBlock = completeBlock;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration - ANIMATION_DURATION) * NSEC_PER_SEC)), dispatch_get_main_queue(), completeBlock);
}

@end
