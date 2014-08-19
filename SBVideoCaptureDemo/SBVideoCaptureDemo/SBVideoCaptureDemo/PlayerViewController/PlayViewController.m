//
//  PlayViewController.m
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-18.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SBCaptureDefine.h"

@interface PlayViewController ()

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NSURL *videoFileURL;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideoFileURL:(NSURL *)videoFileURL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videoFileURL = videoFileURL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:16 / 255.0f green:16 / 255.0f blue:16 / 255.0f alpha:1.0f];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"vedio_nav_btn_back_nor.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"vedio_nav_btn_back_pre.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    [self initPlayLayer];
    
    self.playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [_playButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)initPlayLayer
{
    if (!_videoFileURL) {
        return;
    }
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoFileURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 44, DEVICE_SIZE.width, DEVICE_SIZE.width);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];

}

- (void)pressPlayButton:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)pressBackButton:(UIButton *)button
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _playButton.alpha = 1.0f;
    }];
}

@end
