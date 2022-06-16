//
//  BELocalResource.m
//  BECommon
//
//  Created by qun on 2021/10/19.
//

#import "BELocalResource.h"

@interface BELocalResource ()

@end

@implementation BELocalResource

+ (instancetype)initWithPath:(NSString *)path {
    BELocalResource *resource = [[self alloc] init];
    resource.path = path;
    return resource;
}

- (BEResourceResult *)syncGetResource:(NSError *__autoreleasing *)error {
    return [BEResourceResult resultWithPath:self.path];
}

- (void)asyncGetResource {
    [self.delegate resource:self didSuccess:[BEResourceResult resultWithPath:self.path]];
}

- (void)cancel {
    NSLog(@"cancel in local resource");
}

@end
