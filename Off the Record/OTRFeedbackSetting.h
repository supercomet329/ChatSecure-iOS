//
//  OTRFeedbackSetting.h
//  Off the Record
//
//  Created by David on 11/9/12.
//  Copyright (c) 2012 Chris Ballinger. All rights reserved.
//

#import "OTRSetting.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface OTRFeedbackSetting : OTRSetting <MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) id <OTRSettingDelegate,MFMailComposeViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString * mailSubject;
@property (nonatomic,strong) NSArray * mailToRecipients;



- (id) initWithTitle:(NSString*)newTitle description:(NSString*)newDescription;

- (void) showView;


@end
