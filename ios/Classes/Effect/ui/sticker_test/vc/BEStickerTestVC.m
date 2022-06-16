//
//  BEStickerTestVC.m
//  BEEffect
//
//  Created by qun on 2021/12/20.
//

#import "BEStickerTestVC.h"
#import "BERemoteResource.h"
#import "BEResourceManager.h"
#import "UIView+Toast.h"

@interface BEStickerTestVC () <BEResourceDelegate>

@property (nonatomic, strong) UIAlertController *acInput;
@property (nonatomic, strong) UIAlertController *acProgress;
@property (nonatomic, strong) BEResourceManager *resourceManager;

@end

@implementation BEStickerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resourceManager = [BEResourceManager sInstance];
    
    [self presentViewController:self.acInput animated:YES completion:nil];
}

- (void)requestSticker:(NSString *)name {
    if (name.length <= 4 || ! [[name substringFromIndex:(name.length - 4)] isEqualToString:@".zip"]) {
        name = [name stringByAppendingString:@".zip"];
    }
    
    BERemoteResource *resource = [[BERemoteResource alloc] init];
    resource.name = name;
    resource.url = [@"http://sticker-distribution.bytedance.net/material/download?filename=" stringByAppendingString:name];
    resource.needCheckMd5 = NO;
    resource.needCache = NO;
    resource.useCache = NO;
    
    [self.resourceManager asyncGetResource:resource delegate:self];
}

#pragma mark - BEResourceDelegate
- (void)resourceDidStart:(BEBaseResource *)resource {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:self.acProgress animated:YES completion:nil];
    });
}

- (void)resource:(BEBaseResource *)resource didSuccess:(BEResourceResult *)resourceResult {
    [self.manager setStickerAbsolutePath:resourceResult.path];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.acProgress dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)resource:(BEBaseResource *)resource didUpdateProgress:(NSProgress *)progress {
    CGFloat fProgress = progress.fractionCompleted * 100;
    self.acProgress.message = [[NSString stringWithFormat:@"%.0f", fProgress] stringByAppendingString:@"%"];
}

- (void)resource:(BEBaseResource *)resource didFail:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.acProgress dismissViewControllerAnimated:YES completion:nil];
        [self.view makeToast:error.localizedDescription];
    });
}

#pragma mark - getter
- (UIAlertController *)acProgress {
    if (_acProgress) {
        return _acProgress;
    }
    
    _acProgress = [UIAlertController
                        alertControllerWithTitle:NSLocalizedString(@"resource_download_progress", nil)
                        message:@""
                        preferredStyle:UIAlertControllerStyleAlert];
    return _acProgress;
}

- (UIAlertController *)acInput {
    if (_acInput) {
        return _acInput;
    }
    
    _acInput = [UIAlertController
           alertControllerWithTitle:@"输入贴纸名"
           message:nil
           preferredStyle:UIAlertControllerStyleAlert];
    [_acInput addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    __weak typeof(self) weakSelf = self;
    [_acInput addAction:[UIAlertAction
                                actionWithTitle:@"确认"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) return;
        
        [strongSelf requestSticker:strongSelf.acInput.textFields.firstObject.text];
    }]];
    [_acInput addAction:[UIAlertAction
                                actionWithTitle:@"取消"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf baseView:nil didTapBack:nil];
    }]];
    return _acInput;
}

@end
