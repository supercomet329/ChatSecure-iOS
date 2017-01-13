//
//  OTRYapDatabaseRosterStorage.m
//  Off the Record
//
//  Created by David Chiles on 3/31/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRYapDatabaseRosterStorage.h"

@import YapDatabase;
#import "OTRDatabaseManager.h"
#import "OTRLog.h"
#import "OTRXMPPBuddy.h"
#import "OTRXMPPAccount.h"

#import "OTRBuddyCache.h"

@import OTRAssets;

@interface OTRYapDatabaseRosterStorage ()

@property (nonatomic, strong, readonly, nonnull) YapDatabaseConnection *databaseConnection;

@end

@implementation OTRYapDatabaseRosterStorage

-(instancetype)init
{
    if (self = [super init]) {
        _databaseConnection = [OTRDatabaseManager sharedInstance].readWriteDatabaseConnection;
    }
    return self;
}

#pragma - mark Helper Methods

/** Turns out buddies are created during account creation before the account object is saved to the database. oh brother */
- (nonnull NSString*)accountUniqueIdForStream:(XMPPStream*)stream {
    NSParameterAssert(stream.tag);
    return stream.tag;
}

- (nullable OTRXMPPBuddy *)fetchBuddyWithJID:(XMPPJID *)jid stream:(XMPPStream *)stream transaction:(YapDatabaseReadTransaction *)transaction
{
    NSString *accountUniqueId = [self accountUniqueIdForStream:stream];
    OTRXMPPBuddy *buddy = [OTRXMPPBuddy fetchBuddyWithUsername:[jid bare] withAccountUniqueId:accountUniqueId transaction:transaction];
    return buddy;
}

/** When created, it is still unsaved and must be manually saved within a yap transaction. */
- (nullable OTRXMPPBuddy *)createBuddyWithJID:(XMPPJID *)jid stream:(XMPPStream *)stream {
    NSString *accountUniqueId = [self accountUniqueIdForStream:stream];
    OTRXMPPBuddy *buddy = [[OTRXMPPBuddy alloc] init];
    buddy.username = [jid bare];
    buddy.accountUniqueId = accountUniqueId;
    return buddy;
}

- (nullable OTRXMPPBuddy*) createBuddyFromRosterItem:(NSXMLElement *)rosterItem stream:(XMPPStream *)stream {
    NSString *jidStr = [rosterItem attributeStringValueForName:@"jid"];
    XMPPJID *jid = [[XMPPJID jidWithString:jidStr] bareJID];
    return [self createBuddyWithJID:jid stream:stream];
}


/** Compares two buddy objects to see if there are changes worth saving */
- (BOOL) shouldSaveUpdatedBuddy:(nonnull OTRXMPPBuddy*)buddy oldBuddy:(nullable OTRXMPPBuddy*)oldBuddy {
    NSParameterAssert(buddy);
    if (!buddy) { return NO; }
    if (!oldBuddy) { return YES; }
    NSAssert(buddy.uniqueId == oldBuddy.uniqueId, @"Comparing two different buddies! Noooooooo.");
    if (buddy.uniqueId != oldBuddy.uniqueId) {
        // I guess we should still save if the uniqueId is different
        return YES;
    }
    if (![buddy.displayName isEqualToString:oldBuddy.displayName]) {
        return YES;
    }
    if (buddy.pendingApproval != oldBuddy.pendingApproval) {
        return YES;
    }
    return NO;
}

- (BOOL)existsBuddyWithJID:(XMPPJID *)jid xmppStram:(XMPPStream *)stream
{
    __block BOOL result = NO;
    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        OTRXMPPAccount *account = [OTRXMPPAccount accountForStream:stream transaction:transaction];
        OTRBuddy *buddy = [OTRXMPPBuddy fetchBuddyWithUsername:[jid bare] withAccountUniqueId:account.uniqueId transaction:transaction];
        
        if (buddy) {
            result = YES;
        }
    }];
    return result;
}

-(BOOL)isPendingApprovalElement:(NSXMLElement *)item
{
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
	NSString *ask = [item attributeStringValueForName:@"ask"];
	
	if ([subscription isEqualToString:@"none"] || [subscription isEqualToString:@"from"])
    {
        if([ask isEqualToString:@"subscribe"])
        {
            return YES;
        }
    }
    return NO;
}

/** Buddy can be nil, which indicates a new buddy should be saved. */
- (void)updateBuddy:(nullable OTRXMPPBuddy *)buddy withItem:(nonnull NSXMLElement *)item stream:(XMPPStream*)stream
{
    if (!item) { return; }
    BOOL newlyCreatedBuddy = NO;
    if (!buddy) {
        buddy = [self createBuddyFromRosterItem:item stream:stream];
        if (!buddy) {
            return;
        }
        newlyCreatedBuddy = YES;
    }
    // Fixing a potential migration issue from ages past. Maybe can be removed?
    if (![buddy isKindOfClass:[OTRXMPPBuddy class]]) {
        OTRXMPPBuddy *xmppBuddy = [[OTRXMPPBuddy alloc] init];
        [xmppBuddy mergeValuesForKeysFromModel:buddy];
        buddy = xmppBuddy;
        newlyCreatedBuddy = YES;
    }
    OTRXMPPBuddy *newBuddy = [buddy copy];
    
    
    NSString *name = [item attributeStringValueForName:@"name"];
    if (name.length) {
        newBuddy.displayName = name;
    }
    if ([self isPendingApprovalElement:item]) {
        newBuddy.pendingApproval = YES;
    }
    else {
        newBuddy.pendingApproval = NO;
    }
    // Save if there were changes, or it's a new buddy
    BOOL shouldSave = [self shouldSaveUpdatedBuddy:newBuddy oldBuddy:buddy] || newlyCreatedBuddy;
    if (!shouldSave) {
        return;
    }
    
    [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [newBuddy saveWithTransaction:transaction];
    }];
}

