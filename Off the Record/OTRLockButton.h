//
//  OTRLockButton.h
//  Off the Record
//
//  Created by David Chiles on 2/10/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OTRLockStatus) {
    OTRLockStatusLocked,
    OTRLockStatusLockedAndVerified,
    OTRLockStatusLockedAndWarn,
    OTRLockStatusLockedAndError,
    OTRLockStatusUnlocked,
    
};

@interface OTRLockButton : UIButton

@property (nonatomic) OTRLockStatus lockStatus;

+(instancetype)lockButtonWithInitailLockStatus:(OTRLockStatus)lockStatus withBlock:(void(^)())block;

@end
