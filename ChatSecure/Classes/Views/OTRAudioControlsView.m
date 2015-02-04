//
//  OTRAudioControlsView.m
//  ChatSecure
//
//  Created by David Chiles on 1/28/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

#import "OTRAudioControlsView.h"
#import "PureLayout.h"
#import "OTRPlayPauseProgressView.h"

@interface OTRAudioControlsView ()

@property (nonatomic) BOOL addedConstraints;

@end

@implementation OTRAudioControlsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _timeLabel = [[UILabel alloc] initForAutoLayout];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        
        _playPuaseProgressView = [[OTRPlayPauseProgressView alloc] initForAutoLayout];
        self.playPuaseProgressView.opaque = NO;
        self.playPuaseProgressView.percent = 0;
        self.playPuaseProgressView.color = [UIColor whiteColor];
        self.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPause;
        
        [self addSubview:self.timeLabel];
        [self addSubview:self.playPuaseProgressView];
        
        self.addedConstraints = NO;
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    if (!self.addedConstraints) {
        
        [self.playPuaseProgressView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTrailing];
        [self.playPuaseProgressView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.playPuaseProgressView];
        
        [self.timeLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeLeading];
        [self.timeLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.playPuaseProgressView withOffset:0 relation:NSLayoutRelationEqual];
        
        self.addedConstraints = YES;
    }
}

@end
