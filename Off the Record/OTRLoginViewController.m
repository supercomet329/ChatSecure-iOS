//
//  OTRLoginViewController.m
//  Off the Record
//
//  Created by Chris Ballinger on 8/12/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//
//  This file is part of ChatSecure.
//
//  ChatSecure is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ChatSecure is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ChatSecure.  If not, see <http://www.gnu.org/licenses/>.

#import "OTRLoginViewController.h"
#import "Strings.h"
#import "OTRUIKeyboardListener.h"
#import "OTRConstants.h"
#import "OTRXMPPAccount.h"
#import "OTRAppDelegate.h"

#define kFieldBuffer 20;

@implementation OTRLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton, cancelButton;
@synthesize rememberPasswordSwitch;
@synthesize usernameLabel, passwordLabel, rememberPasswordLabel;
@synthesize logoView;
@synthesize timeoutTimer;
@synthesize account;
@synthesize domainLabel,domainTextField;
@synthesize facebookInfoButton;
@synthesize isNewAccount;
@synthesize basicAdvancedSegmentedControl;
@synthesize sslMismatchLabel,sslMismatchSwitch,selfSignedLabel,selfSignedSwitch;
@synthesize portLabel, portTextField;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOTRProtocolLoginFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOTRProtocolLoginSuccess object:nil];
    self.logoView = nil;
    self.usernameLabel = nil;
    self.passwordLabel = nil;
    self.rememberPasswordLabel = nil;
    self.rememberPasswordSwitch = nil;
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.loginButton = nil;
    self.cancelButton = nil;
    [timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.account = nil;
    self.domainTextField = nil;
    self.domainLabel = nil;
    self.basicAdvancedSegmentedControl = nil;
    self.selfSignedLabel = nil;
    self.selfSignedSwitch = nil;
    self.sslMismatchLabel = nil;
    self.sslMismatchSwitch = nil;
    self.portLabel = nil;
    self.portTextField = nil;
}

- (id) initWithAccount:(OTRAccount*)newAccount {
    if (self = [super init]) {
        self.account = newAccount;
        
        NSLog(@"Account Dictionary: %@",[account accountDictionary]);
    }
    return self;
}

