//
//  BEButtonViewCell.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/13.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BEButtonViewCell : UICollectionViewCell

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg title:(NSString *)title expand:(BOOL)expand withPoint:(BOOL)withPoint;

- (void)setSelectImg:(UIImage *)selectImg unselectImg:(UIImage *)unselectImg;

- (void)setPointOn:(BOOL)isOn;
- (void)setUsedStatus:(BOOL) uesd;

@end
