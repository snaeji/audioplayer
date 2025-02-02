#import "AudioplayerPlugin.h"
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>



static NSString *const CHANNEL_NAME = @"bz.rxla.flutter/audio";
static FlutterMethodChannel *channel;
static AVPlayer *player;
static AVPlayerItem *playerItem;

@interface AudioplayerPlugin()
-(MPRemoteCommandHandlerStatus)pause;
-(void)stop;
-(void)mute:(BOOL)muted;
-(void)seek:(CMTime)time;
-(void)onStart;
-(void)onTimeInterval:(CMTime)time;
-(MPRemoteCommandHandlerStatus)resume;
@end

@implementation AudioplayerPlugin

CMTime position;
NSString *lastUrl;
BOOL isPlaying = false;
NSMutableSet *observers;
NSMutableSet *timeobservers;
FlutterMethodChannel *_channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    AudioplayerPlugin* instance = [[SwiftAudioplayerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    _channel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    typedef void (^CaseBlock)(void);
    // Squint and this looks like a proper switch!
    NSDictionary *methods = @{
                              @"play":
                                  ^{
                                      NSString *url = call.arguments[@"url"];
                                      int isLocal = [call.arguments[@"isLocal"] intValue];
                                      [self play:url isLocal:isLocal];
                                      result(nil);
                                  },
                              @"pause":
                                  ^{
                                      [self pause];
                                      result(nil);
                                  },
                              @"stop":
                                  ^{
                                      [self stop];
                                      result(nil);
                                  },
                              @"mute":
                                  ^{
                                      [self mute:[call.arguments boolValue]];
                                      result(nil);
                                  },
                              @"seek":
                                  ^{
                                      [self seek:CMTimeMakeWithSeconds([call.arguments doubleValue], 1)];
                                      result(nil);
                                  }
                              };
    
    CaseBlock c = methods[call.method];
    if (c) {
        c();
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)play:(NSString*)url isLocal:(int)isLocal {
    if (![url isEqualToString:lastUrl]) {
        [playerItem removeObserver:self
                        forKeyPath:@"player.currentItem.status"];
        
        for (id ob in observers) {
            [[NSNotificationCenter defaultCenter] removeObserver:ob];
        }
        observers = nil;
        
        if (isLocal) {
            playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:url]];
        } else {
            playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
            [self register];
            //TODO: !
        }
        lastUrl = url;
        
        id anobserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                          object:playerItem
                                                                           queue:nil
                                                                      usingBlock:^(NSNotification* note){
                                                                          [self stop];
                                                                          [_channel invokeMethod:@"audio.onComplete" arguments:nil];
                                                                      }];
        [observers addObject:anobserver];
        
        if (player) {
            [player replaceCurrentItemWithPlayerItem:playerItem];
        } else {
            player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            // Stream player position.
            // This call is only active when the player is active so there's no need to
            // remove it when player is paused or stopped.
            CMTime interval = CMTimeMakeWithSeconds(0.2, NSEC_PER_SEC);
            id timeObserver = [player addPeriodicTimeObserverForInterval:interval queue:nil usingBlock:^(CMTime time){
                [self onTimeInterval:time];
            }];
            [timeobservers addObject:timeObserver];
        }
        
        // is sound ready
        [[player currentItem] addObserver:self
                               forKeyPath:@"player.currentItem.status"
                                  options:0
                                  context:nil];
    }
    [self onStart];
    [player play];
    isPlaying = true;
}

- (void)register {
    
    // Get your app's audioSession singleton object
     AVAudioSession *session = [AVAudioSession sharedInstance];

     // Error handling
     BOOL success;
     NSError *error;

     // set the audioSession category.
     // Needs to be Record or PlayAndRecord to use audioRouteOverride:

     success = [session setCategory:AVAudioSessionCategoryPlayback
                              error:&error];

    if (!success) {
        NSLog(@"AVAudioSession error setting category:%@",error);
    }


     // Activate the audio session
     success = [session setActive:YES error:&error];
     if (!success) {
         NSLog(@"AVAudioSession error activating: %@",error);
     }
     else {
          NSLog(@"AudioSession active");
     }
    
   MPRemoteCommandCenter* center = [MPRemoteCommandCenter sharedCommandCenter];
   center.playCommand.enabled = true;
   center.pauseCommand.enabled = true;
   [center.playCommand addTarget:self action:@selector(resume)];
   [center.pauseCommand addTarget:self action:@selector(pause)];
}

- (void)onStart {
    CMTime duration = [[player currentItem] duration];
    if (CMTimeGetSeconds(duration) > 0) {
        int mseconds= CMTimeGetSeconds(duration)*1000;
        [_channel invokeMethod:@"audio.onStart" arguments:@(mseconds)];
    }
}

- (void)onTimeInterval:(CMTime)time {
    int mseconds =  CMTimeGetSeconds(time)*1000;
    [_channel invokeMethod:@"audio.onCurrentPosition" arguments:@(mseconds)];
}

- (MPRemoteCommandHandlerStatus)pause {
    [player pause];
    isPlaying = false;
    [_channel invokeMethod:@"audio.onPause" arguments:nil];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)resume {
    [player play];
    isPlaying = true;
    CMTime duration = [[player currentItem] duration];
    if (CMTimeGetSeconds(duration) > 0) {
        int mseconds= CMTimeGetSeconds(duration)*1000;
        [_channel invokeMethod:@"audio.onStart" arguments:@(mseconds)];
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

- (void)stop {
    if (isPlaying) {
        [player pause];
        isPlaying = false;
    }
    [playerItem seekToTime:CMTimeMake(0, 1)];
    [_channel invokeMethod:@"audio.onStop" arguments:nil];
}

- (void)mute:(BOOL)muted {
    player.muted = muted;
}

- (void)seek:(CMTime)time {
    [playerItem seekToTime:time];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"player.currentItem.status"]) {
        if ([[player currentItem] status] == AVPlayerItemStatusReadyToPlay) {
            [self onStart];
        } else if ([[player currentItem] status] == AVPlayerItemStatusFailed) {
            [_channel invokeMethod:@"audio.onError" arguments:@[(player.currentItem.error.localizedDescription)]];
        }
    } else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)dealloc {
    for (id ob in timeobservers) {
        [player removeTimeObserver:ob];
    }
    timeobservers = nil;
    
    for (id ob in observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:ob];
    }
    observers = nil;
}

@end
