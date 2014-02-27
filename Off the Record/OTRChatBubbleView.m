//
//  OTRChatBubbleView.m
//  Off the Record
//
//  Created by David Chiles on 1/9/14.
//  Copyright (c) 2014 Chris Ballinger. All rights reserved.
//

#import "OTRChatBubbleView.h"
#import "OTRConstants.h"
#import "OTRImages.h"
#import "OTRUtilities.h"
#import "OTRMessageTableViewCell.h"

@implementation OTRChatBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.messageTextLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.messageTextLabel.textAlignment = NSTextAlignmentNatural;
        self.messageBackgroundImageView = [OTRImages bubbleImageViewForMessageType:OTRBubbleMessageTypeOutgoing];
        self.messageBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.deliveredImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.deliveredImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.deliveredImageView];
        [self addSubview:self.messageTextLabel];
        
        [self needsUpdateConstraints];
    }
    return self;
}

- (void)setDelivered:(BOOL)delivered
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(isDelivered))];
    _delivered = delivered;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isDelivered))];
    
    if (self.isDelivierd) {
        self.deliveredImageView.image = [UIImage imageNamed:@"checkmark"];
    }
    else {
        self.deliveredImageView.image = nil;
    }
    [self setNeedsUpdateConstraints];
}


- (void)setDelivered:(BOOL)delivered animated:(BOOL)animated
{
    NSTimeInterval duration = 0;
    if (animated) {
        duration = .5;
    }
    [UIView animateWithDuration:duration animations:^{
        self.delivered = delivered;
        [self layoutIfNeeded];
    }];
}

- (void)setIncoming:(BOOL)incoming
{
    _incoming = incoming;
    if (_incoming) {
        self.messageBackgroundImageView = [OTRImages bubbleImageViewForMessageType:OTRBubbleMessageTypeIncoming];
        self.messageTextLabel.textColor = [UIColor blackColor];
    }
    else {
        self.messageBackgroundImageView = [OTRImages bubbleImageViewForMessageType:OTRBubbleMessageTypeOutgoing];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.messageTextLabel.textColor = [UIColor whiteColor];
        }
        else {
            self.messageTextLabel.textColor = [UIColor blackColor];
        }
    }
    [self setNeedsUpdateConstraints];
}

- (void)setMessageBackgroundImageView:(UIImageView *)messageBackgroundImageView
{
    if ([_messageBackgroundImageView isEqual:messageBackgroundImageView]) {
        return;
    }
    [_messageBackgroundImageView removeFromSuperview];
    _messageBackgroundImageView = messageBackgroundImageView;
    _messageBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_messageBackgroundImageView];
    [self sendSubviewToBack:_messageBackgroundImageView];
}

- (void)setMessageTextLabel:(TTTAttributedLabel *)messageTextLabel
{
    [_messageTextLabel removeFromSuperview];
    [self willChangeValueForKey:NSStringFromSelector(@selector(messageTextLabel))];
    _messageTextLabel = messageTextLabel;
    [self didChangeValueForKey:NSStringFromSelector(@selector(messageTextLabel))];
    _messageTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_messageTextLabel];
    [self setNeedsUpdateConstraints];
}

- (void)setupConstraints {
    //Delivered Image View
    
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:self.deliveredImageView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0.0];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.deliveredImageView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:10];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.deliveredImageView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:10];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.messageBackgroundImageView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.messageTextLabel
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0
                                               constant:34];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.messageBackgroundImageView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.messageTextLabel
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0
                                               constant:13];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.messageBackgroundImageView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0.0];
    [self addConstraint:constraint];
    
    //Text Label
    CGFloat yCenterConstant = -2.0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        yCenterConstant = 0;
    }
    constraint = [NSLayoutConstraint constraintWithItem:self.messageTextLabel
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.messageBackgroundImageView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:yCenterConstant];
    [self addConstraint:constraint];
    
    
    
    
    
    //self
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.messageBackgroundImageView
                                              attribute:NSLayoutAttributeHeight
                                             multiplier:1.0
                                               constant:0.0];
    [self addConstraint:constraint];
}

-(void) updateConstraints
{
    [super updateConstraints];
    
    [self setupConstraints];
    
    CGSize messageTextLabelSize = [self.messageTextLabel sizeThatFits:CGSizeMake(180, CGFLOAT_MAX)];
    [self removeConstraint:textWidthConstraint];
    textWidthConstraint = [NSLayoutConstraint constraintWithItem:self.messageTextLabel
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:messageTextLabelSize.width];
    [self addConstraint:textWidthConstraint];
    
    [self removeConstraint:textHeightConstraint];
    textHeightConstraint = [NSLayoutConstraint constraintWithItem:self.messageTextLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.0
                                                         constant:messageTextLabelSize.height];
    [self addConstraint:textHeightConstraint];
    
    [self removeConstraint:labelSideConstraint];
    [self removeConstraint:imageViewSideConstraint];
    [self removeConstraint:deliveredSideConstraint];
    if (self.isIncoming) {
        labelSideConstraint = [NSLayoutConstraint constraintWithItem:self.messageTextLabel
                                                  attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.messageBackgroundImageView
                                                  attribute:NSLayoutAttributeRight
                                                 multiplier:1.0
                                                   constant:-12.0];
     
        imageViewSideConstraint = [NSLayoutConstraint constraintWithItem:self.messageBackgroundImageView
                                                  attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0
                                                constant:0.0];
        
        deliveredSideConstraint = [NSLayoutConstraint constraintWithItem:self.deliveredImageView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.messageBackgroundImageView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0
                                                                constant:5.0];
    }
    else {
        labelSideConstraint = [NSLayoutConstraint constraintWithItem:self.messageTextLabel
                                                  attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.messageBackgroundImageView
                                                  attribute:NSLayoutAttributeLeft
                                                 multiplier:1.0
                                                   constant:12.0];

        imageViewSideConstraint = [NSLayoutConstraint constraintWithItem:self.messageBackgroundImageView
                                                  attribute:NSLayoutAttributeRight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeRight
                                                 multiplier:1.0
                                                   constant:0.0];
        
        deliveredSideConstraint = [NSLayoutConstraint constraintWithItem:self.deliveredImageView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.messageBackgroundImageView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0
                                                                constant:-5.0];
    }
    [self addConstraint:deliveredSideConstraint];
    [self addConstraint:imageViewSideConstraint];
    [self addConstraint:labelSideConstraint];
}

@end
