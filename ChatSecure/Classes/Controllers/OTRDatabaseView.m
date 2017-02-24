//
//  OTRDatabaseView.m
//  Off the Record
//
//  Created by David Chiles on 3/31/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRDatabaseView.h"
@import YapDatabase;
#import "OTRDatabaseManager.h"
#import "OTRBuddy.h"
#import "OTRAccount.h"
#import "OTRIncomingMessage.h"
#import "OTROutgoingMessage.h"
#import "OTRXMPPPresenceSubscriptionRequest.h"
#import <ChatSecureCore/ChatSecureCore-Swift.h>

NSString *OTRConversationGroup = @"Conversation";
NSString *OTRConversationDatabaseViewExtensionName = @"OTRConversationDatabaseViewExtensionName";
NSString *OTRChatDatabaseViewExtensionName = @"OTRChatDatabaseViewExtensionName";
NSString *OTRAllBuddiesDatabaseViewExtensionName = @"OTRAllBuddiesDatabaseViewExtensionName";
NSString *OTRAllSubscriptionRequestsViewExtensionName = @"AllSubscriptionRequestsViewExtensionName";
NSString *OTRAllPushAccountInfoViewExtensionName = @"OTRAllPushAccountInfoViewExtensionName";

NSString *OTRAllAccountGroup = @"All Accounts";
NSString *OTRAllAccountDatabaseViewExtensionName = @"OTRAllAccountDatabaseViewExtensionName";
NSString *OTRChatMessageGroup = @"Messages";
NSString *OTRBuddyGroup = @"Buddy";
NSString *OTRAllPresenceSubscriptionRequestGroup = @"OTRAllPresenceSubscriptionRequestGroup";
NSString *OTRUnreadMessageGroup = @"Unread Messages";

NSString *OTRPushTokenGroup = @"Tokens";
NSString *OTRPushDeviceGroup = @"Devices";
NSString *OTRPushAccountGroup = @"Account";

@implementation OTRDatabaseView



+ (BOOL)registerConversationDatabaseViewWithDatabase:(YapDatabase *)database
{
    YapDatabaseView *conversationView = [database registeredExtension:OTRConversationDatabaseViewExtensionName];
    if (conversationView) {
        return YES;
    }
    
    YapDatabaseViewGrouping *viewGrouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key, id object) {
        if ([object conformsToProtocol:@protocol(OTRThreadOwner)]) {
            if ([object isKindOfClass:[OTRBuddy class]])
            {
                OTRBuddy *buddy = (OTRBuddy *)object;
                // Hack to show "placeholder" items in list
                if (buddy.lastMessageId && buddy.lastMessageId.length == 0) {
                    return OTRConversationGroup;
                }
                id <OTRMessageProtocol> lastMessage = [buddy lastMessageWithTransaction:transaction];
                if (lastMessage) {
                    return OTRConversationGroup;
                }
            } else {
                return OTRConversationGroup;
            }
        }
        if ([object isKindOfClass:[OTRXMPPPresenceSubscriptionRequest class]]) {
            return OTRAllPresenceSubscriptionRequestGroup;
        }
        return nil; // exclude from view
    }];
    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        if ([group isEqualToString:OTRConversationGroup]) {
            if ([object1 conformsToProtocol:@protocol(OTRThreadOwner)] && [object2 conformsToProtocol:@protocol(OTRThreadOwner)]) {
                id <OTRThreadOwner> thread1 = object1;
                id <OTRThreadOwner> thread2 = object2;
                id <OTRMessageProtocol> message1 = [thread1 lastMessageWithTransaction:transaction];
                id <OTRMessageProtocol> message2 = [thread2 lastMessageWithTransaction:transaction];
                
                // Assume nil dates indicate a lastMessageId of ""
                // indicating that we want to force to the top
                NSDate *date1 = [message1 date];
                if (!date1) {
                    date1 = [NSDate date];
                }
                NSDate *date2 = [message2 date];
                if (!date2) {
                    date2 = [NSDate date];
                }
                
                return [date2 compare:date1];
            }
        } else if ([group isEqualToString:OTRAllPresenceSubscriptionRequestGroup]) {
            if ([object1 isKindOfClass:[OTRXMPPPresenceSubscriptionRequest class]] && [object2 isKindOfClass:[OTRXMPPPresenceSubscriptionRequest class]]) {
                OTRXMPPPresenceSubscriptionRequest *request1 = object1;
                OTRXMPPPresenceSubscriptionRequest *request2 = object2;
                return [request2.date compare:request1.date];
            }
        }
        return NSOrderedSame;
    }];
    
    YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
    options.isPersistent = YES;
    NSSet *whiteListSet = [NSSet setWithObjects:[OTRBuddy collection],[OTRXMPPRoom collection], [OTRXMPPPresenceSubscriptionRequest collection], nil];
    options.allowedCollections = [[YapWhitelistBlacklist alloc] initWithWhitelist:whiteListSet];
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                                      sorting:viewSorting
                                                                   versionTag:@"6"
                                                                      options:options];
    
    return [database registerExtension:databaseView withName:OTRConversationDatabaseViewExtensionName];
}




