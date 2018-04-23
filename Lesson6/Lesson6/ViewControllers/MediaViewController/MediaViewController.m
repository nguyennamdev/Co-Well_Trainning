//
//  FirstViewController.m
//  Lesson6
//
//  Created by Nguyen Nam on 4/19/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "MediaViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaEntity.h>

@interface MediaViewController ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer2;
@property (strong, nonatomic) AVAudioPlayer *audioMediaAccess;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *videoPlayerView;

@end

@implementation MediaViewController

AVPlayer *video;
AVPlayerLayer *videoLayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Disable stop and play button
    [_playButton setEnabled:NO];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
    
    [self setupAudioRecoreder];
    [self setupAudioLocal];
    [self setupVideoPlayer];

}

// MARK: setup audioRecorder
- (void)setupAudioRecoreder{
    // set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudio.m4a", nil];
    
    // create output file url
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // declare settingDictionary
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc]init];
    [settingDict setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settingDict setValue:[NSNumber numberWithInt:44100.0] forKey:AVSampleRateKey];
    [settingDict setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:outputFileURL settings:settingDict error:nil];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    [self.audioPlayer updateMeters];
    [self.audioPlayer peakPowerForChannel:50];
    [self.audioRecorder prepareToRecord];
    
}

// MARK: Set up audio local
- (void)setupAudioLocal{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"audio" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    // init audio
    _audioPlayer2 = [[AVAudioPlayer alloc]initWithData:fileData error:&error];
    self.audioPlayer2.numberOfLoops = 0;
    self.audioPlayer2.delegate = self;
    self.audioPlayer2.volume = 1;
    [self.audioPlayer2 prepareToPlay];
}


// MARK: Set up video player
- (void)setupVideoPlayer{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:@"lactroi" withExtension:@"mp4"];
    video = [AVPlayer playerWithURL:url];
    videoLayer = [[AVPlayerLayer alloc]init];
    videoLayer.player = video;
    videoLayer.frame = _videoPlayerView.bounds;
    [video setVolume:1];
    _videoPlayerView.backgroundColor = [UIColor clearColor];
    [_videoPlayerView.layer addSublayer:videoLayer];
}

// MARK: Actions

- (IBAction)recordAudio:(UIButton *)sender {
    if (self.audioRecorder.recording){
        // stop record
        [self.audioRecorder stop];
        [self.playButton setEnabled:YES];
        [self.recordButton setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
        [video pause];
    }else{
        // start record
        [self.audioRecorder record];
        [self.recordButton setImage:[UIImage imageNamed:@"microphone2"] forState:UIControlStateNormal];
        [video play];
    }
}

- (IBAction)playAudio:(UIButton *)sender {
    if (!_audioRecorder.recording){
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_audioRecorder.url error:nil];
        [_audioPlayer setDelegate:self];
        [_audioPlayer play];
    }
    [self.playButton setEnabled:false];
    [self.stopButton setEnabled:true];
}

- (IBAction)stopAudio:(UIButton *)sender {
    if(_audioPlayer.playing){
        [_audioPlayer stop];
    }
    [self.playButton setEnabled:YES];
    [self.stopButton setEnabled:NO];
}
- (IBAction)accessToMedia:(UIButton *)sender {
    // Display Media Picker and play item
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    [self presentViewController:mediaPicker animated:true completion:nil];
}

// MARK: Actions for audio local
- (IBAction)playAudioLocal:(UIBarButtonItem *)sender {
    if (!_audioPlayer2.playing){
        [_audioPlayer2 play];
    }
}
- (IBAction)pauseAudioLocal:(UIBarButtonItem *)sender {
    if (_audioPlayer2.playing){
        [_audioPlayer2 pause];
    }
}
- (IBAction)stopAudioLocal:(UIBarButtonItem *)sender {
    if (_audioPlayer2.playing){
        [_audioPlayer2 stop];
    }
}


// MARK: AVAudioRecorderDelegate


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"audio recorder did finish recording");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"audio recorder encode error");
}

// MARK:AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audio player did finish playing");
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"audio player decode error");
}

// MARK: MPMediaViewControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    [self dismissViewControllerAnimated:true completion:nil];
    NSArray<MPMediaItem *> *items = mediaItemCollection.items;
    self.audioMediaAccess = [[AVAudioPlayer alloc]initWithContentsOfURL:items[0].assetURL error:nil];
    self.audioMediaAccess.numberOfLoops = 1;
    self.audioMediaAccess.delegate = self;
    [self.audioMediaAccess prepareToPlay];
    [self.audioMediaAccess play];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
