//
//  BEFaceInfoVC.h
//  Algorithm
//
//  Created by qun on 2021/5/28.
//

#ifndef BEFaceInfoVC_h
#define BEFaceInfoVC_h

#import <UIKit/UIKit.h>
#import "bef_effect_ai_face_detect.h"
#import "bef_effect_ai_face_attribute.h"

@interface BEFaceInfoVC : UIViewController

@property (nonatomic, assign) BOOL showAttrInfo;

- (void) updateFaceInfo:(bef_ai_face_106)info faceCount:(int)count;
- (void) updateFaceExtraInfo:(bef_ai_face_attribute_result *)attrInfo;

@end

#endif /* BEFaceInfoVC_h */
