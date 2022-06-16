//
//  BEBaseInfoVC.h
//  BytedEffects
//
//  Created by qun on 2020/9/18.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bef_effect_ai_public_define.h"

@interface BEBaseFloatInfoVC : UIViewController

- (void)setImageSize:(CGSize)size rotation:(int)rotation;

- (CGFloat)offsetX:(CGFloat)x;
- (CGFloat)offsetY:(CGFloat)y;

- (CGFloat)offsetXWithRect:(bef_ai_rect)rect;
- (CGFloat)offsetYWithRect:(bef_ai_rect)rect;

- (BOOL)isLandscape;
- (CGSize)imageSize;
- (int)imageRotation;

@end
