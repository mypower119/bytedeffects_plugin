//
//  BDBalanceBar.h
//  NewComponent
//
//  Created by liqing on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDBalanceBarDelegate <NSObject>

- (void)balanceCompleted;

@end

@interface BDBalanceBar : UIView

@property (nonatomic,weak) id<BDBalanceBarDelegate> delegate;
- (void)destroy;
@end

NS_ASSUME_NONNULL_END
