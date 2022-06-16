//
//  BEFilterViewCell.m
//  Effect
//
//  Created by qun on 2021/5/24.
//

#import "BEFilterViewCell.h"
#import "BEModernFilterPickerViewController.h"
#import "UIResponder+BEAdd.h"
#import "Masonry.h"

@interface BEEffecFiltersCollectionViewCell ()

@end

@implementation BEEffecFiltersCollectionViewCell

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self displayContentController:self.vc];
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

- (BEModernFilterPickerViewController *)vc {
    if (_vc == nil) {
        _vc = [BEModernFilterPickerViewController new];
    }
    return _vc;
}

@end
