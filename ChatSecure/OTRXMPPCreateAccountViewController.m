//
//  OTRXMPPCreateViewController.m
//  Off the Record
//
//  Created by David Chiles on 12/20/13.
//  Copyright (c) 2013 Chris Ballinger. All rights reserved.
//

#import "OTRXMPPCreateAccountViewController.h"
#import "Strings.h"

#import "HITorManager.h"
#import "OTRAccountsManager.h"
#import "OTRLog.h"
#import "OTRConstants.h"
#import "OTRXMPPAccount.h"
#import "OTRXMPPManager.h"
#import "OTRTextFieldTableViewCell.h"
#import "JVFloatLabeledTextField.h"

static NSString * const domainCellIdentifier = @"domainCellIdentifer";

@interface OTRXMPPCreateAccountViewController ()

@property (nonatomic, strong) NSArray * hostnameArray;
@property (nonatomic, strong) OTRXMPPAccount *account;

@property (nonatomic, strong) UITextField *otherHostnameTextField;

@property (nonatomic) BOOL wasAbleToCreateAccount;

@end

@implementation OTRXMPPCreateAccountViewController

- (id)init
{
    if (self = [super init]) {
        self.otherHostnameTextField = [[UITextField alloc] initWithFrame:CGRectZero]; 
    }
    return self;
}

- (id)initWithHostnames:(NSArray *)newHostnames
{
    self = [self init];
    if (self) {
        self.hostnameArray = newHostnames;
        self.selectedHostnameIndex = 0;
    }
    return self;
}

#pragma - mark View Lifecyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = CREATE_NEW_ACCOUNT_STRING;
	self.usernameTextField.placeholder = USERNAME_STRING;
    self.usernameTextField.keyboardType = UIKeyboardTypeAlphabet;
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    self.loginButton.title = CREATE_STRING;
    
    [self.loginViewTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:domainCellIdentifier];
    [self.loginViewTableView registerClass:[OTRTextFieldTableViewCell class] forCellReuseIdentifier:[OTRTextFieldTableViewCell reuseIdentifier]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wasAbleToCreateAccount = NO;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OTRXMPPRegisterSucceededNotificationName
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        [self didReceiveRegistrationSucceededNotification:note];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OTRXMPPRegisterFailedNotificationName
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        [self didReceiveRegistrationFailedNotification:note];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:OTRXMPPRegisterFailedNotificationName
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:OTRXMPPRegisterSucceededNotificationName
                                                  object:nil];
    if (!self.wasAbleToCreateAccount) {
        [OTRAccountsManager removeAccount:self.account];
    }
}

#pragma - mark UITableViewDelegate Mehtods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hostnameArray.count) {
        return 2;
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.hostnameArray.count+1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return HOSTNAME_STRING;
    }
    return BASIC_STRING;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 44.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = nil;
    if (indexPath.section == 1) {
        if (indexPath.row < [self.hostnameArray count]) {
            cell = [tableView dequeueReusableCellWithIdentifier:domainCellIdentifier forIndexPath:indexPath];
            NSString * hostName = self.hostnameArray[indexPath.row];
            cell.textLabel.text = hostName;
        }
        else
        {
            //Other or Custom Hostname
            OTRTextFieldTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:[OTRTextFieldTableViewCell reuseIdentifier] forIndexPath:indexPath];
            
            [textCell.textField setPlaceholder:@"Custom" floatingTitle:@"Custom"];
            cell = textCell;
        }
        
        if (self.selectedHostnameIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        self.selectedHostnameIndex = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSString *)fixUsername:(NSString *)username withDomain:(NSString *)domain;
{
    NSString * finalUsername = nil;
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([username length]) {
        if ([username rangeOfString:@"@"].location != NSNotFound) {
            // has @ symbol
            NSRange range = [username rangeOfString:[NSString stringWithFormat:@"@%@",domain]];
            if (range.location + range.length == [username length]) {
                //propper ending of domain
                finalUsername = username;
            }
            else {
                //has @ symbol but incorrect domain
                NSArray * components = [username componentsSeparatedByString:@"@"];
                finalUsername = [NSString stringWithFormat:@"%@@%@",[components firstObject],domain];
            }
        }
        else {
            //append correct domain
            finalUsername = [NSString stringWithFormat:@"%@@%@",username,domain];
        }
    }
    return finalUsername;
}

-(void) loginButtonPressed:(id)sender
{
    if (![self checkFields]) {
        return;
    }
    
    self.loginButtonPressed = YES;
    if(self.isTorAccount && ![HITorManager defaultManager].isRunning)
    {
        [self showHUDWithText:CONNECTING_TO_TOR_STRING];
        [[HITorManager defaultManager] start];
    }
    else {
        NSString *newUsername = [self fixUsername:self.usernameTextField.text withDomain:[self hostnameForIndex:self.selectedHostnameIndex]];
        self.usernameTextField.text = newUsername;
        self.account.username = newUsername;
        self.account.domain = [self hostnameForIndex:self.selectedHostnameIndex];
        self.account.rememberPassword = self.rememberPasswordSwitch.on;
        self.account.autologin = self.autoLoginSwitch.on;
        OTRXMPPManager * xmppManager = [self xmppManager];
        if (xmppManager) {
            [self showHUDWithText:CREATING_ACCOUNT_STRING];
            [xmppManager registerNewAccountWithPassword:self.passwordTextField.text];
        }
    }
}

- (void)didReceiveRegistrationSucceededNotification:(NSNotification *)notification
{
    self.wasAbleToCreateAccount = YES;
    OTRXMPPManager * xmppMananger = [self xmppManager];
    if (xmppMananger) {
        self.HUD.labelText = LOGGING_IN_STRING;
        [xmppMananger connectWithPassword:self.passwordTextField.text];
    }
}

- (void)didReceiveRegistrationFailedNotification:(NSNotification *)notification
{
    [self hideHUD];
    self.wasAbleToCreateAccount = NO;
    NSError * error = [[notification userInfo] objectForKey:kOTRNotificationErrorKey];
    DDLogWarn(@"Registration Failed: %@",error);
    NSString * errorString = REGISTER_ERROR_STRING;
    if (error) {
        if ([error.domain isEqualToString:OTRXMPPErrorDomain]) {
            if (error.code == OTRXMPPUnsupportedAction) {
                errorString = IN_BAND_ERROR_STRING;
            }
            else if (error.code == OTRXMPPXMLError) {
                if ([error.localizedDescription length]) {
                    errorString = error.localizedDescription;
                }
            }
        }
    }
    
    [self showAlertViewWithTitle:ERROR_STRING message:errorString error:error];
}

- (NSString *)hostnameForIndex:(NSInteger)index
{
    NSString *hostname = nil;
    if (index < [self.hostnameArray count]) {
        hostname = self.hostnameArray[index];
    }
    else {
        //Other
    }
    return hostname;
}

- (OTRXMPPManager *)xmppManager
{
    id protocol = [[OTRProtocolManager sharedInstance] protocolForAccount:self.account];
    OTRXMPPManager * xmppManager = nil;
    if ([protocol isKindOfClass:[OTRXMPPManager class]]) {
        xmppManager = (OTRXMPPManager *)protocol;
    }
    return xmppManager;
}

+ (instancetype)createViewControllerWithHostnames:(NSArray *)hostNames
{
    return [[self alloc] initWithHostnames:hostNames];
}

@end
