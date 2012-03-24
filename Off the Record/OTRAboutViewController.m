//
//  OTRAboutViewController.m
//  Off the Record
//
//  Created by Chris Ballinger on 12/9/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//

#import "OTRAboutViewController.h"
#import "DTLinkButton.h"
#import "DTCoreTextConstants.h"

@implementation OTRAboutViewController
@synthesize versionLabel;

- (id)init {
    if (self = [super init]) {
        self.title = @"About";
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
    NSString *aboutString = @"<p style=\"font-size:120%\">ChatSecure is brought to you by many open source projects: Cypherpunk's libotr, LibOrange, xmppframework, DTCoreText and MBProgressHUD. Check out the source here on Github: <br><br><a href=\"https://github.com/chrisballinger/Off-the-Record-iOS\">https://github.com/chrisballinger/Off-the-Record-iOS</a></p>";
    
    CGRect frame = CGRectMake(20.0, 140.0, 280.0, 165.0);
    
    aboutTextView = [[DTAttributedTextView alloc] initWithFrame:frame];
	aboutTextView.textDelegate = self;
	aboutTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:aboutTextView];
    
	
	// Create attributed string from HTML
	CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 20.0);
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                             @"Helvetica", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, nil]; // @"green",DTDefaultTextColor,
    
    NSData *data = [aboutString dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:data options:options documentAttributes:NULL];
	
	// Display string
	aboutTextView.contentView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
	aboutTextView.attributedString = string;
    aboutTextView.userInteractionEnabled = YES;

    NSString *version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
}

- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.url = url;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.guid = identifier;
	
	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// demonstrate combination with long press
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
	[button addGestureRecognizer:longPress];
	
	return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
	
	return nil;
}


#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
	[[UIApplication sharedApplication] openURL:[button.url absoluteURL]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != actionSheet.cancelButtonIndex)
	{
		[[UIApplication sharedApplication] openURL:[lastActionLink absoluteURL]];
	}
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		DTLinkButton *button = (id)[gesture view];
		button.highlighted = NO;
		lastActionLink = button.url;
		
		if ([[UIApplication sharedApplication] canOpenURL:[button.url absoluteURL]])
		{
			UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.url absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
			[action showFromTabBar:self.tabBarController.tabBar];
		}
	}
}


@end