+ (BOOL)registerAllAccountsDatabaseViewWithDatabase:(YapDatabase *)database
{
    YapDatabaseView *accountView = [database registeredExtension:OTRAllAccountDatabaseViewExtensionName];
    if (accountView) {
        return YES;
    }
    
    YapDatabaseViewGrouping *viewGrouping = [YapDatabaseViewGrouping withKeyBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key) {
        if ([collection isEqualToString:[OTRAccount collection]])
        {
            return OTRAllAccountGroup;
        }
        
        return nil;
    }];
    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        if ([group isEqualToString:OTRAllAccountGroup]) {
            if ([object1 isKindOfClass:[OTRAccount class]] && [object2 isKindOfClass:[OTRAccount class]]) {
                OTRAccount *account1 = (OTRAccount *)object1;
                OTRAccount *account2 = (OTRAccount *)object2;
                
                return [account1.displayName compare:account2.displayName options:NSCaseInsensitiveSearch];
            }
        }
        return NSOrderedSame;
    }];
    
    YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
    options.isPersistent = YES;
    options.allowedCollections = [[YapWhitelistBlacklist alloc] initWithWhitelist:[NSSet setWithObject:[OTRAccount collection]]];
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                                      sorting:viewSorting
                                                                   versionTag:@"1"
                                                                      options:options];
    
    return [database registerExtension:databaseView withName:OTRAllAccountDatabaseViewExtensionName];
}

+ (BOOL)registerChatDatabaseViewWithDatabase:(YapDatabase *)database
{
    if ([database registeredExtension:OTRChatDatabaseViewExtensionName]) {
        return YES;
    }
    
    YapDatabaseViewGrouping *viewGrouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key, id object) {
        if ([object conformsToProtocol:@protocol(OTRMessageProtocol)])
        {
            return [((id <OTRMessageProtocol>)object) threadId];
        }
        return nil;
    }];
    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        if ([object1 conformsToProtocol:@protocol(OTRMessageProtocol)] && [object2 conformsToProtocol:@protocol(OTRMessageProtocol)]) {
            id <OTRMessageProtocol> message1 = (id <OTRMessageProtocol>)object1;
            id <OTRMessageProtocol> message2 = (id <OTRMessageProtocol>)object2;
            
            return [[message1 date] compare:[message2 date]];
        }
        return NSOrderedSame;
    }];
    
    YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
    options.isPersistent = YES;
    NSSet *whitelist = [NSSet setWithObjects:[OTRBaseMessage collection],[OTRXMPPRoomMessage collection], nil];
    options.allowedCollections = [[YapWhitelistBlacklist alloc] initWithWhitelist:whitelist];
    
    
    
    YapDatabaseView *view = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                              sorting:viewSorting
                                                           versionTag:@"1"
                                                              options:options];
    
    return [database registerExtension:view withName:OTRChatDatabaseViewExtensionName];
}

