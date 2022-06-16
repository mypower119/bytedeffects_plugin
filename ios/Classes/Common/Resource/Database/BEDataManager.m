//
//  BEDataManager.m
//  BECommon
//
//  Created by qun on 2021/10/20.
//

#import "BEDataManager.h"

@implementation BEDownloadResourceItem

+ (NSFetchRequest<BEDownloadResourceItem *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"DownloadResourceItem"];
}

@dynamic md5;
@dynamic name;
@dynamic path;

@end

@interface BEDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation BEDataManager

- (BEDownloadResourceItem *)downloadResourceItemWithName:(NSString *)name {
    __block BEDownloadResourceItem *item = nil;
    [self.context performBlockAndWait:^{
        NSFetchRequest *request = [BEDownloadResourceItem fetchRequest];
        [request setFetchLimit:1];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@", name]];
        
        NSError *error = nil;
        NSArray *array = [self.context executeFetchRequest:request error:&error];
        if (array == nil || array.count == 0) {
            return;
        }
        item = array[0];
    }];
    return item;
}

- (BOOL)addResourceItem:(NSString *)name path:(NSString *)path md5:(NSString *)md5 {
    __block BOOL result = NO;
    [self.context performBlockAndWait:^{
        BOOL removeRet = [self removeResourceItem:name];
        if (!removeRet) {
            NSLog(@"remove old resource item failed");
            result = NO;
            return;
        }
        
        BEDownloadResourceItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadResourceItem" inManagedObjectContext:self.context];
        item.name = name;
        item.path = path;
        item.md5 = md5;
        
        [self.context insertObject:item];
        
        result = [self.context save:nil];
    }];
    return result;
}

- (BOOL)removeResourceItem:(NSString *)name {
    __block BOOL result = NO;
    [self.context performBlockAndWait:^{
        BEDownloadResourceItem *item = [self downloadResourceItemWithName:name];
        if (item == nil) {
            result = YES;
            return;
        }
        
        [self.context deleteObject:item];
        
        result = [self.context save:nil];
    }];
    return result;
}

- (BOOL)clearResourceItem {
    __block BOOL result = NO;
    [self.context performBlockAndWait:^{
        NSFetchRequest *request = [BEDownloadResourceItem fetchRequest];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name != nil"]];
        
        NSError *error = nil;
        NSArray *array = [self.context executeFetchRequest:request error:&error];
        for (id obj in array) {
            [self.context deleteObject:obj];
        }
        
        [self.context save:&error];
        result = error == nil;
    }];
    return result;
}

#pragma mark - getter
- (NSManagedObjectContext *)context {
    if (_context == nil) {
        // 创建上下文对象，并发队列设置为主队列
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

        // 创建托管对象模型，并使用Student.momd路径当做初始化参数
        // .xcdatamodeld文件 编译之后变成.momd文件  （.mom文件）
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"Resource" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];

        // 创建持久化存储调度器
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

        // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *idMapPath = [dataPath stringByAppendingFormat:@"/%@.sqlite",@"Resource"];

        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:idMapPath] options:nil error:nil];

        // 上下文对象设置属性为持久化存储器
        _context.persistentStoreCoordinator = coordinator;
    }
    return _context;
}
@end
