//
//  BEFaceVerifyUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEFaceVerifyUI.h"
#import "BEFaceVerifyAlgorithmTask.h"
#import "BEFaceVerifyBoardView.h"
#import "BEFaceVerifyInfoVC.h"
#import "BEDeviceInfoHelper.h"
#import "Masonry.h"
#import "TZImagePickerController.h"
#import "UIView+Toast.h"
#import "CommonSize.h"

@interface BEFaceVerifyUI () <BEAlgorithmUIGenerator, BEFaceVerifyBoardViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) BEFaceVerifyInfoVC *vcInfo;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) BEFaceVerifyAlgorithmTask *task;
@property (nonatomic, strong) BEFaceVerifyBoardView *boardView;
@property (nonatomic, assign) BOOL closed;
@property (nonatomic, strong) BEImageUtils *imageUtils;
@property (nonatomic, assign) NSInteger faceCount;

@end

@implementation BEFaceVerifyUI

- (void)initView {
    self.closed = NO;
    self.faceCount = -1;
    [self onEvent:BEFaceVerifyAlgorithmTask.FACE_VERIFY flag:YES];
}

- (void)onEvent:(BEAlgorithmKey *)key flag:(BOOL)flag {
    [super onEvent:key flag:flag];

    CHECK_ARGS_AVAILABLE(1, self.provider, nil)
    if ([self.provider.algorithmTask isKindOfClass:[BEFaceVerifyAlgorithmTask class]]) {
        self.task = (BEFaceVerifyAlgorithmTask *)self.provider.algorithmTask;
    }
    
    [self.provider showOrHideVC:self.vcInfo show:flag];
    [self.vcInfo setSelectedImageHidden:!flag];
    if (!flag) {
        [self.vcInfo setSelectedImage:nil];
        [self.task resetVerify];
    }
}

- (void)onReceiveResult:(BEFaceVerifyAlgorithmResult *)result {
    if (result == nil) {
        return;
    }
    
    if (self.faceCount < 0) {
        
    } else if (self.faceCount == 1) {
        [self.vcInfo updateFaceVerifyInfo:result.similarity time:result.costTime];
    } else {
        [self.vcInfo clearFaceVerifyInfo];
    }
}

- (id<BEAlgorithmUIGenerator>)algorithmGenerator {
    return self;
}

#pragma mark - BEAlgorithmUIGenerator
- (BEAlgorithmKey *)key {
    return BEFaceVerifyAlgorithmTask.FACE_VERIFY;
}

- (NSString *)title {
    return @"tab_face_verify";
}

- (UIView *)createView {
    return self.boardView;
}

#pragma mark - BEFaceVerifyBoardViewDelegate
- (void)faceVerifyView:(BEFaceVerifyBoardView *)view didTapClose:(UIView *)sender selected:(BOOL)selected {
    self.closed = selected;
    [self onEvent:BEFaceVerifyAlgorithmTask.FACE_VERIFY flag:!selected];
}

- (void)faceVerifyView:(BEFaceVerifyBoardView *)view didTapImagePicker:(UIView *)sender {
    if (self.closed) {
        return;
    }
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    vc.autoDismiss = YES;
    vc.allowPickingVideo = NO;
    vc.allowPickingGif = NO;
    vc.allowPickingOriginalPhoto = NO;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.vcInfo presentViewController:vc animated:YES completion:nil];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    if ([self.provider respondsToSelector:@selector(boardBottomView:didTapClose:)]) {
        [self.provider performSelector:@selector(boardBottomView:didTapClose:) withObject:view withObject:sender];
    }
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    if ([self.provider respondsToSelector:@selector(boardBottomView:didTapRecord:)]) {
        [self.provider performSelector:@selector(boardBottomView:didTapRecord:) withObject:view withObject:sender];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (photos.count == 1) {
        if (isSelectOriginalPhoto) {
            [[TZImageManager manager] getOriginalPhotoWithAsset:assets[0] completion:^(UIImage *photo, NSDictionary *info) {
                if ([[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue]) return;
                [self didSelecteImage:photo];
            }];
        } else {
            [self didSelecteImage:photos[0]];
        }
    }
}
- (void)didSelecteImage:(UIImage *)image {
    [self.vcInfo setSelectedImage:image];
    [self.vcInfo updateFaceVerifyInfo:0.0 time:0];

    [self.provider addAlgorithmUIRunnable:^{
        int width = (int)CGImageGetWidth(image.CGImage);
        int height = (int)CGImageGetHeight(image.CGImage);
        int bytesPerRow = 4 * width;
        unsigned char *buffer = malloc(bytesPerRow * height);

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(buffer, width, height,
                                                     bitsPerComponent, bytesPerRow, colorSpace,
                                                     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

        CGColorSpaceRelease(colorSpace);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
        CGContextRelease(context);
        
        int faceCount = 0, detectCount = 0;
        while (faceCount == 0 && detectCount++ < 3) {
            faceCount = [self.task setFaceVerifySourceFeature:(unsigned char *)buffer format:BE_RGBA width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow];
        }
        
        self.faceCount = faceCount;
        
        free(buffer);
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (faceCount <= 0) {
                [self.provider.view makeToast:NSLocalizedString(@"no_face_detected", nil)];
            }else  if (faceCount > 1) {
                [self.provider.view makeToast:NSLocalizedString(@"face_more_than_one", nil)];
            }
        });
    }];
}

#pragma mark - getter
- (BEFaceVerifyInfoVC *)vcInfo {
    if (!_vcInfo) {
        _vcInfo = [[BEFaceVerifyInfoVC alloc] init];
    }
    return _vcInfo;
}

- (BEFaceVerifyBoardView *)boardView {
    if (_boardView) {
        return _boardView;
    }
    
    _boardView = [[BEFaceVerifyBoardView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT))];
    _boardView.delegate = self;
    return _boardView;
}

- (BEImageUtils *)imageUtils {
    if (_imageUtils == nil) {
        _imageUtils = [BEImageUtils new];
    }
    return _imageUtils;
}

@end
