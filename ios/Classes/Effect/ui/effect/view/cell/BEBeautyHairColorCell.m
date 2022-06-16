//
//  BEBeautyHairColorCell.m
//  BEEffect
//
//  Created by bytedance on 2022/2/11.
//

#import "BEBeautyHairColorCell.h"
#import "UIResponder+BEAdd.h"
#import "Masonry.h"

@interface BEBeautyHairColorCell ()

@end

@implementation BEBeautyHairColorCell

@synthesize colorVc = _colorVc;

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self displayContentController:self.colorVc];
}

- (void)onClose {
//    [self.colorVc onClose];
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
- (BEColorFaceBeautyViewController *)colorVc {
    if (!_colorVc) {
        _colorVc = [BEColorFaceBeautyViewController new];
    }
    return _colorVc;
}


@end
