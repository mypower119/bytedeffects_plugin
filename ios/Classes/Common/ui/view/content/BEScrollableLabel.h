//
//  BEScrollableLabel.h
//  Common
//
//  Created by qun on 2021/7/7.
//

#ifndef BEScrollableLabel_h
#define BEScrollableLabel_h

#import <UIKit/UIKit.h>

@interface BEScrollableLabel : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL scrollable;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@end

#endif /* BEScrollableLabel_h */
