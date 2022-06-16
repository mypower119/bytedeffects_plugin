//
//  BEPetFaceListViewController.h
//  BytedEffects
//
//  Created by QunZhang on 2019/8/15.
//  Copyright © 2019 ailab. All rights reserved.
//

#import "BEBaseFloatInfoVC.h"
#import "bef_effect_ai_pet_face.h"

/** {zh} 
 显示宠物脸属性的 vc
 */
/** {en} 
 Vc showing pet face attributes
 */
@interface BEPetFaceInfoVC : BEBaseFloatInfoVC

/** {zh} 
 更新宠物脸属性

 @param result 检测结果
 */
/** {en} 
 Update pet face properties

 @param result  detection results
 */
- (void)updateWithResult:(bef_ai_pet_face_result)result;

@end
