//
//  BELocalVideoCapture.h
//  Common
//
//  Created by qun on 2021/5/17.
//

#ifndef BELocalVideoCapture_h
#define BELocalVideoCapture_h

#import "BEVideoSourceProvider.h"


@interface BELocalVideoCapture : NSObject <BEVideoSourceProtocol>

- (instancetype)initWithAsset:(AVAsset *)asset;

@end


@interface BEFormatedLocalVideoCapture: NSObject <BEVideoSourceProtocol>

//    {zh} 指定了屏幕捕获流的格式，支持rgba和420YpCbCr8BiPlanarFullRange        {en} Specifies the format of the screen capture stream, supports rgba and 420YpCbCr8BiPlanarFullRange  
- (instancetype)initWithAsset:(AVAsset *)asset imageFormat:(OSType)type;
- (void)resetVideo:(AVAsset *)asset;
- (void)localVideoStartRunning;

@end


#endif /* BELocalVideoCapture_h */
