//
//  BEFaceClusterUI.m
//  BytedEffects
//
//  Created by qun on 2020/8/24.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEFaceClusterUI.h"
#import "BEFaceClusterAlgorithmTask.h"
#import "BEFaceClusterBoardView.h"
#import "UIResponder+BEAdd.h"
#import "BEDeviceInfoHelper.h"
#import "TZImagePickerController.h"
#import "Common.h"

@interface BEFaceClusterUI () <BEAlgorithmUIGenerator, BEFaceClusterBoardViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) BEFaceClusterBoardView *boardView;
@property (nonatomic, weak) BEFaceClusterAlgorithmTask *task;

@end

@implementation BEFaceClusterUI

- (void)initView {
    self.task = (BEFaceClusterAlgorithmTask *)self.provider.algorithmTask;
}

- (id<BEAlgorithmUIGenerator>)algorithmGenerator {
    return self;
}

#pragma mark - BEAlgorithmUIGenerator
- (BEAlgorithmKey *)key {
    return BEFaceClusterAlgorithmTask.FACE_CLUSTER;
}

- (NSString *)title {
    return @"tab_face_clustering";
}

- (UIView *)createView {
    return self.boardView;
}

#pragma mark - BETitleBoardViewDelegate
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

#pragma mark - BEFaceClusteringViewDelegate
- (void)didStartCluster:(NSArray *)images {
    [self.provider addAlgorithmUIRunnable:^{
        NSMutableDictionary *dict = [self.task faceClusterImages:images];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.boardView.clusteringView configuraClusteringResult:dict];
        });
    }];
}

-(void)faceClusteringDidSelectedOpenAlbum {
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    vc.autoDismiss = YES;
    vc.allowPickingVideo = NO;
    vc.allowPickingGif = NO;
    vc.allowPickingOriginalPhoto = NO;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.boardView.be_topViewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.boardView.clusteringView configuraClusteringWithImages:photos];
}

#pragma mark - getter
- (BEFaceClusterBoardView *)boardView {
    if (_boardView) {
        return _boardView;
    }
    
    _boardView = [[BEFaceClusterBoardView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_FACE_CLUSTER_BOARD_HEIGHT))];
    _boardView.delegate = self;
    return _boardView;
}

@end
