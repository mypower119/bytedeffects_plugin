//
//  BEStudentIdOcrVC.h
//  BytedEffects
//
//  Created by qun on 2020/9/10.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BEStudentIdOcrVCDelegate <NSObject>

- (void)onItemClick;

@end

@interface BEStudentIdOcrVC : UIViewController

@property (nonatomic, weak) id<BEStudentIdOcrVCDelegate> delegate;

@end
