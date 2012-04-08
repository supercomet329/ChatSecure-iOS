//
//  OTRAboutViewController.m
//  Off the Record
//
//  Created by Chris Ballinger on 12/9/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//

#import "OTRAboutViewController.h"
#import "Strings.h"

@implementation OTRAboutViewController
@synthesize versionLabel, aboutTextView, lastActionLink;

- (void) dealloc {
    self.lastActionLink = nil;
}

- (id)init {
    if (self = [super init]) {
        self.title = ABOUT_STRING;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *aboutString = [NSString stringWithFormat:@"<p style=\"font-size:120%\">%@: Cypherpunk's libotr, LibOrange, xmppframework, and MBProgressHUD. %@: <br><br><a href=\"https://github.com/chrisballinger/Off-the-Record-iOS\">https://github.com/chrisballinger/Off-the-Record-iOS</a></p>", ATTRIBUTION_STRING, SOURCE_STRING];
    
    CGRect frame = CGRectMake(20.0, 140.0, 280.0, 165.0);
    
    aboutTextView = [[UIWebView alloc] initWithFrame:frame];
	aboutTextView.delegate = self;
	aboutTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [aboutTextView loadHTMLString:aboutString baseURL:[NSURL URLWithString:@"/"]];
	[self.view addSubview:aboutTextView];
    
    aboutTextView.userInteractionEnabled = YES;
    if([aboutTextView respondsToSelector:@selector(scrollView)]) {
        aboutTextView.scrollView.scrollEnabled = NO;
    }

    NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"%@ %@", VERSION_STRING, version];
}

- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.aboutTextView = nil;
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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		[[UIApplication sharedApplication] openURL:[lastActionLink absoluteURL]];
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString isEqualToString:@"file:///"]) {
        return YES;
    }
    if ([[UIApplication sharedApplication] canOpenURL:request.URL])
    {
        self.lastActionLink = request.URL;
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[request.URL absoluteURL] description] delegate:self cancelButtonTitle:CANCEL_STRING destructiveButtonTitle:nil otherButtonTitles:OPEN_IN_SAFARI_STRING, nil];
        [action showFromTabBar:self.tabBarController.tabBar];
    }
    return NO;
}


@end
