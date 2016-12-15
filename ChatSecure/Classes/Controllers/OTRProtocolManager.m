//
//  OTRProtocolManager.m
//  Off the Record
//
//  Created by Chris Ballinger on 9/4/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//
//  This file is part of ChatSecure.
//
//  ChatSecure is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ChatSecure is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ChatSecure.  If not, see <http://www.gnu.org/licenses/>.

#import "OTRProtocolManager.h"
#import "OTRAccount.h"
#import "OTRBuddy.h"
#import "OTRIncomingMessage.h"
#import "OTROutgoingMessage.h"
#import "OTRConstants.h"
#import "OTROAuthRefresher.h"
#import "OTROAuthXMPPAccount.h"
#import "OTRDatabaseManager.h"
#import "OTRPushTLVHandler.h"
@import YapDatabase;

@import KVOController;
@import OTRAssets;
#import "OTRLog.h"
#import <ChatSecureCore/ChatSecureCore-Swift.h>

@interface OTRProtocolManager ()
@property (atomic, readwrite) NSUInteger numberOfConnectedProtocols;
@property (atomic, readwrite) NSUInteger numberOfConnectingProtocols;
@property (atomic, strong, readonly, nonnull) NSMutableDictionary<NSString*,id<OTRProtocol>> *protocolManagers;
@end

@implementation OTRProtocolManager

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _protocolManagers = [[NSMutableDictionary alloc] init];
        
        _numberOfConnectedProtocols = 0;
        _numberOfConnectingProtocols = 0;
        _encryptionManager = [[OTREncryptionManager alloc] init];
        
        NSURL *pushAPIEndpoint = [OTRBranding pushAPIURL];
        // Casting here because it's easier than figuring out the
        // non-modular include spaghetti mess
        id<OTRPushTLVHandlerProtocol> tlvHandler = (id<OTRPushTLVHandlerProtocol>)self.encryptionManager.pushTLVHandler;
        _pushController = [[PushController alloc] initWithBaseURL:pushAPIEndpoint sessionConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] databaseConnection:[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection tlvHandler:tlvHandler];
        self.encryptionManager.pushTLVHandler.delegate = self.pushController;
    }
    return self;
}

- (void)removeProtocolForAccount:(OTRAccount *)account
{
    NSParameterAssert(account);
    if (!account) { return; }
    id<OTRProtocol> protocol = [self.protocolManagers objectForKey:account.uniqueId];
    if (protocol && [protocol respondsToSelector:@selector(disconnect)]) {
        [protocol disconnect];
    }
    [self.KVOController unobserve:protocol];
    [self.protocolManagers removeObjectForKey:account.uniqueId];
}

- (void)addProtocol:(id<OTRProtocol>)protocol forAccount:(OTRAccount *)account
{
    [self.protocolManagers setObject:protocol forKey:account.uniqueId];
    [self.KVOController observe:protocol keyPath:NSStringFromSelector(@selector(connectionStatus)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld action:@selector(protocolDidChange:)];
}

- (BOOL)existsProtocolForAccount:(OTRAccount *)account
{
    NSParameterAssert(account.uniqueId);
    if (!account.uniqueId) { return NO; }
    return [self.protocolManagers objectForKey:account.uniqueId] != nil;
}

- (void)setProtocol:(id <OTRProtocol>)protocol forAccount:(OTRAccount *)account
{
    NSParameterAssert(protocol);
    NSParameterAssert(account.uniqueId);
    if (!protocol || !account.uniqueId) { return; }
    [self addProtocol:protocol forAccount:account];
}

- (id <OTRProtocol>)protocolForAccount:(OTRAccount *)account
{
    NSParameterAssert(account);
    if (!account.uniqueId) { return nil; }
    id <OTRProtocol> protocol = [self.protocolManagers objectForKey:account.uniqueId];
    if(!protocol)
    {
        protocol = [[[account protocolClass] alloc] initWithAccount:account];
        if (protocol && account.uniqueId) {
            [self addProtocol:protocol forAccount:account];
        }
    }
    return protocol;
}

- (void)loginAccount:(OTRAccount *)account userInitiated:(BOOL)userInitiated
{
    NSParameterAssert(account);
    if (!account) { return; }
    id <OTRProtocol> protocol = [self protocolForAccount:account];
    if ([protocol connectionStatus] != OTRLoginStatusDisconnected) {
        DDLogError(@"Account already connected %@", account);
        return;
    }
    
    if([account isKindOfClass:[OTROAuthXMPPAccount class]])
    {
        [OTROAuthRefresher refreshAccount:(OTROAuthXMPPAccount *)account completion:^(id token, NSError *error) {
            if (!error) {
                ((OTROAuthXMPPAccount *)account).accountSpecificToken = token;
                [protocol connectUserInitiated:userInitiated];
            }
            else {
                DDLogError(@"Error Refreshing Token");
            }
        }];
    }
    else
    {
        [protocol connectUserInitiated:userInitiated];
    }
}

- (void)loginAccount:(OTRAccount *)account
{
    [self loginAccount:account userInitiated:NO];
}

- (void)loginAccounts:(NSArray *)accounts
{
    [accounts enumerateObjectsUsingBlock:^(OTRAccount * account, NSUInteger idx, BOOL *stop) {
        [self loginAccount:account];
    }];
}

- (void)disconnectAllAccountsSocketOnly:(BOOL)socketOnly {
    [self.protocolManagers enumerateKeysAndObjectsUsingBlock:^(id key, id <OTRProtocol> protocol, BOOL *stop) {
        [protocol disconnectSocketOnly:socketOnly];
    }];
}

- (void)disconnectAllAccounts
{
    [self disconnectAllAccountsSocketOnly:NO];
}

- (void)protocolDidChange:(NSDictionary *)change
{
    
    OTRProtocolConnectionStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
    OTRProtocolConnectionStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
    
    if (oldStatus == newStatus) {
        return;
    }
    
    NSInteger connectedInt = 0;
    NSInteger connectingInt = 0;
    
    switch (oldStatus) {
        case OTRProtocolConnectionStatusConnected:
            connectedInt = -1;
            break;
        case OTRProtocolConnectionStatusConnecting:
            connectingInt = -1;
        default:
            break;
    }
    
    switch (newStatus) {
        case OTRProtocolConnectionStatusConnected:
            connectedInt = 1;
            break;
        case OTRProtocolConnectionStatusConnecting:
            connectingInt = 1;
        default:
            break;
    }
    
    
    self.numberOfConnectedProtocols += connectedInt;
    self.numberOfConnectingProtocols += connectingInt;
}

-(BOOL)isAccountConnected:(OTRAccount *)account;
{
    BOOL connected = NO;
    id <OTRProtocol> protocol = [self.protocolManagers objectForKey:account.uniqueId];
    if (protocol) {
        connected = [protocol connectionStatus] == OTRProtocolConnectionStatusConnected;
    }
    return connected;
}

- (void)sendMessage:(OTROutgoingMessage *)message {
    __block OTRAccount * account = nil;
    [[OTRDatabaseManager sharedInstance].readOnlyDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
        OTRBuddy *buddy = [OTRBuddy fetchObjectWithUniqueID:message.buddyUniqueId transaction:transaction];
        account = [OTRAccount fetchObjectWithUniqueID:buddy.accountUniqueId transaction:transaction];
    } completionBlock:^{
        OTRProtocolManager * protocolManager = [OTRProtocolManager sharedInstance];
        id<OTRProtocol> protocol = [protocolManager protocolForAccount:account];
        [protocol sendMessage:message];
    }];
}

#pragma mark Singleton Object Methods

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
