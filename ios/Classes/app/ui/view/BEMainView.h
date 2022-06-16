//
//  BEMainView.h
//  re
//
//  Created by qun on 2021/5/20.
//  Copyright © 2021 ailab. All rights reserved.
//

#ifndef BEMainView_h
#define BEMainView_h

#import <UIKit/UIKit.h>
#import "BEFeatureItem.h"
#import "BEMainCVAdapter.h"
#import "BETopBarView.h"

@protocol BEMainDelegate <BEMainCVDelegate, BETopBarViewDelegate>

- (void)didClickItem:(BEFeatureItem *)item;

@end

// {zh} / 主页 View {en} /Home View
@interface BEMainView : UIView

@property (nonatomic, weak) id<BEMainDelegate> delegate;
@property (nonatomic, strong) NSArray<BEFeatureGroup *> *featureItems;


@end

#endif /* BEMainView_h */
