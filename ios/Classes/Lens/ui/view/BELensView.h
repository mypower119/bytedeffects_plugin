//
//  BELensView.h
//  Lens
//
//  Created by wangliu on 2021/6/2.
//

#ifndef BELensView_h
#define BELensView_h

#import <UIKit/UIKit.h>
#import "BETitleBoardView.h"
#import "BESelectableButton.h"
#import "BEButtonItem.h"
#import "BELensType.h"

@class BELensView;
@protocol BELensViewDelegate <BETitleBoardViewDelegate, BESelectableButtonDelegate>

@end

// {zh} / 画质页面 View {en} /Image Quality Page View
@interface BELensView : UIView

@property (nonatomic, weak) id<BELensViewDelegate> delegate;
@property (nonatomic, strong) BEButtonItem *item;
@property (nonatomic, assign) BOOL isOpen;

@end


#endif /* BELensView_h */
