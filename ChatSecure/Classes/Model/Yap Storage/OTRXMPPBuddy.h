//
//  OTRXMPPBuddy.h
//  Off the Record
//
//  Created by David Chiles on 3/28/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRBuddy.h"

@class XMPPvCardTemp;

@interface OTRXMPPBuddy : OTRBuddy

@property (nonatomic, strong) XMPPvCardTemp *vCardTemp;
@property (nonatomic, strong) NSDate *lastUpdatedvCardTemp;
@property (nonatomic, getter =  isWaitingForvCardTempFetch) BOOL waitingForvCardTempFetch;
@property (nonatomic, strong) NSString *photoHash;

/** This is for outgoing subscription requests */
@property (nonatomic, getter = isPendingApproval) BOOL pendingApproval;
/** Incoming subscription requests mean this object is a stub/placeholder */
@property (nonatomic) BOOL hasIncomingSubscriptionRequest;

- (void)setStatus:(OTRThreadStatus)status forResource:(NSString *)resource;

@end