-(void)setUpFields
{
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.delegate = self;
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.text = account.username;
    
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.delegate = self;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    
    self.rememberPasswordSwitch = [[UISwitch alloc] init];
    
    NSString *loginButtonString = LOGIN_STRING;
    self.title = [account providerName];
    
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:loginButtonString style:UIBarButtonItemStyleDone target:self action:@selector(loginButtonPressed:)];
    self.navigationItem.rightBarButtonItem = loginButton;
    
    if (!isNewAccount) {
        self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:CANCEL_STRING style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    NSString * accountDomainString = [[self.account accountDictionary] objectForKey:kOTRAccountDomainKey];
    
    if ([accountDomainString isEqualToString:kOTRGoogleTalkDomain]) {
        self.usernameTextField.placeholder = GOOGLE_TALK_EXAMPLE_STRING;
    }
    else if([accountDomainString isEqualToString:kOTRFacebookDomain])
    {
        facebookHelpLabel = [[UILabel alloc] init];
        facebookHelpLabel.text = FACEBOOK_HELP_STRING;
        facebookHelpLabel.textAlignment = UITextAlignmentLeft;
        facebookHelpLabel.lineBreakMode = UILineBreakModeWordWrap;
        facebookHelpLabel.numberOfLines = 0;
        facebookHelpLabel.font = [UIFont systemFontOfSize:14];
        
        self.facebookInfoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [self.facebookInfoButton addTarget:self action:@selector(facebookInfoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:facebookHelpLabel];
        [self.view addSubview:facebookInfoButton];
        
        self.usernameTextField.placeholder = @"";
    }
    else if([account.protocol isEqualToString:kOTRProtocolTypeXMPP])
    {
        self.usernameTextField.placeholder = @"user@example.com";
        
        self.domainTextField = [[UITextField alloc] init];
        self.domainTextField.delegate = self;
        self.domainTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.domainTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.domainTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.domainTextField.placeholder = OPTIONAL_STRING;
        self.domainTextField.text = accountDomainString;
        
        self.sslMismatchSwitch = [[UISwitch alloc]init];
        self.selfSignedSwitch = [[UISwitch alloc] init];
        
        self.portTextField = [[UITextField alloc] init];
        self.portTextField.delegate = self;
        self.portTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.portTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.portTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.portTextField.placeholder = [NSString stringWithFormat:@"%@",[[self.account accountDictionary] objectForKey:kOTRXMPPAccountPortNumber]];
    }
    
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(protocolLoginFailed:)
     name:kOTRProtocolLoginFail
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(protocolLoginSuccess:)
     name:kOTRProtocolLoginSuccess
     object:nil ];
    
    [self setUpFields];
    
    
    UITableView * loginTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    loginTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [loginTableView setDelegate:self];
    [loginTableView setDataSource:self];
    [self.view addSubview:loginTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString * domainValueString = [[self.account accountDictionary] objectForKey:kOTRAccountDomainKey];
    if ([domainValueString isEqualToString:kOTRFacebookDomain] || [domainValueString isEqualToString:kOTRGoogleTalkDomain] || [[[self.account accountDictionary] objectForKey:kOTRAccountProtocolKey] isEqualToString:kOTRProtocolTypeAIM])
    {
        return 1;
    }
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if ([[[self.account accountDictionary] objectForKey:kOTRAccountDomainKey] isEqualToString:kOTRFacebookDomain]) {
            return 4;
        }
        return 3;
    }
    return 3;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView.numberOfSections > 0)
    {
        if(section == 0)
            return BASIC_STRING;
        else if (section == 1)
            return ADVANCED_STRING;
    }
    return @"";
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * usernameTextFieldIdentifier = @"usernameTextFieldCell";
    NSString * passwordTextFieldIdentifier = @"passwordTextFieldCell";
    NSString * domainTextFieldIdentifier = @"domainTextFieldCell";
    NSString * faceBookHelpIdentifier = @"faceBookHelpIdentifier";
    NSString * switchIdentifier = @"switchIdentifier";
    //NSString * textFieldIdentifier = @"textFieldCell";
    
    UITableViewCell * cell;
    
    if(indexPath.section == 0)
    {
        if( indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:usernameTextFieldIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:usernameTextFieldIdentifier];
            }
            
            cell.textLabel.text = USERNAME_STRING;
            [cell layoutIfNeeded];
            self.usernameTextField.frame = CGRectMake(cell.textLabel.frame.size.width+10, cell.textLabel.frame.origin.y, 200, cell.contentView.frame.size.height-20);
            self.usernameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            self.usernameTextField.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:self.usernameTextField];
        }
        else if(indexPath.row == 1 && [[[self.account accountDictionary] objectForKey:kOTRAccountDomainKey] isEqualToString:kOTRFacebookDomain])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:faceBookHelpIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:faceBookHelpIdentifier];
                
                facebookHelpLabel = [[UILabel alloc] init];
                facebookHelpLabel.text = FACEBOOK_HELP_STRING;
                facebookHelpLabel.textAlignment = UITextAlignmentLeft;
                facebookHelpLabel.lineBreakMode = UILineBreakModeWordWrap;
                facebookHelpLabel.numberOfLines = 0;
                facebookHelpLabel.font = [UIFont systemFontOfSize:14];
                facebookHelpLabel.backgroundColor = [UIColor clearColor];
                facebookHelpLabel.frame = CGRectMake(5, 5, 250, 40);
                facebookHelpLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                
                self.facebookInfoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
                [self.facebookInfoButton addTarget:self action:@selector(facebookInfoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                self.facebookInfoButton.frame = CGRectMake(0, 0, self.facebookInfoButton.frame.size.width, self.facebookInfoButton.frame.size.height);
                
                [cell.contentView addSubview:facebookHelpLabel];
                cell.accessoryView = facebookInfoButton;
            }
            
            
        }
        else if (indexPath.row == 1 || ( indexPath.row == 2 && [[[self.account accountDictionary] objectForKey:kOTRAccountDomainKey] isEqualToString:kOTRFacebookDomain]))
        {
            cell = [tableView dequeueReusableCellWithIdentifier:passwordTextFieldIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:passwordTextFieldIdentifier];
            }
            
            
            cell.textLabel.text = PASSWORD_STRING;
            [cell layoutIfNeeded];
            self.passwordTextField.frame = CGRectMake(cell.textLabel.frame.size.width+10, cell.textLabel.frame.origin.y, 200, cell.contentView.frame.size.height-20);
            self.passwordTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            self.passwordTextField.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:self.passwordTextField];
        }
        else if (indexPath.row == 2 || ( indexPath.row == 3 && [[[self.account accountDictionary] objectForKey:kOTRAccountDomainKey] isEqualToString:kOTRFacebookDomain]))
        {
            cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:switchIdentifier];
            }
            [cell layoutIfNeeded];
            
            cell.textLabel.text = REMEMBER_PASSWORD_STRING;
            cell.accessoryView = self.rememberPasswordSwitch;
        }
        
    }
    else if(indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:domainTextFieldIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:domainTextFieldIdentifier];
            
        }
        
        if( indexPath.row == 0)
        {
            cell.textLabel.text = DOMAIN_STRING;
            [cell layoutIfNeeded];
            self.domainTextField.frame = CGRectMake(cell.textLabel.frame.size.width+10, cell.textLabel.frame.origin.y, 200, cell.contentView.frame.size.height-20);
            self.domainTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            
            [cell.contentView addSubview:self.domainTextField];
        }
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:switchIdentifier];
            }
            cell.textLabel.text = SSL_MISMATCH_STRING;
            cell.accessoryView = sslMismatchSwitch;
        }
        else if (indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:switchIdentifier];
            }
            cell.textLabel.text = SELF_SIGNED_SSL_STRING;
            cell.accessoryView = selfSignedSwitch;
        }

        
    }
    
    
    
    //cell.userInteractionEnabled = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGSize) textSizeForLabel:(UILabel*)label {
    return [label.text sizeWithFont:label.font];
}

