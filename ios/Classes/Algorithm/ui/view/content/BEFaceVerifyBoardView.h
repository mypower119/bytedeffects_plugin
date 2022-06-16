//
//  BEFaceVerifyBoardView.h
//  Algorithm
//
//  Created by qun on 2021/6/1.
//

#ifndef BEFaceVerifyBoardView_h
#define BEFaceVerifyBoardView_h

#import <UIKit/UIKit.h>
#import "BETitleBoardView.h"

@class BEFaceVerifyBoardView;
@protocol BEFaceVerifyBoardViewDelegate <BETitleBoardViewDelegate>

- (void)faceVerifyView:(BEFaceVerifyBoardView *)view didTapClose:(UIView *)sender selected:(BOOL)selected;
- (void)faceVerifyView:(BEFaceVerifyBoardView *)view didTapImagePicker:(UIView *)sender;

@end

// {zh} / 人脸比对底部面板 {en} /Face comparison bottom panel
@interface BEFaceVerifyBoardView : UIView

@property (nonatomic, weak) id<BEFaceVerifyBoardViewDelegate> delegate;

- (void)setClosed:(BOOL)closed;

@end

#endif /* BEFaceVerifyBoardView_h */
