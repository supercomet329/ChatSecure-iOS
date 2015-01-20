//
//  OTRMessage+JSQMessageData.m
//  Off the Record
//
//  Created by David Chiles on 5/12/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRMessage+JSQMessageData.h"
#import "OTRDatabaseManager.h"
#import "OTRBuddy.h"
#import "OTRAccount.h"
#import "OTRMediaItem.h"

@implementation OTRMessage (JSQMessageData)

- (NSString *)senderId
{
    __block NSString *sender = @"";
    [[OTRDatabaseManager sharedInstance].readOnlyDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        OTRBuddy *buddy = [self buddyWithTransaction:transaction];
        if (self.isIncoming) {
            sender = buddy.uniqueId;
        }
        else {
            OTRAccount *account = [buddy accountWithTransaction:transaction];
            sender = account.uniqueId;
        }
    }];
    return sender;
}

- (NSString *)senderDisplayName {
    __block NSString *sender = @"";
    [[OTRDatabaseManager sharedInstance].readOnlyDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        OTRBuddy *buddy = [self buddyWithTransaction:transaction];
        if (self.isIncoming) {
            if ([buddy.displayName length]) {
                sender = buddy.displayName;
            }
            else {
                sender = buddy.username;
            }
        }
        else {
            OTRAccount *account = [buddy accountWithTransaction:transaction];
            if ([account.displayName length]) {
                sender = account.displayName;
            }
            else {
                sender = account.username;
            }
        }
    }];
    return sender;
}

- (BOOL)isMediaMessage
{
    if (self.media) {
        return YES;
    }
    return NO;
}

- (id<JSQMessageMediaData>)media
{
    return self.mediaItem;
}


@end
