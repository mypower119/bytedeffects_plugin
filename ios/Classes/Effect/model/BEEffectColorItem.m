//
//  BEEffectColorItem.m
//  BEEffect
//
//  Created by qun on 2021/9/1.
//

#import "BEEffectColorItem.h"

@interface BEEffectColorItem ()

@end

@implementation BEEffectColorItem

@synthesize title = _title;

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color {
    self = [super init];
    if (self) {
        _title = title;
        _color = color;
        [color getRed:&_red green:&_green blue:&_blue alpha:&_alpha];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    self = [super init];
    if (self) {
        _title = title;
        _red = red;
        _green = green;
        _blue = blue;
        _color = [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
    }
    return self;
}

@end
