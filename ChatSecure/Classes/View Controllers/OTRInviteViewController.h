//
//  OTRInviteViewController.h
//  ChatSecure
//
//  Created by David Chiles on 7/8/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTRInviteViewController : UIViewController

@property (nonatomic, strong, readonly) UIImageView *titleImageView;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;

@property (nonatomic, strong) NSArray *shareButtons;

@end
