//
//  NSPetFacePropertyView.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/15.
//  Copyright © 2019 ailab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bef_effect_ai_pet_face.h"

/** {zh} 
 用于展示宠物脸信息的 view
 */
/** {en} 
 A view for displaying pet face information
 */
@interface BEPetFacePropertyView : UIView

/** {zh} 
 设置宠物脸信息

 @param info 宠物脸信息
 */
/** {en} 
 Set pet face information

 @param info  pet face information
 */
- (void)setPetFaceInfo:(bef_ai_pet_face_info)info;

@end
