//
//  OTRNewAccountViewController.m
//  Off the Record
//
//  Created by David Chiles on 7/12/12.
//  Copyright (c) 2012 Chris Ballinger. All rights reserved.
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

#import "OTRNewAccountViewController.h"
#import "Strings.h"
#import "OTRProtocol.h"
#import "OTRConstants.h"
#import "OTRLoginViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "OTRManagedXMPPAccount.h"
#import "OTRManagedFacebookAccount.h"
#import "OTRManagedGoogleAccount.h"
#import "OTRManagedOscarAccount.h"

static CGFloat const kOTRRowHeight   = 70;
NSString *const kOTRDisplayNameKey   = @"kOTRDisplayNameKey";
NSString *const kOTRProviderImageKey = @"kOTRProviderImageKey";
NSString *const kOTRAccountTypeKey   = @"kOTRAccountTypeKey";

@interface OTRNewAccountViewController ()

@end

@implementation OTRNewAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = NEW_ACCOUNT_STRING;
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    
    
    accountsCellArray = [self accounts];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CANCEL_STRING style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed:)];
    
}

- (NSArray*)accounts
{
    return @[[OTRNewAccountViewController facebookCellDictionary],
             [OTRNewAccountViewController googleCellDictionary],
             [OTRNewAccountViewController XMPPCellDictionary],
             [OTRNewAccountViewController XMPPTorCellDictionary],
             [OTRNewAccountViewController aimCellDictionary]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountsCellArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOTRRowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary * cellAccount = [accountsCellArray objectAtIndex:indexPath.row];
    cell.textLabel.text = cellAccount[kOTRDisplayNameKey];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
    cell.imageView.image = [UIImage imageNamed:cellAccount[kOTRProviderImageKey]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if( [cellAccount[kOTRAccountTypeKey] isEqual:@(OTRAccountTypeFacebook)])
    {
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 10.0;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OTRAccountType accountType = [accountsCellArray[indexPath.row][kOTRAccountTypeKey] unsignedIntegerValue];
    [self didSelectAccountType:accountType];
}

- (void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectAccountType:(OTRAccountType)accountType {
    OTRManagedAccount * cellAccount = [OTRManagedAccount accountForAccountType:accountType];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    [context MR_saveToPersistentStoreAndWait];
    
    OTRLoginViewController *loginViewController = [OTRLoginViewController loginViewControllerWithAcccountID:cellAccount.objectID];
    loginViewController.isNewAccount = YES;
    [self.navigationController pushViewController:loginViewController animated:YES];
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

+(NSDictionary *)googleCellDictionary {
    return @{kOTRDisplayNameKey:GOOGLE_TALK_STRING,
             kOTRProviderImageKey: OTRGoogleTalkImageName,
             kOTRAccountTypeKey: @(OTRAccountTypeGoogleTalk)};
}
+(NSDictionary *)facebookCellDictionary {
    return @{kOTRDisplayNameKey:FACEBOOK_STRING,
             kOTRProviderImageKey: OTRFacebookImageName,
             kOTRAccountTypeKey: @(OTRAccountTypeFacebook)};
}
+(NSDictionary *)XMPPCellDictionary {
    return @{kOTRDisplayNameKey: JABBER_STRING,
             kOTRProviderImageKey: OTRXMPPImageName,
             kOTRAccountTypeKey: @(OTRAccountTypeJabber)};
}
+(NSDictionary *)XMPPTorCellDictionary {
    return @{kOTRDisplayNameKey: XMPP_TOR_STRING,
             kOTRProviderImageKey: OTRXMPPTorImageName,
             kOTRAccountTypeKey: @(OTRAccountTypeXMPPTor)};
}
+(NSDictionary *)aimCellDictionary {
    return @{kOTRDisplayNameKey: AIM_STRING,
             kOTRProviderImageKey: OTRAimImageName,
             kOTRAccountTypeKey: @(OTRAccountTypeAIM)};
}

@end
