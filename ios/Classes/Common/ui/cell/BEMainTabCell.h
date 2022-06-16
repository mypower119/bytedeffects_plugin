// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import "UICollectionViewCell+BEAdd.h"

NS_ASSUME_NONNULL_BEGIN

@interface BEMainTabCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *hightlightTextColor;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, assign) BOOL textScrollable;

- (void)renderWithTitle:(NSString *)title;
- (void)setTitleLabelFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