+ (BOOL)registerAllBuddiesDatabaseViewWithDatabase:(YapDatabase *)database
{
    if ([database registeredExtension:OTRAllBuddiesDatabaseViewExtensionName]) {
        return YES;
    }
    
    YapDatabaseViewGrouping *viewGrouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key, id object) {
        if ([object isKindOfClass:[OTRBuddy class]]) {
            
            //Checking to see if the buddy username is equal to the account username in order to remove 'self' buddy
            OTRBuddy *buddy = (OTRBuddy *)object;
            OTRAccount *account = [buddy accountWithTransaction:transaction];
            // Hack fix for buddies created without an account
            // There must be a race condition in the roster popualtion
            if (!account) {
                return nil;
            }
            if (![account.username isEqualToString:buddy.username]) {
                return OTRBuddyGroup;
            }
        }
        return nil;
    }];
    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        
        OTRBuddy *buddy1 = (OTRBuddy *)object1;
        OTRBuddy *buddy2 = (OTRBuddy *)object2;
        
        
        if (buddy1.currentStatus == buddy2.currentStatus) {
            NSString *buddy1String = buddy1.username;
            NSString *buddy2String = buddy2.username;
            
            if ([buddy1.displayName length]) {
                buddy1String = buddy1.displayName;
            }
            
            if ([buddy2.displayName length]) {
                buddy2String = buddy2.displayName;
            }
            
            return [buddy1String compare:buddy2String options:NSCaseInsensitiveSearch];
        }
        else if (buddy1.currentStatus < buddy2.currentStatus) {
            return NSOrderedAscending;
        }
        else{
            return NSOrderedDescending;
        }
    }];
    
    
    YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
    options.isPersistent = YES;
    options.allowedCollections = [[YapWhitelistBlacklist alloc] initWithWhitelist:[NSSet setWithObject:[OTRBuddy collection]]];
    
    YapDatabaseView *view = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                              sorting:viewSorting
                                                           versionTag:@"3"
                                                              options:options];
    
    return [database registerExtension:view withName:OTRAllBuddiesDatabaseViewExtensionName];

}

+ (BOOL)registerAllSubscriptionRequestsViewWithDatabase:(YapDatabase *)database
{
    if ([database registeredExtension:OTRAllSubscriptionRequestsViewExtensionName]) {
        return YES;
    }
    
    YapDatabaseViewGrouping *viewGrouping = [YapDatabaseViewGrouping withKeyBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key) {
        if ([collection isEqualToString:[OTRXMPPPresenceSubscriptionRequest collection]])
        {
            return OTRAllPresenceSubscriptionRequestGroup;
        }
        
        return nil;
    }];
    
    YapDatabaseViewSorting *viewSorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
        
        OTRXMPPPresenceSubscriptionRequest *request1 = (OTRXMPPPresenceSubscriptionRequest *)object1;
        OTRXMPPPresenceSubscriptionRequest *request2 = (OTRXMPPPresenceSubscriptionRequest *)object2;
        
        if (request1 && request2) {
            return [request1.date compare:request2.date];
        }
        
        return NSOrderedSame;
    }];
    
    YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
    options.isPersistent = YES;
    options.allowedCollections = [[YapWhitelistBlacklist alloc] initWithWhitelist:[NSSet setWithObject:[OTRXMPPPresenceSubscriptionRequest collection]]];
    
    YapDatabaseView *databaseView = [[YapDatabaseView alloc] initWithGrouping:viewGrouping
                                                                      sorting:viewSorting
                                                                   versionTag:@"1"
                                                                      options:options];
    
    return [database registerExtension:databaseView withName:OTRAllSubscriptionRequestsViewExtensionName];
}

@end