#pragma - mark XMPPRosterStorage Methods

- (BOOL)configureWithParent:(XMPPRoster *)aParent queue:(dispatch_queue_t)queue
{
    return YES;
}

- (void)beginRosterPopulationForXMPPStream:(XMPPStream *)stream withVersion:(NSString *)version
{
    DDLogVerbose(@"%@ - %@",THIS_FILE,THIS_METHOD);
}
- (void)endRosterPopulationForXMPPStream:(XMPPStream *)stream
{
    DDLogVerbose(@"%@ - %@",THIS_FILE,THIS_METHOD);
}

- (void)handleRosterItem:(NSXMLElement *)item xmppStream:(XMPPStream *)stream
{
    NSString *jidStr = [item attributeStringValueForName:@"jid"];
    XMPPJID *jid = [[XMPPJID jidWithString:jidStr] bareJID];
    
    if([[jid bare] isEqualToString:[[stream myJID] bare]])
    {
        // ignore self buddy
        return;
    }
    
    __block OTRXMPPBuddy *buddy = nil;
    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        buddy = [self fetchBuddyWithJID:jid stream:stream transaction:transaction];
    }];
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    if (buddy && [subscription isEqualToString:@"remove"])
    {
        [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction removeObjectForKey:buddy.uniqueId inCollection:[OTRXMPPBuddy collection]];
        }];
    } else {
        [self updateBuddy:buddy withItem:item stream:stream];
    }
}

- (void)handlePresence:(XMPPPresence *)presence xmppStream:(XMPPStream *)stream
{
    __block OTRXMPPBuddy *buddy = nil;
    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        buddy = [self fetchBuddyWithJID:[presence from] stream:stream transaction:transaction];
    }];
    BOOL newlyCreatedBuddy = NO;
    if (!buddy) {
        buddy = [self createBuddyWithJID:[presence from] stream:stream];
        if (!buddy) {
            return;
        }
        newlyCreatedBuddy = YES;
    }
    OTRXMPPBuddy *newBuddy = [buddy copy];
    
    NSString *resource = [presence from].resource;
    OTRThreadStatus newStatus = OTRThreadStatusOffline;
    NSString *newStatusMessage = OFFLINE_STRING();
    if (buddy && !([[presence type] isEqualToString:@"unavailable"] || [presence isErrorPresence])) {
        NSString *defaultMessage = OFFLINE_STRING();
        switch (presence.intShow)
        {
            case 0  :
                newStatus = OTRThreadStatusDoNotDisturb;
                newStatusMessage = DO_NOT_DISTURB_STRING();
                break;
            case 1  :
                newStatus = OTRThreadStatusExtendedAway;
                newStatusMessage = EXTENDED_AWAY_STRING();
                break;
            case 2  :
                newStatus = OTRThreadStatusAway;
                newStatusMessage = AWAY_STRING();
                break;
            case 3  :
            case 4  :
                newStatus =OTRThreadStatusAvailable;
                newStatusMessage = AVAILABLE_STRING();
                break;
            default :
                break;
        }
        
        if ([[presence status] length]) {
            [[OTRBuddyCache sharedInstance] setStatusMessage:[presence status] forBuddy:newBuddy];
        }
        else {
            [[OTRBuddyCache sharedInstance] setStatusMessage:defaultMessage forBuddy:newBuddy];
        }
    }
    [[OTRBuddyCache sharedInstance] setThreadStatus:newStatus forBuddy:newBuddy resource:resource];
    
    
    // Save if it's a new buddy
    if (newlyCreatedBuddy) {
        [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [newBuddy saveWithTransaction:transaction];
        }];
    }
}

- (BOOL)userExistsWithJID:(XMPPJID *)jid xmppStream:(XMPPStream *)stream
{
    if ([self existsBuddyWithJID:jid xmppStram:stream]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)clearAllResourcesForXMPPStream:(XMPPStream *)stream
{
    DDLogVerbose(@"%@ - %@",THIS_FILE,THIS_METHOD);

}
- (void)clearAllUsersAndResourcesForXMPPStream:(XMPPStream *)stream
{
    DDLogVerbose(@"%@ - %@",THIS_FILE,THIS_METHOD);

}

- (NSArray *)jidsForXMPPStream:(XMPPStream *)stream
{
    __block NSMutableArray *jidArray = [NSMutableArray array];
    [self.databaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        [transaction enumerateKeysAndObjectsInCollection:[OTRXMPPBuddy collection] usingBlock:^(NSString *key, id object, BOOL *stop) {
            if ([object isKindOfClass:[OTRXMPPBuddy class]]) {
                OTRXMPPBuddy *buddy = (OTRXMPPBuddy *)object;
                if ([buddy.username length]) {
                    [jidArray addObject:buddy.username];
                }
            }
        }];
    }];
    return jidArray;
}

- (void)getSubscription:(NSString *__autoreleasing *)subscription ask:(NSString *__autoreleasing *)ask nickname:(NSString *__autoreleasing *)nickname groups:(NSArray *__autoreleasing *)groups forJID:(XMPPJID *)jid xmppStream:(XMPPStream *)stream
{
    //Can't tell if this is ever called so just a stub for now
    //OTRXMPPBuddy *buddy = [self buddyWithJID:jid xmppStream:stream];
    //*nickname = buddy.displayName;
}

@end
