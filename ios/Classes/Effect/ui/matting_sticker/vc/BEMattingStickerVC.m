//
//  BEMattingStickerVC.m
//  Effect
//
//  Created by qun on 2021/5/27.
//

#import "BEMattingStickerVC.h"
#import "BEMattingStickerView.h"
#import "BEDeviceInfoHelper.h"
#import "TZImagePickerController.h"
#import "Common.h"

static NSString *RENDER_CACHE_TEXTURE_KEY = @"BCCustomBackground";
static NSString *MATTING_STICKER_PATH = @"matting_bg";
static NSString *DEFAULT_RENDER_CACHE_TEXTURE_PATH = @"/GE/generalEffect/resource1/background.png";

@interface BEMattingStickerVC () <BEMattingStickerViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) BEMattingStickerView *mattingStickerView;
@property (nonatomic, strong) UIImage *renderCacheImage;
@property (nonatomic, strong) TZImagePickerController *imagePickerController;

@end

@implementation BEMattingStickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (int)initSDK {
    int ret = [super initSDK];
    
    [self setDefaultMatting];
    return ret;
}

- (void)setDefaultMatting {
    //  {zh} 设置素材  {en} Set material
    [self.manager setStickerPath:MATTING_STICKER_PATH];
    //  {zh} 设置默认背景  {en} Set default background
    [self.manager setRenderCacheTexture:RENDER_CACHE_TEXTURE_KEY path:[[self.manager.provider stickerPath:MATTING_STICKER_PATH] stringByAppendingString:DEFAULT_RENDER_CACHE_TEXTURE_PATH]];
}

- (void)resetRenderCacheWithImage:(UIImage *)image {
    self.renderCacheImage = image;
    
    BEBuffer *buffer = [self.imageUtils transforUIImageToBEBuffer:image];
    [self.manager setRenderCacheTexture:RENDER_CACHE_TEXTURE_KEY buffer:buffer];
}

#pragma mark - BEMattingStickerViewDelegate
- (void)mattingStickerView:(BEMattingStickerView *)view didTapClose:(UIView *)sender selected:(BOOL)selected {
    if (!selected) {
        [self setDefaultMatting];
    } else {
        [self.manager setStickerPath:@""];
    }
}

- (void)mattingStickerView:(BEMattingStickerView *)view didTapUplaod:(UIView *)sender selected:(BOOL)selected {
    if (selected) {
        return;
    }
    
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    vc.autoDismiss = YES;
    vc.allowPickingVideo = NO;
    vc.allowPickingGif = NO;
    vc.allowPickingOriginalPhoto = NO;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    self.imagePickerController = vc;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - BEBoardBottomDelegate
- (void)boardBottomView:(BEBoardBottomView *)view didTapRecord:(UIView *)sender {
    [self baseView:nil didTapRecord:nil];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapClose:(UIView *)sender {
    [self hideBottomView:self.mattingStickerView showBoard:YES];
}

- (void)boardBottomView:(BEBoardBottomView *)view didTapReset:(UIView *)sender {
    [self.manager setRenderCacheTexture:RENDER_CACHE_TEXTURE_KEY path:[[self.manager.provider stickerPath:MATTING_STICKER_PATH] stringByAppendingString:DEFAULT_RENDER_CACHE_TEXTURE_PATH]];
}

#pragma mark - BEBaseViewDelegate
- (void)baseView:(BEBaseBarView *)view didTapOpen:(UIView *)sender {
    [self showBottomView:self.mattingStickerView target:self.view];
}

- (void)baseView:(BEBaseBarView *)view didTapReset:(UIView *)sender {
    [self.manager setRenderCacheTexture:RENDER_CACHE_TEXTURE_KEY path:[[self.manager.provider stickerPath:MATTING_STICKER_PATH] stringByAppendingString:DEFAULT_RENDER_CACHE_TEXTURE_PATH]];
}

- (void)baseViewDidTouch:(BEBaseBarView *)view {
    if (self.mattingStickerView.superview != nil) {
        [self hideBottomView:self.mattingStickerView showBoard:YES];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.imagePickerController == picker) {
        if (photos.count == 1) {
            if (isSelectOriginalPhoto) {
                [[TZImageManager manager] getOriginalPhotoWithAsset:assets[0] completion:^(UIImage *photo, NSDictionary *info) {
                    if ([[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue]) return;
                    [self resetRenderCacheWithImage:photo];
                }];
            } else {
                [self resetRenderCacheWithImage:photos[0]];
            }
        }
        return;
    }
    
    if ([super respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [super imagePickerController:picker didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto];
    }
}

#pragma mark - getter
- (BEMattingStickerView *)mattingStickerView {
    if (_mattingStickerView) {
        return _mattingStickerView;
    }
    
    _mattingStickerView = [[BEMattingStickerView alloc] initWithFrame:CGRectMake(0, 0, 0, BEF_DESIGN_SIZE(BEF_BOARD_HEIGHT))];
    _mattingStickerView.delegate = self;
    return _mattingStickerView;
}

@end
