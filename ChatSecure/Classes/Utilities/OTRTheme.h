//
//  OTRTheme.h
//  ChatSecure
//
//  Created by Christopher Ballinger on 6/10/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

@import Foundation;
@import UIKit;
@import JSQMessagesViewController;

@class OTRAccount;

NS_ASSUME_NONNULL_BEGIN
@interface OTRTheme : NSObject

@property (nonatomic, strong) UIColor *mainThemeColor;
@property (nonatomic, strong) UIColor *lightThemeColor;
@property (nonatomic, strong) UIColor *buttonLabelColor;

/** Set global app appearance via UIAppearance */
- (void) setupGlobalTheme;

/** Returns new instance. Override this in subclass to use a different conversation view controller class */
- (__kindof UIViewController*) conversationViewController;

/** Returns new instance. Override this in subclass to use a different message view controller class */
- (__kindof JSQMessagesViewController *) messagesViewController;

/** Returns new instance. Override this in subclass to use a different group message view controller class */
- (__kindof JSQMessagesViewController *) groupMessagesViewController;

/** Returns new instance. Override this in subclass to use a different settings view controller class */
- (__kindof UIViewController *) settingsViewController;

/** Returns new instance. Override this in subclass to use a different compose view controller class */
- (__kindof UIViewController *) composeViewController;

/** Returns new instance. Override this in subclass to use a different invite view controller class */
- (__kindof UIViewController* ) inviteViewControllerForAccount:(OTRAccount*)account;

/** Override this to disable OMEMO message encryption. default: YES */
- (BOOL) enableOMEMO;

@end
NS_ASSUME_NONNULL_END
