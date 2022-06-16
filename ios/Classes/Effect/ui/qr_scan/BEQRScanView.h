//
//  BEQRScanView.h
//  Effect
//
//  Created by qun on 2021/6/3.
//

#ifndef BEQRScanView_h
#define BEQRScanView_h

#import <UIKit/UIKit.h>
#import "BETextSliderView.h"

@class BEQRScanView;
@protocol BEQRScanViewDelegate <BETextSliderViewDelegate>

- (void)qrScanView:(BEQRScanView *)view didTapBack:(UIView *)sender;

@end

@interface BEQRScanView : UIView

@property (nonatomic, weak) id<BEQRScanViewDelegate> delegate;

- (void)hideQRView:(BOOL)hidden;
- (void)hideSliderView:(BOOL)hidden defaultProgress:(CGFloat)progress;

@end

#endif /* BEQRScanView_h */
