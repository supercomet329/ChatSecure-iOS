//
//  OTREncryptionDropdown.m
//  Off the Record
//
//  Created by David Chiles on 2/27/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRButtonView.h"

@interface OTRButtonView ()

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *spaces;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView * buttonView;
@property (nonatomic, strong) UIToolbar *backgroundToolbar;

@end

@implementation OTRButtonView

- (id)initWithTitle:(NSString *)title buttons:(NSArray *)buttons
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.buttons = buttons;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.54 alpha:1.0];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        self.backgroundToolbar.barStyle = UIBarStyleDefault;
        self.backgroundToolbar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundToolbar];
        
        [self addSubview:self.titleLabel];
        self.buttonView = [self emptyView];
        [self addSubview:self.buttonView];
        
        NSMutableArray * tempSpaces = [NSMutableArray array];
        [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            UIView * view = [self emptyView];
            [self.buttonView addSubview:view];
            [tempSpaces addObject:view];
            
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [self.buttonView addSubview:button];
        }];
        UIView * view = [self emptyView];
        [self.buttonView addSubview:view];
        [tempSpaces addObject:view];
        
        self.spaces = [NSArray arrayWithArray:tempSpaces];
    }
    return self;
}

- (UIView *)emptyView;
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (NSArray *)constraintsWithButtons:(NSArray *)buttons
{
    NSMutableArray * constraints = [NSMutableArray array];
    __block UIButton * previousButton = nil;
    __block UIView * previousPadding = nil;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL *stop) {
        UIView * padding = self.spaces[idx];
        if (!previousButton) {
            //First Button
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[padding][button]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(padding,button)]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:button
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.buttonView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];
        }
        else {
            //Middle Buttons
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton][padding(==previousPadding)][button]"
                                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(previousButton,padding,button,previousPadding)]];
            
        }
        previousPadding = padding;
        previousButton = button;
    }];
    
    UIView * lastPadding = [self.spaces lastObject];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton][lastPadding(==previousPadding)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(previousButton,lastPadding,previousPadding)]];
    
    
    return constraints;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self addConstraints:[self constraintsWithButtons:self.buttons]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buttonView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=3-[_titleLabel][_buttonView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buttonView,_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundToolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundToolbar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundToolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundToolbar)]];
}



@end
