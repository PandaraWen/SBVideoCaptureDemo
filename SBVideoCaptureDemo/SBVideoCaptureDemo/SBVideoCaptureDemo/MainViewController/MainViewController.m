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
#import "PlayViewController.h"

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
    UINavigationController *navCon = [[UINavigationController alloc] init];
    navCon.navigationBarHidden = YES;
    
    CaptureViewController *captureViewCon = [[CaptureViewController alloc] initWithNibName:@"CaptureViewController" bundle:nil];
    [navCon pushViewController:captureViewCon animated:NO];
    [self presentViewController:navCon animated:YES completion:nil];
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
