//
//  OTRLoginViewController.h
//  Off the Record
//
//  Created by Chris Ballinger on 8/12/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTRProtocolManager.h"
#import "MBProgressHUD.h"

@interface OTRLoginViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

- (id) initWithAccount:(OTRAccount*)newAccount;

@property (nonatomic, retain) OTRAccount *account;
@property (nonatomic) BOOL useXMPP;

@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UILabel *passwordLabel;
@property (nonatomic, retain) UILabel *rememberPasswordLabel;
@property (nonatomic, retain) UISwitch *rememberPasswordSwitch;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *usernameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;

@property (nonatomic, retain) UIBarButtonItem *loginButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;

@property (nonatomic, strong) NSTimer * timeoutTimer;

- (void)loginButtonPressed:(id)sender;
- (void)cancelPressed:(id)sender;

-(BOOL)checkFields;

@end
