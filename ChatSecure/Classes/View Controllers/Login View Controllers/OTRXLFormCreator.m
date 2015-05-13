//
//  OTRXLFormCreator.m
//  ChatSecure
//
//  Created by David Chiles on 5/12/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

#import "OTRXLFormCreator.h"
#import "XLForm.h"
#import "OTRXMPPAccount.h"
#import "Strings.h"

NSString *const kOTRXLFormUsernameTextFieldTag        = @"kOTRXLFormUsernameTextFieldTag";
NSString *const kOTRXLFormPasswordTextFieldTag        = @"kOTRXLFormPasswordTextFieldTag";
NSString *const kOTRXLFormRememberPasswordSwitchTag   = @"kOTRXLFormRememberPasswordSwitchTag";
NSString *const kOTRXLFormLoginAutomaticallySwitchTag = @"kOTRXLFormLoginAutomaticallySwitchTag";
NSString *const kOTRXLFormHostnameTextFieldTag        = @"kOTRXLFormHostnameTextFieldTag";
NSString *const kOTRXLFormPortTextFieldTag            = @"kOTRXLFormPortTextFieldTag";
NSString *const kOTRXLFormResourceTextFieldTag        = @"kOTRXLFormResourceTextFieldTag";

@implementation OTRXLFormCreator

+ (XLFormDescriptor *)formForAccount:(OTRAccount *)account
{
    XLFormDescriptor *descriptor = [self formForAccountType:account.accountType];
    
    [[descriptor formRowWithTag:kOTRXLFormUsernameTextFieldTag] setValue:account.username];
    [[descriptor formRowWithTag:kOTRXLFormPasswordTextFieldTag] setValue:account.password];
    [[descriptor formRowWithTag:kOTRXLFormRememberPasswordSwitchTag] setValue:@(account.rememberPassword)];
    [[descriptor formRowWithTag:kOTRXLFormLoginAutomaticallySwitchTag] setValue:@(account.autologin)];
    
    if([account isKindOfClass:[OTRXMPPAccount class]])
    {
        OTRXMPPAccount *xmppAccount = (OTRXMPPAccount *)account;
        [[descriptor formRowWithTag:kOTRXLFormHostnameTextFieldTag] setValue:xmppAccount.domain];
        [[descriptor formRowWithTag:kOTRXLFormPortTextFieldTag] setValue:@(xmppAccount.port)];
        [[descriptor formRowWithTag:kOTRXLFormResourceTextFieldTag] setValue:xmppAccount.resource];
    }
    
    
    
    return descriptor;
}

+ (XLFormDescriptor *)formForAccountType:(OTRAccountType)accountType
{
    XLFormDescriptor *descriptor = [[XLFormDescriptor alloc] init];
    switch (accountType) {
        case OTRAccountTypeJabber:
        case OTRAccountTypeXMPPTor:{
            
            XLFormSectionDescriptor *basicSection = [XLFormSectionDescriptor formSectionWithTitle:BASIC_STRING];
            XLFormSectionDescriptor *advancedSection = [XLFormSectionDescriptor formSectionWithTitle:ADVANCED_STRING];
            
            [basicSection addFormRow:[self usernameTextFieldRowDescriptorWithValue:nil]];
            [basicSection addFormRow:[self passwordTextFieldRowDescriptorWithValue:nil]];
            [basicSection addFormRow:[self rememberPasswordRowDescriptorWithValue:YES]];
            [basicSection addFormRow:[self loginAutomaticallyRowDescriptorWithValue:NO]];
            
            [advancedSection addFormRow:[self hostnameRowDescriptorWithValue:nil]];
            [advancedSection addFormRow:[self portRowDescriptorWithValue:nil]];
            [advancedSection addFormRow:[self resourceRowDescriptorWithValue:nil]];
            
            [descriptor addFormSection:basicSection];
            [descriptor addFormSection:advancedSection];
            
            break;
        }
        case OTRAccountTypeGoogleTalk: {
            
            break;
        }
            
        default:
            break;
    }
    
    return descriptor;
}

+ (XLFormRowDescriptor *)textfieldFormDescriptorType:(NSString *)type withTag:(NSString *)tag title:(NSString *)title placeHolder:(NSString *)placeholder value:(id)value
{
    XLFormRowDescriptor *textFieldDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:tag rowType:type title:title];
    textFieldDescriptor.value = value;
    if (placeholder) {
        [textFieldDescriptor.cellConfigAtConfigure setObject:placeholder forKey:@"textField.placeholder"];
    }
    
    return textFieldDescriptor;
}

+ (XLFormRowDescriptor *)usernameTextFieldRowDescriptorWithValue:(NSString *)value
{
    XLFormRowDescriptor *usernameDescriptor = [self textfieldFormDescriptorType:XLFormRowDescriptorTypeEmail withTag:kOTRXLFormUsernameTextFieldTag title:USERNAME_STRING placeHolder:XMPP_USERNAME_EXAMPLE_STRING value:value];
    return usernameDescriptor;
}

+ (XLFormRowDescriptor *)passwordTextFieldRowDescriptorWithValue:(NSString *)value
{
    XLFormRowDescriptor *passwordDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kOTRXLFormPasswordTextFieldTag rowType:XLFormRowDescriptorTypePassword title:PASSWORD_STRING];
    passwordDescriptor.value = value;
    [passwordDescriptor.cellConfigAtConfigure setObject:REQUIRED_STRING forKey:@"textField.placeholder"];
    
    return passwordDescriptor;
}

+ (XLFormRowDescriptor *)rememberPasswordRowDescriptorWithValue:(BOOL)value
{
    XLFormRowDescriptor *switchDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kOTRXLFormRememberPasswordSwitchTag rowType:XLFormRowDescriptorTypeBooleanSwitch title:REMEMBER_PASSWORD_STRING];
    switchDescriptor.value = @(value);
    
    return switchDescriptor;
}

+ (XLFormRowDescriptor *)loginAutomaticallyRowDescriptorWithValue:(BOOL)value
{
    XLFormRowDescriptor *loginDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kOTRXLFormLoginAutomaticallySwitchTag rowType:XLFormRowDescriptorTypeBooleanSwitch title:LOGIN_AUTOMATICALLY_STRING];
    loginDescriptor.value = @(value);
    
    return loginDescriptor;
}

+ (XLFormRowDescriptor *)hostnameRowDescriptorWithValue:(NSString *)value
{
    return [self textfieldFormDescriptorType:XLFormRowDescriptorTypeURL withTag:kOTRXLFormHostnameTextFieldTag title:HOSTNAME_STRING placeHolder:OPTIONAL_STRING value:value];
}

+ (XLFormRowDescriptor *)portRowDescriptorWithValue:(NSNumber *)value
{
    NSString *defaultPortNumberString = [NSString stringWithFormat:@"%d",[OTRXMPPAccount defaultPort]];
    
    return [self textfieldFormDescriptorType:XLFormRowDescriptorTypeInteger withTag:kOTRXLFormPortTextFieldTag title:PORT_STRING placeHolder:defaultPortNumberString value:value];
}

+ (XLFormRowDescriptor *)resourceRowDescriptorWithValue:(NSString *)value
{
    XLFormRowDescriptor *resourceRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kOTRXLFormResourceTextFieldTag rowType:XLFormRowDescriptorTypeText title:RESOURCE_STRING];
    resourceRowDescriptor.value = value;
    
    return resourceRowDescriptor;
}


@end
