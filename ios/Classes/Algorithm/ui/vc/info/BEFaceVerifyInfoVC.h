//
//  BEFaceVerifyInfoVC.h
//  Algorithm
//
//  Created by qun on 2021/6/1.
//

#ifndef BEFaceVerifyInfoVC_h
#define BEFaceVerifyInfoVC_h

#import <UIKit/UIKit.h>

@interface BEFaceVerifyInfoVC : UIViewController

- (void)updateFaceVerifyInfo:(double)similarity time:(long)time;
- (void)clearFaceVerifyInfo;
- (void)setSelectedImage:(UIImage *)image;
- (void)setSelectedImageHidden:(BOOL)hidden;

@end

#endif /* BEFaceVerifyInfoVC_h */
