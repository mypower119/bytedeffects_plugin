//
//  BELensVC.h
//  Lens
//
//  Created by wangliu on 2021/6/2.
//

#ifndef BELensVC_h
#define BELensVC_h

#import "BEBaseBarVC.h"
#import "BELensConfig.h"

@interface BELensVC : BEBaseBarVC

//   {zh} / 画质页面 ViewController     {en} /Image Quality Page ViewController 
@property (nonatomic, strong) BELensConfig *lensConfig;

@end

#endif /* BELensVC_h */
