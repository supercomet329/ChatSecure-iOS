//
//  OTRProtocolManager.m
//  Off the Record
//
//  Created by Chris Ballinger on 9/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OTRProtocolManager.h"

static OTRProtocolManager *sharedManager = nil;

@implementation OTRProtocolManager

@synthesize oscarManager;
@synthesize encryptionManager;
@synthesize xmppManager;

-(id)init
{
    self = [super init];
    if(self)
    {
        oscarManager = [[OTROscarManager alloc] init];
        xmppManager = [[OTRXMPPManager alloc] init];
        encryptionManager = [[OTREncryptionManager alloc] init];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(sendMessage:)
         name:@"SendMessageNotification"
         object:nil ];
    }
    return self;
}

#pragma mark -
#pragma mark Singleton Object Methods

+ (OTRProtocolManager*)sharedInstance {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedManager == nil) {
            sharedManager = [super allocWithZone:zone];
            return sharedManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

/*- (void)release {
 //do nothing
 }*/

- (id)autorelease {
    return self;
}


-(void)sendMessage:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *protocol = [userInfo objectForKey:@"protocol"];
    
    NSLog(@"send message (%@): %@", protocol, [userInfo objectForKey:@"message"]);
    
    
    if([protocol isEqualToString:@"xmpp"])
    {
        [self sendMessageXMPP:userInfo];
    }
    else if([protocol isEqualToString:@"prpl-oscar"])
    {
        [self sendMessageOSCAR:userInfo];
    }
}

-(void)sendMessageOSCAR:(NSDictionary *)messageInfo
{
    NSString *recipient = [messageInfo objectForKey:@"recipient"];
    NSString *message = [messageInfo objectForKey:@"message"];
    
    AIMSessionManager *theSession = [oscarManager.theSession retain];
    AIMMessage * msg = [AIMMessage messageWithBuddy:[theSession.session.buddyList buddyWithUsername:recipient] message:message];
    
    // use delay to prevent OSCAR rate-limiting problem
    //NSDate *future = [NSDate dateWithTimeIntervalSinceNow: delay ];
    //[NSThread sleepUntilDate:future];
    
	[theSession.messageHandler sendMessage:msg];
    
    [theSession release];
}

-(void)sendMessageXMPP:(NSDictionary *)messageInfo
{
    NSString *messageStr = [messageInfo objectForKey:@"message"];
	
	if([messageStr length] > 0)
	{
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:messageStr];
		
		NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
		[message addAttributeWithName:@"type" stringValue:@"chat"];
		[message addAttributeWithName:@"to" stringValue:[messageInfo objectForKey:@"recipient"]];
		[message addChild:body];
		
		[xmppManager.xmppStream sendElement:message];		
	}
}

-(OTRCodec*)codecForProtocol:(NSString*)protocol
{
    if([protocol isEqualToString:@"prpl-oscar"])
    {
        return oscarManager.messageCodec;
    }
    else if([protocol isEqualToString:@"xmpp"])
    {
        return xmppManager.messageCodec;
    }
    return nil;
}

@end
