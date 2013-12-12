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
#import "OTRConstants.h"
#import "OTRManagedXMPPAccount.h"
#import "OTRManagedOscarAccount.h"


#import "OTRXMPPLoginViewController.h"
#import "OTRJabberLoginViewController.h"
#import "OTRFacebookLoginViewController.h"
#import "OTROscarLoginViewController.h"
#import "OTRGoogleTalkLoginViewController.h"
#import "OTRInLineTextEditTableViewCell.h"
#import "OTRErrorManager.h"

#import "OTRCertificatePinning.h"

#define kFieldBuffer 20;

#define kErrorAlertViewTag 131
#define kErrorInfoAlertViewTag 132
#define kErrorCertAlertViewTag 133
#define kNewCertAlertViewTag 134

@interface OTRLoginViewController(Private)
- (float) getMidpointOffsetforHUD;
@end

@implementation OTRLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton, cancelButton;
@synthesize rememberPasswordSwitch;
@synthesize logoView;
@synthesize timeoutTimer;
@synthesize account;
@synthesize isNewAccount;
@synthesize loginViewTableView;
@synthesize textFieldTextColor;

@synthesize tableViewArray;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOTRProtocolLoginFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOTRProtocolLoginSuccess object:nil];
    self.logoView = nil;
    self.rememberPasswordSwitch = nil;
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.loginButton = nil;
    self.cancelButton = nil;
    [timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.account = nil;
    self.textFieldTextColor = nil;
}

- (id) initWithAccountID:(NSManagedObjectID *)newAccountID {
    if (self = [super init]) {
        NSManagedObjectContext * context = [NSManagedObjectContext MR_contextForCurrentThread];
        self.account = (OTRManagedAccount *)[context existingObjectWithID:newAccountID error:nil];
        
        //DDLogInfo(@"Account Dictionary: %@",[account accountDictionary]);
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            self.textFieldTextColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
        }
        else {
            self.textFieldTextColor = [UIColor colorWithRed:0 green:0.47843137 blue:1 alpha:1];
        }
        
    }
    return self;
}

-(void)setUpFields
{
    //tableViewArray = [[NSMutableArray alloc] init];
    
    
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.delegate = self;
    //self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.text = account.username;
    self.usernameTextField.returnKeyType = UIReturnKeyDone;
    self.usernameTextField.textColor = self.textFieldTextColor;
    
    [self addCellinfoWithSection:0 row:0 labelText:USERNAME_STRING cellType:kCellTypeTextField userInputView:self.usernameTextField];
    
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.delegate = self;
    //self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.textColor = self.textFieldTextColor;
    self.passwordTextField.placeholder = REQUIRED_STRING;
    
    [self addCellinfoWithSection:0 row:1 labelText:PASSWORD_STRING cellType:kCellTypeTextField userInputView:self.passwordTextField];
    
    self.rememberPasswordSwitch = [[UISwitch alloc] init];
    
    
    [self addCellinfoWithSection:0 row:2 labelText:REMEMBER_PASSWORD_STRING cellType:kCellTypeSwitch userInputView:self.rememberPasswordSwitch];
    
    
    NSString *loginButtonString = LOGIN_STRING;
    self.title = [account providerName];
    
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:loginButtonString style:UIBarButtonItemStyleDone target:self action:@selector(loginButtonPressed:)];
    self.navigationItem.rightBarButtonItem = loginButton;
    
    if (!isNewAccount) {
        self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:CANCEL_STRING style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
}

