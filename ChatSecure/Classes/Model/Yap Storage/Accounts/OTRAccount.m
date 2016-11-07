//
//  OTRAccount.m
//  Off the Record
//
//  Created by David Chiles on 3/28/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRAccount.h"
#import <SAMKeychain/SAMKeychain.h>
#import "OTRLog.h"
#import "OTRConstants.h"

#import "OTRXMPPAccount.h"
#import "OTRXMPPTorAccount.h"
#import "OTRGoogleOAuthXMPPAccount.h"
#import "OTRDatabaseManager.h"
@import YapDatabase;
#import "OTRBuddy.h"
#import "OTRImages.h"
#import "NSURL+ChatSecure.h"
#import "OTRProtocolManager.h"
#import <ChatSecureCore/ChatSecureCore-Swift.h>


NSString *const OTRAimImageName               = @"aim.png";
NSString *const OTRGoogleTalkImageName        = @"gtalk.png";
NSString *const OTRXMPPImageName              = @"xmpp.png";
NSString *const OTRXMPPTorImageName           = @"xmpp-tor-logo.png";

@interface OTRAccount ()

//@property (nonatomic) OTRAccountType accountType;

@end

@implementation OTRAccount

@synthesize accountType = _accountType;
/** This value is only used when rememberPassword is false */
@synthesize password = _password;

- (void) dealloc {
    if (!self.rememberPassword) {
        [self removeKeychainPassword:nil];
    }
}

- (id)init
{
    if(self = [super init])
    {
        _accountType = OTRAccountTypeNone;
    }
    return self;
}

- (id)initWithAccountType:(OTRAccountType)acctType
{
    if (self = [self init]) {
        
        _accountType = acctType;
    }
    return self;
}

- (OTRProtocolType)protocolType
{
    return OTRProtocolTypeNone;
}

- (UIImage *)accountImage
{
    return nil;
}

- (NSString *)accountDisplayName
{
    return @"";
}

- (NSString *)protocolTypeString
{
    return @"";
}

- (void)setAvatarData:(NSData *)avatarData
{
    if (![self.avatarData isEqualToData:avatarData]) {
        _avatarData = avatarData;
        [OTRImages removeImageWithIdentifier:self.uniqueId];
    }
}

- (UIImage *)avatarImage
{
    //on setAvatar clear this buddies image cache
    //invalidate if jid or display name changes
    return [OTRImages avatarImageWithUniqueIdentifier:self.uniqueId avatarData:self.avatarData displayName:self.displayName username:self.username];
}

- (Class)protocolClass {
    return nil;
}

- (BOOL) removeKeychainPassword:(NSError**)error {
    NSError *internalError = nil;
    BOOL result = [SAMKeychain deletePasswordForService:kOTRServiceName account:self.uniqueId error:&internalError];
    if (!result) {
        DDLogError(@"Error deleting password from keychain: %@%@", [internalError localizedDescription], [internalError userInfo]);
    } else {
        DDLogInfo(@"Password for %@ deleted from keychain.", self.username);
    }
    if (error) {
        *error = internalError;
    }
    return result;
}

- (void)setPassword:(NSString *) password {
    // Store password in-memory only if rememberPassword is false
    // Also remove keychain value
    if (!self.rememberPassword) {
        [self removeKeychainPassword:nil];
        _password = password;
        return;
    }
    if (!password.length) {
        NSAssert(password.length > 0, @"Improperly removing password!");
        DDLogError(@"Improperly removing password! To remove password call removeKeychainPassword!");
        return;
    }
    NSError *error = nil;
    BOOL result = [SAMKeychain setPassword:password forService:kOTRServiceName account:self.uniqueId error:&error];
    if (!result) {
        DDLogError(@"Error saving password to keychain: %@%@", [error localizedDescription], [error userInfo]);
    }
}

- (NSString *)password {
    if (!self.rememberPassword) {
        [self removeKeychainPassword:nil];
        return _password;
    }
    NSError *error = nil;
    NSString *password = [SAMKeychain passwordForService:kOTRServiceName account:self.uniqueId error:&error];
    if (error) {
        //NSAssert(password.length > 0, @"Looking for password in keychain but it wasn't found!");
        DDLogError(@"Error retreiving password from keychain: %@%@", [error localizedDescription], [error userInfo]);
    }
    return password;
}

- (NSArray *)allBuddiesWithTransaction:(YapDatabaseReadTransaction *)transaction
{
    NSMutableArray *allBuddies = [NSMutableArray array];
    NSString *extensionName = [YapDatabaseConstants extensionName:DatabaseExtensionNameRelationshipExtensionName];
    NSString *edgeName = [YapDatabaseConstants edgeName:RelationshipEdgeNameBuddyAccountEdgeName];
    [[transaction ext:extensionName] enumerateEdgesWithName:edgeName destinationKey:self.uniqueId collection:[OTRAccount collection] usingBlock:^(YapDatabaseRelationshipEdge *edge, BOOL *stop) {
        OTRBuddy *buddy = [OTRBuddy fetchObjectWithUniqueID:edge.sourceKey transaction:transaction];
        if (buddy) {
            [allBuddies addObject:buddy];
        }
    }];
    return allBuddies;
}


#pragma mark NSCoding

#pragma - mark Class Methods

