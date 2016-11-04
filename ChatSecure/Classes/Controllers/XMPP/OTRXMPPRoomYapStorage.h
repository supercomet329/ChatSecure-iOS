//
//  OTRXMPPRoomYapStorage.h
//  ChatSecure
//
//  Created by David Chiles on 10/7/15.
//  Copyright © 2015 Chris Ballinger. All rights reserved.
//

@import Foundation;
@import XMPPFramework;
@import YapDatabase;
#import "OTRMessage.h"

@interface OTRXMPPRoomYapStorage : NSObject <XMPPRoomStorage>

@property (nonatomic, strong) YapDatabaseConnection *databaseConnection;

- (instancetype)initWithDatabaseConnection:(YapDatabaseConnection *)databaseConnection;

- (id <OTRMessageProtocol>)lastMessageInRoom:(XMPPRoom *)room accountKey:(NSString *)accountKey;
@end
