//
//  BEBeautyFaceCell.m
//  Effect
//
//  Created by qun on 2021/5/24.
//

#import "BEBeautyFaceCell.h"
#import "UIResponder+BEAdd.h"
#import "Masonry.h"

@interface BEEffectFaceBeautyViewCell ()

@end

@implementation BEEffectFaceBeautyViewCell

@synthesize vc = _vc;

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self displayContentController:self.vc];
}

- (void)onClose {
//    [self.vc onClose];
}

- (void)displayContentController:(UIViewController *)viewController {
    UIViewController *parent = [self be_topViewController];
    [parent addChildViewController:viewController];
    [self.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:parent];
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)hideContentController:(UIViewController*)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

#pragma mark - getter
- (BEFaceBeautyViewController *)vc {
    if (!_vc) {
        _vc = [BEFaceBeautyViewController new];
    }
    return _vc;
}

@end
