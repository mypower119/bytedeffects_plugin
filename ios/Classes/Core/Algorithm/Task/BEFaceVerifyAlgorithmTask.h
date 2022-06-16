//
//  BEFaceVerifyAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"
#import "BEFaceAlgorithmTask.h"
#import "BEImageUtils.h"
#import "bef_effect_ai_face_verify.h"

@protocol BEFaceVerifyResourceProvider <BEAlgorithmResourceProvider, BEFaceResourceProvider>

- (const char *)faceVerifyModelPath;

@end

@interface BEFaceVerifyAlgorithmResult : NSObject

@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) bef_ai_face_verify_info *verifyInfo;
@property (nonatomic, assign) double similarity;
@property (nonatomic, assign) long costTime;

@end

@interface BEFaceVerifyAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)FACE_VERIFY;

- (int)setFaceVerifySourceFeature:(unsigned char *)buffer format:(BEFormatType)format width:(int)width height:(int)height bytesPerRow:(int)bytesPerRow;
- (void)resetVerify;
@end
