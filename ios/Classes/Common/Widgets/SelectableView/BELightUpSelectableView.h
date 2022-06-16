//
//  BELightUpSelectableView.h
//  BECommon
//
//  Created by qun on 2021/12/9.
//

#ifndef BELightUpSelectableView_h
#define BELightUpSelectableView_h

#import "BEBaseSelectableView.h"

@class BELightUpSelectableView;
@interface BELightUpSelectableConfig : NSObject <BESelectableConfig>

+ (instancetype)initWithUnselectImage:(NSString *)unselectImage imageSize:(CGSize)imageSize;

//@property (nonatomic, copy) NSString *selectedImageName;
@property (nonatomic, copy) NSString *unselectedImageName;

- (BELightUpSelectableView *)generateView;

@end

/// @brief 点亮型可选中 View
@interface BELightUpSelectableView : BEBaseSelectableView

/// 点亮状态图片
//@property (nonatomic, copy) NSString *selectedImageName;

/// 未点亮状态图片
@property (nonatomic, copy) NSString *unselectedImageName;

@end

#endif /* BELightUpSelectableView_h */
