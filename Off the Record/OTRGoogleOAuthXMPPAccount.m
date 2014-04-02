//
//  OTRGoogleOAuthXMPPAccount.m
//  Off the Record
//
//  Created by David Chiles on 3/28/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRGoogleOAuthXMPPAccount.h"
#import "OTRConstants.h"
#import "Strings.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2SignIn.h"
#import "OTRSecrets.h"

NSString *const kOTRExpirationDateKey = @"kOTRExpirationDateKey";
NSString *const kOTRExpiresInKey      = @"expires_in";


@implementation OTRGoogleOAuthXMPPAccount

- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (UIImage *)accountImage
{
    return [UIImage imageNamed:OTRGoogleTalkImageName];
}
- (NSString *)accountDisplayName
{
    return GOOGLE_TALK_STRING;
}

-(NSString *)accessTokenString {
    return [self authToken].accessToken;
}

-(void)setTokenDictionary:(NSDictionary *)tokenDictionary
{
    if ([tokenDictionary count]) {
        NSMutableDictionary * mutableTokenDictionary = [tokenDictionary mutableCopy];
        NSNumber * expiresIn = [mutableTokenDictionary objectForKey:kOTRExpiresInKey];
        [mutableTokenDictionary removeObjectForKey:kOTRExpiresInKey];
        NSDate *date = nil;
        if (expiresIn) {
            unsigned long deltaSeconds = [expiresIn unsignedLongValue];
            if (deltaSeconds > 0) {
                date = [NSDate dateWithTimeIntervalSinceNow:deltaSeconds];
            }
        }
        if(date) {
            [mutableTokenDictionary setObject:date forKey:kOTRExpirationDateKey];
        }
        tokenDictionary = mutableTokenDictionary;
    }
    [super setOAuthTokenDictionary:tokenDictionary];
}

-(NSDictionary *)tokenDictionary
{
    NSMutableDictionary * mutableTokenDictionary = [[super oAuthTokenDictionary] mutableCopy];
    NSDate * expirationDate = [mutableTokenDictionary objectForKey:kOTRExpirationDateKey];
    
    NSTimeInterval timeInterval  = [expirationDate timeIntervalSinceDate:[NSDate date]];
    mutableTokenDictionary[kOTRExpiresInKey] = @(timeInterval);
    return mutableTokenDictionary;
}

-(GTMOAuth2Authentication *)authToken
{
    GTMOAuth2Authentication * auth = nil;
    NSDictionary * tokenDictionary = [self oAuthTokenDictionary];
    if ([tokenDictionary count]) {
        auth = [[GTMOAuth2Authentication alloc] init];
        [auth setParameters:[tokenDictionary mutableCopy]];
    }
    auth.clientID = GOOGLE_APP_ID;
    auth.clientSecret = kOTRGoogleAppSecret;
    auth.scope = GOOGLE_APP_SCOPE;
    auth.tokenURL = [GTMOAuth2SignIn googleTokenURL];
    return auth;
}

- (id)accountSpecificToken
{
    return [self authToken];
}

- (void)setAccountSpecificToken:(id)accountSpecificToken
{
    if ([accountSpecificToken isKindOfClass:[GTMOAuth2Authentication class]]) {
        GTMOAuth2Authentication *token = (GTMOAuth2Authentication *)accountSpecificToken;
        [self setTokenDictionary:token.parameters];
    }
}

#pragma - mark Class Methods 

+ (NSString *)collection
{
    return NSStringFromClass([OTRAccount class]);
}

@end
