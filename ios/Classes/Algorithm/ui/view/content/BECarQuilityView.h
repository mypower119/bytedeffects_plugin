//
//  BECarQuilityView.h
//  BytedEffects
//
//  Created by qun on 2020/9/6.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>

// {zh} / 车辆-画面质量检测结果展示 {en} /Vehicle-picture quality inspection result display
@interface BECarQuilityView : UIView

- (void)updateQuility:(BOOL)gray blur:(BOOL)blur;

@end