-(void)addCellinfoWithSection:(NSInteger)section row:(NSInteger)row labelText:(id)text cellType:(NSString *)type userInputView:(UIView *)inputView;
{
    if (!tableViewArray) {
        self.tableViewArray = [[NSMutableArray alloc] init];
        //[self.tableViewArray setObject:[[NSMutableArray alloc] init] atIndexedSubscript:section];
        
    }
    if ([self.tableViewArray count]<(section+1)) {
        [self.tableViewArray setObject:[[NSMutableArray alloc] init] atIndexedSubscript:section];
    }
    
    NSDictionary * cellDictionary = [NSDictionary dictionaryWithObjectsAndKeys:text,kTextLabelTextKey,type,kCellTypeKey,inputView,kUserInputViewKey, nil];
    
    [[tableViewArray objectAtIndex:section] insertObject:cellDictionary atIndex:row];
    
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
    
    
    loginViewTableView= [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    loginViewTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [loginViewTableView setDelegate:self];
    [loginViewTableView setDataSource:self];
    [self.view addSubview:loginViewTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableViewArray count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [[tableViewArray objectAtIndex:section] count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([tableViewArray count] > 1)
    {
        if(section == 0)
            return BASIC_STRING;
        else if (section == 1)
            return ADVANCED_STRING;
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[[tableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kCellTypeKey] isEqualToString:KCellTypeHelp])
    {
        CGFloat height = ((UILabel *)[[[tableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kTextLabelTextKey]).frame.size.height+10;
        return height;
    }
    return 44.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * cellDictionary = [[tableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString * cellType = [cellDictionary objectForKey:kCellTypeKey];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    
    if( [cellType isEqualToString:kCellTypeSwitch])
    {
        if(cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellType];
        }
        cell.textLabel.text = [cellDictionary objectForKey:kTextLabelTextKey];
        cell.accessoryView=[cellDictionary objectForKey:kUserInputViewKey];
        
    }
    else if( [cellType isEqualToString:KCellTypeHelp])
    {
        if(cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellType];
            
            [cell.contentView addSubview:[cellDictionary objectForKey:kTextLabelTextKey]];
            cell.accessoryView = [cellDictionary objectForKey:kUserInputViewKey];
        }
        
    }
    else if([cellType isEqualToString:kCellTypeTextField])
    {
        if(cell == nil)
        {
            cell = [[OTRInLineTextEditTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellType];
        }
        cell.textLabel.text = [cellDictionary objectForKey:kTextLabelTextKey];
        [cell layoutIfNeeded];
        ((OTRInLineTextEditTableViewCell *)cell).textField = [cellDictionary objectForKey:kUserInputViewKey];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    if(!self.usernameTextField.text || [self.usernameTextField.text isEqualToString:@""])
    {
        [self.usernameTextField becomeFirstResponder];
    }
    else {
        [self.passwordTextField becomeFirstResponder];
    }
    
    
    self.rememberPasswordSwitch.on = self.account.rememberPasswordValue;
    if (account.rememberPassword) {
        self.passwordTextField.text = account.password;
    } else {
        self.passwordTextField.text = @"";
    }
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self readInFields];
    
    if([account.username length] && [account.password length] )
    {
        
        [[[OTRProtocolManager sharedInstance] accountsManager] addAccount:account];
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    }
    [self.view resignFirstResponder];

}

-(void)readInFields
{
    [account setNewUsername:[usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [account setRememberPasswordValue:rememberPasswordSwitch.on];
    
    if (account.rememberPasswordValue) {
        account.password = self.passwordTextField.text;
    } else {
        account.password = nil;
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
        UIAlertView *alert = nil;
        NSDictionary * userInfo = notification.userInfo;
        id error = userInfo[kOTRProtocolLoginFailErrorKey];
        NSData * certData = userInfo[kOTRProtocolLoginFailSSLCertificateDataKey];
        NSString * hostname = userInfo[kOTRProtocolLoginFailHostnameKey];
        NSNumber * statusNumber = userInfo[kOTRProtocolLoginFailSSLStatusKey];
        
        NSInteger tag = kErrorAlertViewTag;
        if (certData) {
            [self showCertWarningForData:certData withHostName:hostname withStatus:[statusNumber longValue]];
        }
        else if ([error isKindOfClass:[NSError class]]) {
            recentError = (NSError *)error;
            NSString * msg = XMPP_FAIL_STRING;
            
            if([recentError.domain isEqualToString:@"kCFStreamErrorDomainSSL"] && recentError.code == errSSLPeerBadCert) {
                //cert matching error
                msg = [NSString stringWithFormat:XMPP_CERT_FAIL_STRING,((OTRManagedXMPPAccount *)account).accountDomain];
                tag = kErrorCertAlertViewTag;
                //The Cert has changed
                OTRXMPPManager * protocol = (OTRXMPPManager *)[[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
                protocol.certificatePinningModule.doNotManuallyEvaluateOverride = YES;
                //[self loginButtonPressed:nil];
                //alert = [[UIAlertView alloc] initWithTitle:ERROR_STRING message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:DISMISS_STRING,CONNECT_ANYWAY_STRING, nil];
            }
            else {
                alert = [[UIAlertView alloc] initWithTitle:ERROR_STRING message:XMPP_FAIL_STRING delegate:self cancelButtonTitle:nil otherButtonTitles:OK_STRING,INFO_STRING, nil];
            }
            
        }
        else if (error)
        {
            //could not authenicate
            alert = [[UIAlertView alloc] initWithTitle:ERROR_STRING message:XMPP_FAIL_STRING delegate:nil cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
            
        }
        else {
            alert = [[UIAlertView alloc] initWithTitle:ERROR_STRING message:XMPP_FAIL_STRING delegate:nil cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
        }
        alert.tag = tag;
        [alert show];
    }
}
             
- (void)showCertWarningForData:(NSData *)certData withHostName:(NSString *)hostname withStatus:(OSStatus)status {
    lastCertData = certData;
    lastStatus = status;
    lastHostname = hostname;
    SecCertificateRef certificate = [OTRCertificatePinning certForData:certData];
    NSString * fingerprint = [OTRCertificatePinning sha1FingerprintForCertificate:certificate];
    NSString * message = [NSString stringWithFormat:@"SHA1: %@\n",fingerprint];
    message = [message stringByAppendingString:[OTRErrorManager errorStringWithSSLStatus:status]];
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"New Cert: %@",hostname] message:message delegate:self cancelButtonTitle:@"Bad Cert" otherButtonTitles:@"Good Cert", nil];
    alertview.tag = kNewCertAlertViewTag;
    
    [alertview show];
}

-(void)protocolLoginSuccess:(NSNotification*)notification
{
    if(HUD)
        [HUD hide:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}  



- (void)loginButtonPressed:(id)sender {
    BOOL fields = [self checkFields];
    if(fields)
    {
        [self showLoginProgress];
        
        [self readInFields];

        self.account.password = passwordTextField.text;
        
        id<OTRProtocol> protocol = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
        [protocol connectWithPassword:self.passwordTextField.text];
    }
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
    //[[[OTRProtocolManager sharedInstance] accountsManager] addAccount:account];
}
-(void)showLoginProgress
{
    [self.view endEditing:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOGGING_IN_STRING;
    [HUD show:YES];
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
}

- (void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
    [textField resignFirstResponder];
    return YES;
}

-(void) didMoveToParentViewController:(UIViewController *)parent
{
    //Delete Account because user went back to choose different account type
    if(!parent)
    {
        [[OTRProtocolManager sharedInstance].accountsManager removeAccount:self.account];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kErrorAlertViewTag) {
        if(alertView.numberOfButtons > 1 && buttonIndex == 1) {
            NSString * errorDescriptionString = [NSString stringWithFormat:@"%@ : %@",[recentError domain],[recentError localizedDescription]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:INFO_STRING message:errorDescriptionString delegate:self cancelButtonTitle:nil otherButtonTitles:OK_STRING,@"Copy", nil];
            alert.tag = kErrorInfoAlertViewTag;
            [alert show];
        }
    }
    else if (alertView.tag == kErrorInfoAlertViewTag) {
        if (buttonIndex == 1) {
            NSString * errorDescriptionString = [NSString stringWithFormat:@"Domain: %@\nCode: %d\nUserInfo: %@",[recentError domain],[recentError code],[recentError userInfo]];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setString:errorDescriptionString];
        }
    }
    else if (alertView.tag == kErrorCertAlertViewTag && buttonIndex == 1)
    {
        id<OTRProtocol> protocol = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
        if ([protocol isKindOfClass:[OTRXMPPManager class]]) {
            //[((OTRXMPPManager *)protocol) setManualyEvaluateTrust:NO];
            [self loginButtonPressed:nil];
        }
        
    }
    else if (alertView.tag == kNewCertAlertViewTag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            //add new cert
            id<OTRProtocol> protocol = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
            if ([protocol isKindOfClass:[OTRXMPPManager class]]) {
                [((OTRXMPPManager *)protocol).certificatePinningModule addCertificate:[OTRCertificatePinning certForData:lastCertData] withHostName:lastHostname];
            }
        }
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

+(OTRLoginViewController *)loginViewControllerWithAcccountID:(NSManagedObjectID *)accountID
{
    NSManagedObjectContext * context = [NSManagedObjectContext MR_contextForCurrentThread];
    OTRManagedAccount * account = (OTRManagedAccount *)[context existingObjectWithID:accountID error:nil];
    switch (account.accountType) {
        case OTRAccountTypeAIM:
            return [[OTROscarLoginViewController alloc] initWithAccountID:accountID];
            break;
        case OTRAccountTypeJabber:
            return [[OTRJabberLoginViewController alloc] initWithAccountID:accountID];
            break;
        case OTRAccountTypeFacebook:
            return [[OTRFacebookLoginViewController alloc] initWithAccountID:accountID];
            break;
        case OTRAccountTypeGoogleTalk:
            return [[OTRGoogleTalkLoginViewController alloc] initWithAccountID:accountID];
            break;
        default:
            break;
    }
}

@end
