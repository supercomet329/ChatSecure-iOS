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
#import "OTRUIKeyboardListener.h"
#import "OTRConstants.h"
#import "OTRXMPPAccount.h"


#import "OTRXMPPLoginViewController.h"
#import "OTRFacebookLoginViewController.h"
#import "OTROscarLoginViewController.h"
#import "OTRGoogleTalkLoginViewController.h"
#import "OTRInLineTextEditTableViewCell.h"

#define kFieldBuffer 20;


@implementation OTRLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton, cancelButton;
@synthesize rememberPasswordSwitch;
@synthesize logoView;
@synthesize timeoutTimer;
@synthesize account;
@synthesize isNewAccount;

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
    //tableViewArray = [[NSMutableArray alloc] init];
    
    
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.delegate = self;
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.text = account.username;
    
    
    [self addCellinfoWithSection:0 row:0 labelText:USERNAME_STRING cellType:kCellTypeTextField userInputView:self.usernameTextField];
    
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.delegate = self;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    
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
    
    
    UITableView * loginTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    loginTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [loginTableView setDelegate:self];
    [loginTableView setDataSource:self];
    [self.view addSubview:loginTableView];
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
        return ((UILabel *)[[[tableViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:kTextLabelTextKey]).frame.size.height+10;
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
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self readInFields];
    
    if([account.username length]!=0 && [account.password length] !=0 )
    {
        [account save];
        [[[OTRProtocolManager sharedInstance] accountsManager] addAccount:account];
    }
    
    
}

-(void)readInFields
{
    account.username = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    account.rememberPassword = rememberPasswordSwitch.on;
    
    if (account.rememberPassword) {
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
        
        [self readInFields];

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


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

+(OTRLoginViewController *)loginViewControllerWithAcccount:(OTRAccount *)account
{
    if([[account.accountDictionary objectForKey:kOTRAccountDomainKey] isEqualToString:kOTRFacebookDomain])
    {
        //FacebookLoginViewController
        return [[OTRFacebookLoginViewController alloc] initWithAccount:account];
    }
    else if ([[account.accountDictionary objectForKey:kOTRAccountDomainKey] isEqualToString:kOTRGoogleTalkDomain])
    {
        //GoogleTalkLoginViewController
        return [[OTRGoogleTalkLoginViewController alloc] initWithAccount:account];
    }
    else if ([[account.accountDictionary objectForKey:kOTRAccountProtocolKey] isEqualToString:kOTRProtocolTypeXMPP])
    {
        //XMPP account addvanced
        return [[OTRXMPPLoginViewController alloc] initWithAccount:account];
    }
    else if ([[account.accountDictionary objectForKey:kOTRAccountProtocolKey] isEqualToString:kOTRProtocolTypeAIM])
    {
        //Aim Protocol
        return [[OTROscarLoginViewController alloc] initWithAccount:account];
    }

}

@end
