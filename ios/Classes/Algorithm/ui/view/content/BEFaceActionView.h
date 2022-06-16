//
//  BEFaceActionView.h
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#ifndef BEFaceActionView_h
#define BEFaceActionView_h

#import <UIKit/UIKit.h>

// {zh} / 人脸检测结果，动作信息 {en} /Face detection results, action information
@interface BEFaceActionView: UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIColor *hightlightTextColor;
@property (nonatomic, strong) UIColor *normalTextColor;

- (void)setIndex:(NSInteger)index selected:(BOOL)selected;

@end

#endif /* BEFaceActionView_h */
