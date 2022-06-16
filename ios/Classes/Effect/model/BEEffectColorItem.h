//
//  BEEffectColorItem.h
//  BEEffect
//
//  Created by qun on 2021/9/1.
//

#ifndef BEEffectColorItem_h
#define BEEffectColorItem_h

#import <UIKit/UIKit.h>

@interface BEEffectColorItem : NSObject

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color;
- (instancetype)initWithTitle:(NSString *)title red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alpha;

@end

#endif /* BEEffectColorItem_h */
