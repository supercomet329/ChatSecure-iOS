//
//  OTRConvertAccount.m
//  Off the Record
//
//  Created by David on 1/16/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTRConvertAccount.h"
#import "OTRSettingsManager.h"
#import "OTROldXMPPAccount.h"
#import "OTROldOscarAccount.h"
#import "OTRManagedXMPPAccount.h"
#import "OTRManagedOscarAccount.h"
#import "OTRConstants.h"


@implementation OTRConvertAccount



-(BOOL)hasLegacyAccountSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *accountsDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:kOTRSettingAccountsKey]];
    
    if(accountsDictionary)
        return YES;
    else
        return NO;
    
}

-(void)saveDictionary:(NSDictionary *)accountDictionary withUniqueId:(NSString *)uniqueId;
{
    NSLog(@"Converting: %@",accountDictionary);
    NSString * protocol = [accountDictionary objectForKey:kOTRAccountProtocolKey];
    if ([protocol isEqualToString:kOTRProtocolTypeXMPP]) {
        OTRXMPPAccount * xmppAccount = [[OTRXMPPAccount alloc] initWithSettingsDictionary:accountDictionary uniqueIdentifier:uniqueId];
        
        OTRManagedXMPPAccount * managagedXmppAccount = [OTRManagedXMPPAccount MR_createEntity];
        
        managagedXmppAccount.uniqueIdentifier = xmppAccount.uniqueIdentifier;
        [managagedXmppAccount setNewUsername:xmppAccount.username];
        managagedXmppAccount.domain = xmppAccount.domain;
        managagedXmppAccount.port = xmppAccount.port;
        managagedXmppAccount.sendDeliveryReceipts = xmppAccount.sendDeliveryReceipts;
        managagedXmppAccount.sendTypingNotifications = xmppAccount.sendTypingNotifications;
        managagedXmppAccount.shouldAllowSelfSignedSSL = xmppAccount.allowSelfSignedSSL;
         managagedXmppAccount.shouldAllowSSLHostNameMismatch = xmppAccount.allowSSLHostNameMismatch;
        managagedXmppAccount.protocol = xmppAccount.protocol;
        [managagedXmppAccount setShouldRememberPassword:xmppAccount.rememberPassword];
        managagedXmppAccount.password = xmppAccount.password;
        managagedXmppAccount.isConnected = NO;
        
        
        [managagedXmppAccount save];
        
        
        
    }
    else if([protocol isEqualToString:kOTRProtocolTypeAIM])
    {
        OTROscarAccount * oscarAccount = [[OTROscarAccount alloc] initWithSettingsDictionary:accountDictionary uniqueIdentifier:uniqueId];
        
        OTRManagedOscarAccount * managedOscarAccount = [OTRManagedOscarAccount MR_createEntity];
        
        managedOscarAccount.protocol = oscarAccount.protocol;
        managedOscarAccount.password = oscarAccount.password;
        managedOscarAccount.uniqueIdentifier = managedOscarAccount.uniqueIdentifier;
        [managedOscarAccount setNewUsername:oscarAccount.username];
        [managedOscarAccount setShouldRememberPassword:oscarAccount.rememberPassword];
        managedOscarAccount.isConnected = NO;
        
        [managedOscarAccount save];
        
        
        
        
        
    }
    
    
}

-(BOOL)convertAllLegacyAcountSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *accountsDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:kOTRSettingAccountsKey]];
    
    if (accountsDictionary) {
        for(NSString * key in accountsDictionary)
        {
            NSDictionary * accountDictionary = [accountsDictionary objectForKey:key];
            [self saveDictionary:accountDictionary withUniqueId:key];
        }
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        [context MR_save];
        [defaults removeObjectForKey:kOTRSettingAccountsKey];
    }
}


@end
