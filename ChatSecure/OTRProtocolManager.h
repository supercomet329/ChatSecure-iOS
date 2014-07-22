//
//  OTRProtocolManager.h
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

#import <Foundation/Foundation.h>
#import "OTREncryptionManager.h"
#import "OTRCodec.h"
#import "OTRSettingsManager.h"
#import "OTRProtocol.h"
#import "OTRAccountsManager.h"

@class OTRAccount,OTRBuddy, OTRPushManager;

@interface OTRProtocolManager : NSObject

@property (nonatomic, readonly) NSUInteger numberOfConnectedProtocols;
@property (nonatomic, readonly) NSUInteger numberOfConnectingProtocols;

@property (nonatomic, strong) OTREncryptionManager *encryptionManager;
@property (nonatomic, strong, readonly) NSDictionary * protocolManagerDictionary;

- (id <OTRProtocol>) protocolForAccount:(OTRAccount *)account;
- (void)removeProtocolManagerForAccount:(OTRAccount *)account;
- (BOOL)isAccountConnected:(OTRAccount *)account;

- (void)loginAccount:(OTRAccount *)account;
- (void)loginAccounts:(NSArray *)accounts;

- (void)sendMessage:(OTRMessage *)message;

- (OTRPushManager *)defaultPushManager;

+ (OTRProtocolManager*)sharedInstance; // Singleton method

@end
