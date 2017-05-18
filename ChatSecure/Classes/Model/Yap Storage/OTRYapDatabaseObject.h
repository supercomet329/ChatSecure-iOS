//
//  OTRYapDatabaseObject.h
//  Off the Record
//
//  Created by David Chiles on 3/28/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

@import Foundation;

@import YapDatabase;
@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@protocol OTRYapDatabaseObjectProtocol <NSObject, NSCoding, NSCopying>

@property (nonatomic, readonly) NSString *uniqueId;


- (void)saveWithTransaction:(nonnull YapDatabaseReadWriteTransaction *)transaction;
- (void)removeWithTransaction:(nonnull YapDatabaseReadWriteTransaction *)transaction;
/** This will fetch an updated instance of the object. If nil, it means it was deleted or not present in the db. */
- (nullable instancetype)refetchWithTransaction:(nonnull YapDatabaseReadWriteTransaction *)transaction;

@property (class, readonly) NSString *collection;

+ (nullable instancetype)fetchObjectWithUniqueID:(NSString*)uniqueID transaction:(YapDatabaseReadTransaction*)transaction;

@end

@interface OTRYapDatabaseObject : MTLModel <OTRYapDatabaseObjectProtocol>

- (instancetype)initWithUniqueId:(NSString *)uniqueId;

@end

NS_ASSUME_NONNULL_END
