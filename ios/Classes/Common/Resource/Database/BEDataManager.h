//
//  BEDataManager.h
//  BECommon
//
//  Created by qun on 2021/10/20.
//

#ifndef BEDataManager_h
#define BEDataManager_h

#import <Foundation/Foundation.h>
#import <CoreData/Coredata.h>

@interface BEDownloadResourceItem : NSManagedObject

+ (NSFetchRequest<BEDownloadResourceItem *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *md5;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *path;

@end

@interface BEDataManager : NSObject

- (BEDownloadResourceItem *_Nullable)downloadResourceItemWithName:(NSString *)name;
- (BOOL)addResourceItem:(NSString *)name path:(NSString *)path md5:(NSString *)md5;
- (BOOL)removeResourceItem:(NSString *)name;

- (BOOL)clearResourceItem;

@end

#endif /* BEDataManager_h */
