//
//  BEStudentIdOcrView.h
//  BytedEffects
//
//  Created by Bytedance on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#ifndef BEStudentIdOcrView_h
#define BEStudentIdOcrView_h

#import <UIKit/UIKit.h>

@protocol BEStudentIdOcrCloseDelegate <NSObject>
-(void) studentIdOcrClose;

@end

@interface BEStudentIdOcrView : UIView

@property(nonatomic, weak) id<BEStudentIdOcrCloseDelegate> delegate;

//  {zh} 设置被OCR的图片  {en} Set the OCR picture
- (void) studentIdOcrSetImage:(UIImage*) image;

//  {zh} 设置OCR图片及其结果，这里的image已经被画过框了，numbers代表了ocr的结果  {en} Set the OCR picture and its results, the image here has been framed, and the numbers represent the results of the ocr
- (void)setOcrResultImage:(UIImage *)image  numbers:(NSString*)numbers;
@end

#endif /* BEStudentIdOcrView_h */