- (CGRect) textFieldFrameForLabel:(UILabel*)label {
    return CGRectMake(label.frame.origin.x + label.frame.size.width + 5, label.frame.origin.y, self.view.frame.size.width - label.frame.origin.x - label.frame.size.width - 10, 31);
}


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    //double scale = 0.75;
    //CGFloat logoViewFrameWidth = (int)(self.logoView.image.size.width * scale);
    //self.logoView.frame = CGRectMake(self.view.frame.size.width/2 - logoViewFrameWidth/2, 5, logoViewFrameWidth, (int)(self.logoView.image.size.height * scale));
    //self.logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    padding.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    if (self.basicAdvancedSegmentedControl) {
        self.basicAdvancedSegmentedControl.frame = CGRectMake(1, 1, 200, 28);
        self.basicAdvancedSegmentedControl.center = CGPointMake(self.view.center.x, self.basicAdvancedSegmentedControl.center.y);
        //padding.frame = CGRectMake(0, 0, self.view.frame.size.width, 32)
    }
    
    CGFloat usernameLabelFrameYOrigin = padding.frame.origin.y + padding.frame.size.height;
    CGSize usernameLabelTextSize = [self textSizeForLabel:usernameLabel];
    CGSize passwordLabelTextSize = [self textSizeForLabel:passwordLabel];
    CGSize domainLabelTextSize = [self textSizeForLabel:domainLabel];
    CGFloat labelWidth = MAX( MAX(usernameLabelTextSize.width, passwordLabelTextSize.width),domainLabelTextSize.width);

    self.usernameLabel.frame = CGRectMake(10, usernameLabelFrameYOrigin, labelWidth, 21);
    self.usernameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    self.usernameTextField.frame = [self textFieldFrameForLabel:usernameLabel];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    if ([account.protocol isEqualToString:kOTRProtocolTypeXMPP]) {
        self.usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    self.usernameTextField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    CGFloat passwordLabelFrameYOrigin;
    if(self.domainLabel && self.domainTextField && self.basicAdvancedSegmentedControl)
    {
        //CGFloat domainLabelFrameYOrigin = usernameLabelFrameYOrigin + self.usernameLabel.frame.size.height +kFieldBuffer;
        self.domainLabel.frame = CGRectMake(10, usernameLabelFrameYOrigin, labelWidth, 21);
        self.domainLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.domainLabel setHidden:YES];
        
        self.domainTextField.frame = [self textFieldFrameForLabel:domainLabel];
        self.domainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.domainTextField.keyboardType = UIKeyboardTypeURL;
        self.domainTextField.returnKeyType = UIReturnKeyGo;
        self.domainTextField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.domainTextField setHidden:YES];
        
        CGFloat sslMismatchLabelFrameYOrigin = domainLabel.frame.origin.y + domainLabel.frame.size.height + kFieldBuffer;
        self.sslMismatchLabel.frame = CGRectMake(10, sslMismatchLabelFrameYOrigin, 200, 21);
        self.sslMismatchLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.sslMismatchLabel setHidden:YES];
        
        
        CGFloat sslMismatchSwitchFrameWidth = 79;
        self.sslMismatchSwitch.frame = CGRectMake(self.view.frame.size.width-sslMismatchSwitchFrameWidth-5, sslMismatchLabelFrameYOrigin, sslMismatchSwitchFrameWidth, 27);
        self.sslMismatchSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.sslMismatchSwitch setHidden:YES];
        
        
        CGFloat selfSignedFrameYOrigin = sslMismatchLabel.frame.origin.y + sslMismatchLabel.frame.size.height + kFieldBuffer;
        self.selfSignedLabel.frame = CGRectMake(10, selfSignedFrameYOrigin, 180, 21);
        self.selfSignedLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.selfSignedLabel setHidden:YES];
        
        
        CGFloat selfSignedSwitchFrameWidth = 79;
        self.selfSignedSwitch.frame = CGRectMake(self.view.frame.size.width-selfSignedSwitchFrameWidth-5, selfSignedFrameYOrigin, selfSignedSwitchFrameWidth, 27);
        self.selfSignedSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.selfSignedSwitch setHidden:YES];
        
        OTRXMPPAccount *xmppAccount = (OTRXMPPAccount*)self.account;
        
        self.domainTextField.text = xmppAccount.domain;
        self.sslMismatchSwitch.on = xmppAccount.allowSSLHostNameMismatch;
        self.selfSignedSwitch.on = xmppAccount.allowSelfSignedSSL;
        self.portTextField.text = [NSString stringWithFormat:@"%d", xmppAccount.port];
        
        CGFloat portYOrigin = self.selfSignedLabel.frame.origin.y + self.selfSignedLabel.frame.size.height + kFieldBuffer;
        CGFloat edgePadding = 10.0f;

        self.portLabel.frame = CGRectMake(edgePadding, portYOrigin, self.view.frame.size.width/2-edgePadding, 21);
        self.portTextField.frame = CGRectMake(self.view.frame.size.width/2, portYOrigin, self.view.frame.size.width/2-edgePadding, 21);
        [portLabel setHidden:YES];
        [portTextField setHidden:YES];
        
        self.portTextField.frame = [self textFieldFrameForLabel:portLabel];
        self.portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.portTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.portTextField.returnKeyType = UIReturnKeyGo;
        self.portTextField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        //passwordLabelFrameYOrigin = domainLabelFrameYOrigin + self.domainLabel.frame.size.height +kFieldBuffer;
        passwordLabelFrameYOrigin = usernameLabelFrameYOrigin + self.usernameLabel.frame.size.height + kFieldBuffer;
        
    }
    else if (facebookHelpLabel)
    {
        CGFloat facebookHelpLabeFrameYOrigin = usernameLabelFrameYOrigin + self.usernameLabel.frame.size.height +kFieldBuffer;
        
        //facebookHelpLabel.frame = CGRectMake(10, facebookHelpLabeFrameYOrigin, self.view.frame.size.width-40, 21);
        
        CGSize maximumLabelSize = CGSizeMake(296,9999);
        
        CGSize expectedLabelSize = [facebookHelpLabel.text sizeWithFont:facebookHelpLabel.font constrainedToSize:maximumLabelSize lineBreakMode:facebookHelpLabel.lineBreakMode];   
        
        //adjust the label the the new height.
        CGRect newFrame = facebookHelpLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        facebookHelpLabel.frame = newFrame;
        
        
        
        facebookHelpLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        CGSize infoButtonSize = self.facebookInfoButton.frame.size;
        CGFloat facebookInfoButtonFrameYOrigin = floorf(facebookHelpLabeFrameYOrigin + (expectedLabelSize.height - infoButtonSize.height)/2);
        
        self.facebookInfoButton.frame = CGRectMake(facebookHelpLabel.frame.origin.x + facebookHelpLabel.frame.size.width, facebookInfoButtonFrameYOrigin, infoButtonSize.width, infoButtonSize.height);
        
        passwordLabelFrameYOrigin = facebookHelpLabeFrameYOrigin +facebookHelpLabel.frame.size.height +kFieldBuffer;
    }
    else {
        passwordLabelFrameYOrigin = usernameLabelFrameYOrigin + self.usernameLabel.frame.size.height + kFieldBuffer;
    }
    
    self.passwordLabel.frame = CGRectMake(10, passwordLabelFrameYOrigin, labelWidth, 21);
    self.passwordLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    self.passwordTextField.frame = [self textFieldFrameForLabel:passwordLabel];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    CGFloat rememberUsernameLabelFrameYOrigin = passwordLabel.frame.origin.y + passwordLabel.frame.size.height + kFieldBuffer;
    self.rememberPasswordLabel.frame = CGRectMake(10, rememberUsernameLabelFrameYOrigin, 170, 21);
    self.rememberPasswordLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    CGFloat rememberUserNameSwitchFrameWidth = 79;
    self.rememberPasswordSwitch.frame = CGRectMake(self.view.frame.size.width-rememberUserNameSwitchFrameWidth-5, rememberUsernameLabelFrameYOrigin, rememberUserNameSwitchFrameWidth, 27);
    self.rememberPasswordSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if(!self.usernameTextField.text || [self.usernameTextField.text isEqualToString:@""])
    {
        [self.usernameTextField becomeFirstResponder];
    }
    else {
        [self.passwordTextField becomeFirstResponder];
    }
    
    
    self.rememberPasswordSwitch.on = self.account.rememberPassword;
    if (account.rememberPassword) {
        self.passwordTextField.text = account.password;
    } else {
        self.passwordTextField.text = @"";
    }
}

