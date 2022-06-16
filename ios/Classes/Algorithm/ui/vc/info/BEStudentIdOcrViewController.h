//
//  BEStudentIdOcrViewController.h
//  BytedEffects
//
//  Created by Bytedance on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEStudentIdOcrViewController_h
#define BEStudentIdOcrViewController_h

#import <UIKit/UIKit.h>

@protocol BEStudentIdOcrFinishedDelegate <NSObject>

- (void) studentIdOcrFinish;

@end

@interface BEStudentIdOcrViewController : UIViewController

@property(nonatomic, weak) id<BEStudentIdOcrFinishedDelegate> delegate;

@end



#endif /* BEStudentIdOcrViewController_h */
