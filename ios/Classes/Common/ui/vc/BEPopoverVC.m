//
//  BEPopoverVC.m
//  Common
//
//  Created by qun on 2021/6/17.
//

#import "BEPopoverVC.h"
#import "BEPopoverView.h"

static double ANIMATION_TIME = 0.2;

@interface BEPopoverVC () <UIViewControllerTransitioningDelegate, BEPopoverViewDelegate>

@property (nonatomic, strong) BEPopoverView *popoverView;
@property (nonatomic, strong) BEPopoverManager *manager;

@end

@implementation BEPopoverVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.popoverView;
    self.view.alpha = 0.f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.view.alpha = 1.f;
        [self.view.superview setNeedsLayout];
    }];
}

- (void)setConfigs:(NSArray *)configs {
    self.manager.configs = configs;
}

- (void)setDelegate:(id<BEPopoverManagerDelegate>)delegate {
    self.manager.delegate = delegate;
}

#pragma mark - BEPopoverViewDelegate
- (void)popoverViewDidTouch:(BEPopoverView *)sender {
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.view.alpha = 0.f;
        [self.view.superview setNeedsLayout];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - getter
- (BEPopoverManager *)manager {
    if (_manager) {
        return _manager;
    }
    
    _manager = [[BEPopoverManager alloc] init];
    return _manager;
}

- (BEPopoverView *)popoverView {
    if (_popoverView) {
        return _popoverView;
    }
    
    _popoverView = [[BEPopoverView alloc] initWithFrame:self.view.frame
                                            contentView:self.manager.contentView
                                             sourceRect:self.anchorView.frame];
    _popoverView.delegate = self;
    _popoverView.backgroundColor = [UIColor clearColor];
    return _popoverView;
}

@end
