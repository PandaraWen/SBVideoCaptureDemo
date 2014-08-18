//
//  MainViewController.m
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-12.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import "MainViewController.h"
#import "CaptureViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SBCaptureToolKit.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //62 42
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 42)];
    [recordButton setImage:[UIImage imageNamed:@"g_tabbar_ic_video_nor.png"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"g_tabbar_ic_video_down@2x.png"] forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(pressRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    recordButton.center = CGPointMake(DEVICE_SIZE.width / 2, DEVICE_SIZE.height - 42 / 2.0f - 5.0f + DELTA_Y);
    [self.view addSubview:recordButton];
}

- (void)pressRecordButton:(UIButton *)sender
{
    NSURL *fileURL = [NSURL fileURLWithPath:[[SBCaptureToolKit getVideoSaveFolderPathString] stringByAppendingPathComponent:@"20140818173222merge.mp4"]];
    NSLog(@"fileURL:%@", fileURL);
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, 320, 320);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerLayer];
    [player play];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    
//    CaptureViewController *captureViewCon = [[CaptureViewController alloc] initWithNibName:@"CaptureViewController" bundle:nil];
//    [self presentViewController:captureViewCon animated:YES completion:nil];
//    
//    if (DEVICE_OS_VERSION < 7.0f) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


@end
