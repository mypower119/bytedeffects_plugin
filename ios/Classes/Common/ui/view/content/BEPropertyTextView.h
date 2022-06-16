//
//  BETextView.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/17.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>

/** {zh} 
 显示一个属性的 view
 */
/** {en} 
 Show view of a property
 */
@interface BEPropertyTextView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;

@end
