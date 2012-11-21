//
//  OTRLanguageController.h
//  Off the Record
//
//  Created by David on 11/13/12.
//  Copyright (c) 2012 Chris Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOTRLanguageDefaultArrayKey @"kOTRLanguageDefaultArrayKey"

@interface OTRLanguageManager : NSObject

@property (nonatomic,strong) NSDictionary * languageLookupDictionary;


-(NSArray *)supportedLanguages;
-(void)setLocale:(NSString *)locale;
-(NSString *)currentValue;
+(void)saveDefaultLanguageArray;
+(BOOL)defaultLanguagesSaved;

@end