+(OTRAccount *)accountForAccountType:(OTRAccountType)accountType
{
    OTRAccount *account = nil;
    if (accountType == OTRAccountTypeJabber) {
        account = [[OTRXMPPAccount alloc] initWithAccountType:accountType];
    }
    else if (accountType == OTRAccountTypeXMPPTor) {
        account = [[OTRXMPPTorAccount alloc] initWithAccountType:accountType];
    }
    else if (accountType == OTRAccountTypeGoogleTalk) {
        account = [[OTRGoogleOAuthXMPPAccount alloc] initWithAccountType:accountType];
    }
    
    return account;
}

+ (NSArray *)allAccountsWithUsername:(NSString *)username transaction:(YapDatabaseReadTransaction*)transaction
{
    __block NSMutableArray *accountsArray = [NSMutableArray array];
    [transaction enumerateKeysAndObjectsInCollection:[OTRAccount collection] usingBlock:^(NSString *key, OTRAccount *account, BOOL *stop) {
        if ([account isKindOfClass:[OTRAccount class]] && [account.username isEqualToString:username]) {
            [accountsArray addObject:account];
        }
    }];
    return accountsArray;
}

+ (NSArray <OTRAccount *>*)allAccountsWithTransaction:(YapDatabaseReadTransaction*)transaction
{
    NSMutableArray <OTRAccount *>*accounts = [NSMutableArray array];
    NSString *collection = [OTRAccount collection];
    NSArray <NSString*>*allAccountKeys = [transaction allKeysInCollection:collection];
    [allAccountKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = [transaction objectForKey:key inCollection:collection];
        if (object && [object isKindOfClass:[OTRAccount class]]) {
            [accounts addObject:object];
        }
    }];
    
    return accounts;
    
}

+ (NSUInteger)removeAllAccountsOfType:(OTRAccountType)accountType inTransaction:(YapDatabaseReadWriteTransaction *)transaction
{
    NSMutableArray *keys = [NSMutableArray array];
    [transaction enumerateKeysAndObjectsInCollection:[self collection] usingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([object isKindOfClass:[self class]]) {
            OTRAccount *account = (OTRAccount *)object;
            account.password = nil;
            
            if (account.accountType == accountType) {
                [keys addObject:account.uniqueId];
            }
        }
    }];
    
    [transaction removeObjectsForKeys:keys inCollection:[self collection]];
    return [keys count];
}


// See MTLModel+NSCoding.h
// This helps enforce that only the properties keys that we
// desire will be encoded. Be careful to ensure that values
// that should be stored in the keychain don't accidentally
// get serialized!
+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSMutableDictionary *behaviors = [NSMutableDictionary dictionaryWithDictionary:[super encodingBehaviorsByPropertyKey]];
    [behaviors setObject:@(MTLModelEncodingBehaviorExcluded) forKey:NSStringFromSelector(@selector(password))];
    return behaviors;
}

+ (MTLPropertyStorage)storageBehaviorForPropertyWithKey:(NSString *)propertyKey {
    if ([propertyKey isEqualToString:NSStringFromSelector(@selector(password))]) {
        return MTLPropertyStorageNone;
    }
    return [super storageBehaviorForPropertyWithKey:propertyKey];
}

#pragma mark Fingerprints

/**
 *  Returns the full share URL invite link for this account. Optionally includes fingerprints of various key types.
 *
 *  @param fingerprintTypes (optional) include a NSSet of boxed of OTRFingerprintType values
 *  @param completion called on main queue with shareURL, or potentially nil if there's an error during link generation.
 */
- (void) generateShareURLWithFingerprintTypes:(NSSet <NSNumber*> *)fingerprintTypes
                                   completion:(void (^)(NSURL* shareURL, NSError *error))completionBlock {
    NSParameterAssert(completionBlock != nil);
    if (!completionBlock) {
        return;
    }
    NSURL *baseURL = [NSURL otr_shareBaseURL];
    
    NSMutableDictionary <NSString*, NSString*> *fingerprints = [NSMutableDictionary dictionary];
    
    if (fingerprintTypes.count > 0) {
        // We only support OTR fingerprints at the moment
        if ([fingerprintTypes containsObject:@(OTRFingerprintTypeOTR)]) {
            [OTRProtocolManager.sharedInstance.encryptionManager.otrKit generatePrivateKeyForAccountName:self.username protocol:self.protocolTypeString completion:^(NSString *fingerprint, NSError *error) {
                if (fingerprint) {
                    NSString *key = [[self class] fingerprintStringTypeForFingerprintType:OTRFingerprintTypeOTR];
                    [fingerprints setObject:fingerprint forKey:key];
                }
                
                // Since we only support OTR at the moment, we can finish here, but this should be refactored with a dispatch_group when we support more key types.
                
                NSURL *url = [NSURL otr_shareLink:baseURL.absoluteString username:self.username fingerprints:fingerprints];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(url, nil);
                });
            }];
        }
    }
}

/**
 *  Returns string representation of OTRFingerprintType
 *
 *  - "otr" for OTRFingerprintTypeOTR
 *  - "omemo" for OTRFingerprintTypeAxolotl
 *  - "gpg" for OTRFingerprintTypeGPG
 *
 *  @return String representation of OTRFingerprintType
 */
+ (NSString*) fingerprintStringTypeForFingerprintType:(OTRFingerprintType)fingerprintType {
    switch (fingerprintType) {
        case OTRFingerprintTypeAxolotl:
            return @"axolotl";
            break;
        case OTRFingerprintTypeGPG:
            return @"gpg";
            break;
        case OTRFingerprintTypeOTR:
            return @"otr";
            break;
        default:
            return nil;
            break;
    }
}

@end
