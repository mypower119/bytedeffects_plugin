//
//  BETextSizeUtils.m
//  BytedEffects
//
//  Created by qun on 2020/9/18.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BETextSizeUtils.h"

@implementation BETextSizeUtils

+ (CGFloat)calculateTextWidth:(NSString *)str size:(CGFloat)fontSize {
    return [str boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.width;
}

@end
