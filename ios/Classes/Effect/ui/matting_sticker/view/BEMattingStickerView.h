//
//  BEMattingStickerView.h
//  Effect
//
//  Created by qun on 2021/5/27.
//

#ifndef BEMattingStickerView_h
#define BEMattingStickerView_h

#import <UIKit/UIKit.h>
#import "BETitleBoardView.h"

@class BEMattingStickerView;
@protocol BEMattingStickerViewDelegate <BETitleBoardViewDelegate>

- (void)mattingStickerView:(BEMattingStickerView *)view didTapClose:(UIView *)sender selected:(BOOL)selected;
- (void)mattingStickerView:(BEMattingStickerView *)view didTapUplaod:(UIView *)sender selected:(BOOL)selected;

@end

@interface BEMattingStickerView : UIView

@property (nonatomic, weak) id<BEMattingStickerViewDelegate> delegate;

@end

#endif /* BEMattingStickerView_h */
