//
//  BESportsAssistantClassItem.h
//  BEAlgorithm
//
//  Created by liqing on 2021/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BESportsAssistantClassItem : NSObject

@property(nonatomic,retain)NSString *key;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *image_path;
@property(nonatomic,assign)BOOL isLandscape;
@property(nonatomic,assign)int readyPoseType; //1:stand 2:lying 3:sitting
@property(nonatomic,retain)NSString *video_path;
@property(nonatomic,retain)NSString *tutor_wrong;
@property(nonatomic,retain)NSString *tutor_right;
@property(nonatomic,retain)NSString *finish_logo;

@end


NS_ASSUME_NONNULL_END
