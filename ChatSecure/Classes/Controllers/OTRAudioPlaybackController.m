//
//  OTRAudioPlaybackController.m
//  ChatSecure
//
//  Created by David Chiles on 2/4/15.
//  Copyright (c) 2015 Chris Ballinger. All rights reserved.
//

#import "OTRAudioPlaybackController.h"
#import "OTRAudioControlsView.h"
#import "OTRAudioSessionManager.h"
#import "OTRPlayPauseProgressView.h"
#import "OTRAudioItem.h"

@import AVFoundation;

@interface OTRAudioPlaybackController () <OTRAudioSessionManagerDelegate>

@property (nonatomic, strong) OTRAudioSessionManager *audioSessionManager;

@property (nonatomic, strong) NSTimer *labelTimer;

@property (nonatomic) NSTimeInterval duration;

@end

@implementation OTRAudioPlaybackController

- (OTRAudioSessionManager *)audioSessionManager
{
    if (!_audioSessionManager) {
        _audioSessionManager = [[OTRAudioSessionManager alloc] init];
        _audioSessionManager.delegate = self;
    }
    return _audioSessionManager;
}

#pragma - mark Private Methods

- (void)updateTimeLabel
{
    NSTimeInterval currentTime = [self.audioSessionManager currentTimePlayTime];
    [self.currentAudioControlsView setTime:currentTime];
}

- (void)playURL:(NSURL *)url error:(NSError **)error;
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    self.duration = CMTimeGetSeconds(asset.duration);
    self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPause;
    error = nil;
    [self.audioSessionManager playAudioWithURL:url error:error];
    [self.currentAudioControlsView.playPuaseProgressView animateProgressArcWithFromValue:0 duration:self.duration];
    self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPause;
    [self.currentAudioControlsView setTime:0];
    
    [self startLabelTimer];
}

- (void)startLabelTimer
{
    self.labelTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(updateTimeLabel)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (float)currentPlayProgress
{
    NSTimeInterval currentProgressTime = [self.audioSessionManager currentTimePlayTime];
    NSTimeInterval durationTime = [self.audioSessionManager durationPlayTime];
    
    float progress = currentProgressTime/durationTime;
    return progress;
}

- (NSTimeInterval)currentPlayTimeRemaining
{
    NSTimeInterval currentProgressTime = [self.audioSessionManager currentTimePlayTime];
    NSTimeInterval durationTime = [self.audioSessionManager durationPlayTime];
    
    return durationTime - currentProgressTime;
}

#pragma - mark Public Methods

- (void)playAudioItem:(OTRAudioItem *)audioItem error:(NSError **)error
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:audioItem.filename];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    _currentAudioItem = audioItem;
    
    [self playURL:fileURL error:error];
}

- (void)attachAudioControlsView:(OTRAudioControlsView *)audioControlsView
{
    _currentAudioControlsView = audioControlsView;
    [self.labelTimer invalidate];
    self.labelTimer = nil;
    
    if (self.currentAudioItem && [self.audioSessionManager currentTimePlayTime] > 0) {
        //Is Paused or Playing
        [self updateTimeLabel];
        
        
        CGFloat progress = [self currentPlayProgress];
        NSTimeInterval duration = [self currentPlayTimeRemaining];
        [self.currentAudioControlsView.playPuaseProgressView animateProgressArcWithFromValue:progress duration:duration];
        
        if ([self.audioSessionManager isPlaying]) {
            //Playing
            self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPause;
            [self startLabelTimer];
        }
        else {
            //Paused
            [self.currentAudioControlsView.playPuaseProgressView setProgressArcValue:progress];
            self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPlay;
        }
    }
    else {
        [self.currentAudioControlsView.playPuaseProgressView removeProgressArc];
        self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPlay;
    }
}

- (void)pauseCurrentlyPlaying
{
    [self.audioSessionManager pausePlaying];
    [self.currentAudioControlsView.playPuaseProgressView setProgressArcValue:[self currentPlayProgress]];
    self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPlay;
    [self.labelTimer invalidate];
    self.labelTimer = nil;
    [self updateTimeLabel];
    
}

- (void)resumeCurrentlyPlaying
{
    [self updateTimeLabel];
    [self.audioSessionManager resumePlaying];
    CGFloat progress = [self currentPlayProgress];
    NSTimeInterval duration = [self currentPlayTimeRemaining];
    [self.currentAudioControlsView.playPuaseProgressView animateProgressArcWithFromValue:progress duration:duration];
    self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPause;
    [self startLabelTimer];
}

- (void)stopCurrentlyPlaying
{
    [self.audioSessionManager stopPlaying];
    self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPlay;
    [self.currentAudioControlsView.playPuaseProgressView removeProgressArc];
    [self.labelTimer invalidate];
    self.labelTimer = nil;
    [self.currentAudioControlsView setTime:self.currentAudioItem.timeLength];
    _currentAudioItem = nil;
}

- (NSURL *)currentlyPlayingURL
{
    return [self.audioSessionManager currentPlayerURL];
}

- (BOOL)isPlaying
{
    return [self.audioSessionManager isPlaying];
}

#pragma - mark OTRAudioSessionManagerDelegate Methods

- (void)audioSession:(OTRAudioSessionManager *)audioSessionManager didFinishSuccefully:(BOOL)success
{
    self.currentAudioControlsView.playPuaseProgressView.status = OTRPlayPauseProgressViewStatusPlay;
    [self.currentAudioControlsView.playPuaseProgressView removeProgressArc];
    [self.labelTimer invalidate];
    [self.currentAudioControlsView setTime:self.currentAudioItem.timeLength];
    _currentAudioItem = nil;
}

@end
