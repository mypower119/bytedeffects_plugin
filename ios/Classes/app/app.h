//
//  re.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef re_h
#define re_h

#define BEColorWithARGBHex(hex) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:((hex&0xFF000000)>>24)/255.0]
#define BEColorWithRGBAHex(hex,alpha) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:alpha]
#define BEColorWithRGBHex(hex) [UIColor colorWithRed:((hex&0xFF0000)>>16)/255.0 green:((hex&0x00FF00)>>8)/255.0 blue:((hex&0x0000FF))/255.0 alpha:1]

#import "Core.h"


#endif /* re_h */