-(void) segmentedControlChanged
{
    //baseic setup
    if([basicAdvancedSegmentedControl selectedSegmentIndex]==0)
    {
        [self.domainLabel setHidden:YES];
        [self.domainTextField setHidden:YES];
        [self.usernameTextField becomeFirstResponder];
        [self.sslMismatchSwitch setHidden:YES];
        [self.sslMismatchLabel setHidden:YES];
        [self.selfSignedLabel setHidden:YES];
        [self.selfSignedSwitch setHidden:YES];
        [self.portTextField setHidden:YES];
        [self.portLabel setHidden:YES];
        
        [self.usernameLabel setHidden:NO];
        [self.usernameTextField setHidden:NO];
        [self.rememberPasswordLabel setHidden:NO];
        [self.rememberPasswordSwitch setHidden:NO];
        [self.passwordLabel setHidden:NO];
        [self.passwordTextField setHidden:NO];
        
    }
    else //advanced setup
    {
        [self.domainLabel setHidden:NO];
        [self.domainTextField setHidden:NO];
        [self.domainTextField becomeFirstResponder];
        [self.sslMismatchSwitch setHidden:NO];
        [self.sslMismatchLabel setHidden:NO];
        [self.selfSignedLabel setHidden:NO];
        [self.selfSignedSwitch setHidden:NO];
        [self.portTextField setHidden:NO];
        [self.portLabel setHidden:NO];
        
        
        [self.usernameLabel setHidden:YES];
        [self.usernameTextField setHidden:YES];
        [self.rememberPasswordLabel setHidden:YES];
        [self.rememberPasswordSwitch setHidden:YES];
        [self.passwordLabel setHidden:YES];
        [self.passwordTextField setHidden:YES];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    account.username = self.usernameTextField.text;
    account.rememberPassword = rememberPasswordSwitch.on;
    
    if([account isKindOfClass:[OTRXMPPAccount class]])
    {
        ((OTRXMPPAccount *)account).allowSelfSignedSSL = selfSignedSwitch.on;
        ((OTRXMPPAccount *)account).allowSSLHostNameMismatch = sslMismatchSwitch.on;
    }
    
    
    if (account.rememberPassword) {
        account.password = self.passwordTextField.text;
    } else {
        account.password = nil;
    }
    
    if([account.username length]!=0 && [account.password length] !=0 )
    {
        [account save];
        [[[OTRProtocolManager sharedInstance] accountsManager] addAccount:account];
    }
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(HUD)
        [HUD hide:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
}

-(void) timeout:(NSTimer *) timer
{
    //[timeoutTimer invalidate];
    if (HUD) {
        [HUD hide:YES];
    }
}

-(void)protocolLoginFailed:(NSNotification*)notification
{
    if(HUD)
        [HUD hide:YES];
    if([account.protocol isEqualToString:kOTRProtocolTypeXMPP])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_STRING message:XMPP_FAIL_STRING delegate:nil cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
        [alert show];
    }
}

-(void)protocolLoginSuccess:(NSNotification*)notification
{
    if(HUD)
        [HUD hide:YES];
    [self dismissModalViewControllerAnimated:YES];
    /* not sure why this was ever needed
    if([account.protocol isEqualToString:kOTRProtocolTypeXMPP])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"XMPPLoginNotification"
         object:self];
        [timeoutTimer invalidate];
    }
     */
}  


- (void)loginButtonPressed:(id)sender {
    BOOL fields = [self checkFields];
    if(fields)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = LOGGING_IN_STRING;
        float hudOffsetY = [self getMidpointOffsetforHUD];
        HUD.yOffset = hudOffsetY;
        [HUD show:YES];
        
        NSString * usernameText = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString * domainText = [domainTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([account isKindOfClass:[OTRXMPPAccount class]]) {
            OTRXMPPAccount *xmppAccount = (OTRXMPPAccount*) account;
            if([xmppAccount.domain isEqualToString:kOTRFacebookDomain])
            {
                usernameText = [NSString stringWithFormat:@"%@@%@",usernameText,kOTRFacebookDomain];
            }
            if([domainText length])
            {
                xmppAccount.domain = domainText;
            }
            int portNumber = [self.portTextField.text intValue];
            if (portNumber > 0 && portNumber <= 65535) {
                xmppAccount.port = portNumber;
            } else {
                xmppAccount.port = [OTRXMPPAccount defaultPortNumber];
            }
        }


        
        self.account.username = usernameText;
        self.account.password = passwordTextField.text;
        

        
        id<OTRProtocol> protocol = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
        [protocol connectWithPassword:self.passwordTextField.text];
    }
    self.timeoutTimer = [NSTimer timerWithTimeInterval:45.0 target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
    [[[OTRProtocolManager sharedInstance] accountsManager] addAccount:account];
    [account save];
}

- (void)cancelPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == portTextField) {
        return [string isEqualToString:@""] ||
        ([string stringByTrimmingCharactersInSet:
          [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0);
    }
    return YES;
}

-(BOOL)checkFields
{
    BOOL fields = usernameTextField.text && ![usernameTextField.text isEqualToString:@""] && passwordTextField.text && ![passwordTextField.text isEqualToString:@""];
    
    if(!fields)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_STRING message:USER_PASS_BLANK_STRING delegate:nil cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
        [alert show];
    }
    
    return fields;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.usernameTextField.isFirstResponder) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (self.domainTextField.isFirstResponder) {
        [self.passwordTextField becomeFirstResponder];
    }
    else
        [self loginButtonPressed:nil];
    
    return NO;
}

-(float)getMidpointOffsetforHUD
{
    OTRUIKeyboardListener * keyboardListenter = [OTRUIKeyboardListener shared];
    CGSize keyboardSize = [keyboardListenter getFrameWithView:self.view].size;
    
    
    
    float viewHeight = self.view.frame.size.height;
    return (viewHeight - keyboardSize.height)/2.0-(viewHeight/2.0);
}

-(void)facebookInfoButtonPressed:(id)sender
{
    UIActionSheet * urlActionSheet = [[UIActionSheet alloc] initWithTitle:kOTRFacebookUsernameLink delegate:self cancelButtonTitle:CANCEL_STRING destructiveButtonTitle:nil otherButtonTitles:OPEN_IN_SAFARI_STRING, nil];
    [OTR_APP_DELEGATE presentActionSheet:urlActionSheet inView:self.view];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSURL *url = [ [ NSURL alloc ] initWithString: kOTRFacebookUsernameLink ];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

@end
