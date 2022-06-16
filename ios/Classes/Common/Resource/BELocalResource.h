//
//  BELocalResource.h
//  BECommon
//
//  Created by qun on 2021/10/19.
//

#ifndef BELocalResourceItem_h
#define BELocalResourceItem_h

#import "BEBaseResource.h"

@interface BELocalResource : BEBaseResource

+ (instancetype)initWithPath:(NSString *)path;

@property (nonatomic, strong) NSString *path;

@end

#endif /* BELocalResourceItem_h */
