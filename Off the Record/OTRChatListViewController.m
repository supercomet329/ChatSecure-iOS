//
//  OTRChatListViewController.m
//  Off the Record
//
//  Created by Chris Ballinger on 8/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OTRChatListViewController.h"
#import "OTRChatViewController.h"

@implementation OTRChatListViewController

@synthesize buddyController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = @"Conversations";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(buddyController.chatViewControllers)
        return [buddyController.chatViewControllers count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
	
    if(buddyController.chatViewControllers)
    {
        NSArray *keyArray =  [buddyController.chatViewControllers allKeys];
        OTRChatViewController *tmp = [buddyController.chatViewControllers objectForKey:[ keyArray objectAtIndex:indexPath.row]];
        cell.textLabel.text = tmp.title;    
        
        int detailLength = 25;
        
        cell.detailTextLabel.text = [tmp.chatHistoryTextView.text substringFromIndex:[tmp.chatHistoryTextView.text length] - detailLength];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keyArray =  [buddyController.chatViewControllers allKeys];
    OTRChatViewController *tmp = [buddyController.chatViewControllers objectForKey:[ keyArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:tmp animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
