//
//  BERectangleSelectableView.h
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#ifndef BERectangleSelectableView_h
#define BERectangleSelectableView_h

#import "BEBaseSelectableView.h"

@class BERectangleSelectableView;
@interface BERectangleSelectableConfig : NSObject <BESelectableConfig>

+ (instancetype)initWithImageName:(NSString *)imageName imageSize:(CGSize)imageSize;

@property (nonatomic, copy) NSString *imageName;

- (BERectangleSelectableView *)generateView;

@end

/// @brief 方型可选中 View
@interface BERectangleSelectableView : BEBaseSelectableView

/// 图片 View
@property (nonatomic, strong) UIImageView *iv;

@end

#endif /* BERectangleSelectableView_h */
