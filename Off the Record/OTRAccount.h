//
//  OTRAccount.h
//  Off the Record
//
//  Created by Chris Ballinger on 6/26/12.
//  Copyright (c) 2012 Chris Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOTRAccountUsernameKey @"username"
#define kOTRAccountDomainKey @"domain"
#define kOTRAccountProtocolKey @"protocol"
#define kOTRAccountRememberPasswordKey @"remember"

@interface OTRAccount : NSObject

@property (nonatomic, retain) NSString *username; // 
@property (nonatomic, retain) NSString *domain; // xmpp only, used for custom domains
@property (nonatomic, retain) NSString *protocol; // kOTRProtocolType, defined in OTRProtocolManager.h
@property (nonatomic, retain) NSString *password; // nil if rememberPassword = NO, not stored in memory
@property (nonatomic, readonly) NSString *uniqueIdentifier;
@property (nonatomic) BOOL rememberPassword;

- (id) initWithSettingsDictionary:(NSDictionary*)dictionary uniqueIdentifier:(NSString*)uniqueID;
- (void) save;

//- (id<OTRProtocol>)protocolManager;

@end
