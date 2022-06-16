//
//  BEFaceBeautyView.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/19.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEEffectItem.h"

@protocol BEFaceBeautyViewDelegate <NSObject>

@required
- (void)onItemSelect:(BEEffectItem *)item;
- (void)onItemClean:(BOOL)isHidden;

@end

@interface BEFaceBeautyView : UIView

- (void)setItem:(BEEffectItem *)item;

- (void)resetSelect;

- (void)cleanSelect;

- (void)hiddenColorListAdapter:(BOOL)isHidden;

@property (nonatomic, weak) id<BEFaceBeautyViewDelegate> delegate;

@property (nonatomic, strong) NSString *titleType;

@end
