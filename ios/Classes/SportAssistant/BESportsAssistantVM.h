//
//  BESportsAssistantVM.h
//  BEAlgorithm
//
//  Created by liqing on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import "BESportsAssistantClassItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BESportsAssistantVM : NSObject

+ (BESportsAssistantVM *)instance;
@property (nonatomic, retain) NSMutableArray<BESportsAssistantClassItem*> *classArray;
@property (nonatomic, assign) int classIndex;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int second;

@end

NS_ASSUME_NONNULL_END
