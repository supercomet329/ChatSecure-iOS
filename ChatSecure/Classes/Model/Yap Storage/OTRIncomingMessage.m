//
//  OTRIncomingMessage.m
//  ChatSecure
//
//  Created by David Chiles on 11/10/16.
//  Copyright © 2016 Chris Ballinger. All rights reserved.
//

#import "OTRIncomingMessage.h"

@implementation OTRIncomingMessage

#pragma MARK - OTRMessageProtocol

- (BOOL)messageIncoming
{
    return YES;
}

- (OTRMessageTransportSecurity)messageSecurity
{
    OTRMessageTransportSecurity security = [super messageSecurity];
    if(security == OTRMessageTransportSecurityPlaintext) {
        return self.messageSecurityInfo.messageSecurity;
    }
    return security;
}

- (BOOL)messageRead
{
    return self.read;
}

@end
