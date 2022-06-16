//
//  BEResourceManager.m
//  BECommon
//
//  Created by qun on 2021/10/21.
//

#import "BEResourceManager.h"
#import "BERemoteResource.h"

static const NSInteger MAX_LOADING_RESOURCE = 4;
static BEResourceManager *sInstance = nil;

@interface BEResourceManager () <BEResourceDelegate>

@property (nonatomic, strong) NSMapTable<BEBaseResource *, id<BEResourceDelegate>> *loadingResourceDelegates;
@property (nonatomic, strong) NSMutableArray<BEBaseResource *> *loadingResources;

@end

@implementation BEResourceManager

+ (BEResourceManager *)sInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [BEResourceManager new];
    });
    return sInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loadingResources = [NSMutableArray array];
        _loadingResourceDelegates = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

- (void)clearLoadingResource {
    @synchronized (self) {
        for (BERemoteResource *resource in self.loadingResources) {
            [resource cancel];
        }
        [self.loadingResources removeAllObjects];
        [self.loadingResourceDelegates removeAllObjects];
    }
}

- (void)clearCache {
    [[BEDownloadContext.sInstance dataManager] clearResourceItem];
}

- (BEResourceResult *)syncGetResource:(BEBaseResource *)resource error:(NSError *__autoreleasing *)error {
    [self be_prepareResource:resource];
    
    return [resource syncGetResource:error];
}

- (void)asyncGetResource:(BEBaseResource *)resource delegate:(id<BEResourceDelegate>)delegate {
    [self be_prepareResource:resource];
    BOOL addResult = [self addLoadingResource:resource delegate:delegate];
    if (!addResult) {
        // 正在下载中，无需再次下载
        return;
    }
    
    resource.delegate = self;
    [resource asyncGetResource];
}

#pragma mark - BEResourceDelegate
- (void)resource:(BEBaseResource *)resource didUpdateProgress:(NSProgress *)progress {
    if ([[self delegateForResource:resource] respondsToSelector:@selector(resource:didUpdateProgress:)]) {
        [[self delegateForResource:resource] resource:resource didUpdateProgress:progress];
    }
}

- (void)resourceDidStart:(BEBaseResource *)resource {
    if ([[self delegateForResource:resource] respondsToSelector:@selector(resourceDidStart:)]) {
        [[self delegateForResource:resource] resourceDidStart:resource];
    }
}

- (void)resource:(BEBaseResource *)resource didFail:(NSError *)error {
    id<BEResourceDelegate> delegate = [self delegateForResource:resource];
    [self removeLoadingResource:resource];
    [delegate resource:resource didFail:error];
}

- (void)resource:(BEBaseResource *)resource didSuccess:(BEResourceResult *)resourceResult {
    id<BEResourceDelegate> delegate = [self delegateForResource:resource];
    [self removeLoadingResource:resource];
    [delegate resource:resource didSuccess:resourceResult];
}

#pragma mark protected
- (BOOL)addLoadingResource:(BEBaseResource *)resource delegate:(id<BEResourceDelegate>)delegate {
    @synchronized (self) {
        if ([self.loadingResources containsObject:resource]) {
            return NO;
        }
        [self.loadingResources addObject:resource];
        [self.loadingResourceDelegates setObject:delegate forKey:resource];
        
        while (self.loadingResources.count > MAX_LOADING_RESOURCE) {
            BEBaseResource *resource = [self.loadingResources firstObject];
            [self.loadingResources removeObject:resource];
            [resource cancel];
        }
    }
    return YES;
}

- (void)removeLoadingResource:(BEBaseResource *)resource {
    @synchronized (self) {
        [self.loadingResources removeObject:resource];
        [self.loadingResourceDelegates removeObjectForKey:resource];
    }
}

- (id<BEResourceDelegate>)delegateForResource:(BEBaseResource *)resource {
    @synchronized (self) {
        return [self.loadingResourceDelegates objectForKey:resource];
    }
}

#pragma mark - private
- (void)be_prepareResource:(BEBaseResource *)resource {
    
}

@end
