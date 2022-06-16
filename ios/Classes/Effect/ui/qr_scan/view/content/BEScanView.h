//
//  BEScanView.h
//  Effect
//
//  Created by qun on 2021/6/3.
//

#ifndef BEScanView_h
#define BEScanView_h

#import <UIKit/UIKit.h>

@interface BEScanView : UIView

- (instancetype)initWithFrame:(CGRect)frame qrRect:(CGRect)rect;

- (void)startScan;
- (void)stopScan;

@end

#endif /* BEScanView_h */
