//
//  BEBaseFloatInfoVC.m
//  BytedEffects
//
//  Created by qun on 2020/9/18.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEBaseFloatInfoVC.h"
#import "BEPreviewSizeManager.h"

@interface BEBaseFloatInfoVC () {
    CGSize          _imageSize;
    int             _rotation;
}

@end

@implementation BEBaseFloatInfoVC

- (void)setImageSize:(CGSize)size rotation:(int)rotation {
    _imageSize = size;
    _rotation = rotation;
}

- (CGFloat)offsetX:(CGFloat)x {
    return [[BEPreviewSizeManager singletonInstance] previewToViewX:x];
}

- (CGFloat)offsetXWithRect:(bef_ai_rect)rect {
    int offset;
    switch (self.imageRotation) {
        case 90:
            offset = self.imageSize.width - rect.bottom;
            break;
        case 270:
            offset = rect.top;
            break;
        default:
            offset = rect.left;
    }
    return [self offsetX:offset];
}

- (CGFloat)offsetY:(CGFloat)y {
    return [BEPreviewSizeManager.singletonInstance previewToViewY:y];
}

- (CGFloat)offsetYWithRect:(bef_ai_rect)rect {
    int offset;
    switch (self.imageRotation) {
        case 90:
            offset = rect.left;
            break;
        case 270:
            offset = rect.right;
            break;
        case 180:
            offset = rect.bottom;
            break;
        default:
            offset = rect.top;
    }
    return [self offsetY:offset];
}

- (BOOL)isLandscape {
    return _rotation % 180 != 0;
}

- (CGSize)imageSize {
    return _imageSize;
}

- (int)imageRotation {
    return _rotation;
}

@end
