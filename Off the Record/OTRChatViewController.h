//
//  OTRChatViewController.h
//  Off the Record
//
//  Created by Chris Ballinger on 8/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTRBuddyListViewController.h"
#import "DTAttributedTextView.h"

@interface OTRChatViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, DTAttributedTextContentViewDelegate, UIActionSheetDelegate> {
    DTAttributedTextView *chatHistoryTextView;
    UITextField *messageTextField;
    OTRBuddyListViewController *buddyListController;
    
    NSURL *lastActionLink;
    NSMutableString *rawChatHistory;
}

@property (retain, nonatomic) DTAttributedTextView *chatHistoryTextView;
@property (retain, nonatomic) IBOutlet UITextField *messageTextField;
@property (retain, nonatomic) OTRBuddyListViewController *buddyListController;
@property (nonatomic, retain) NSMutableString *rawChatHistory;


- (IBAction)sendButtonPressed:(id)sender;
- (void)receiveMessage:(NSString*)message;
- (void)sendMessage:(NSString*)message;
-(void)scrollTextViewToBottom;

-(void)updateChatHistory;

@end
