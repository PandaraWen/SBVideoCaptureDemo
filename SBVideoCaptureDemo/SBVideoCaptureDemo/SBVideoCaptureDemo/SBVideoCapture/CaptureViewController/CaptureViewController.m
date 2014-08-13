//
//  CaptureViewController.m
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-12.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import "CaptureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProgressBar.h"
#import "SBCaptureToolKit.h"
#import "SBVideoRecorder.h"

#define TIMER_INTERVAL 0.05f

#define DELETE_BTN_NORMAL_IAMGE @"record_delete_normal.png"
#define DELETE_BTN_DELETE_IAMGE @"record_deletesure_normal.png"

typedef enum {
    DeleteButtonStyleDelete,
    DeleteButtonStyleNormal,
    DeleteButtonStyleDisable,
}DeleteButtonStyle;

@interface CaptureViewController ()

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) SBVideoRecorder *recoder;

@property (strong, nonatomic) ProgressBar *progressBar;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (assign, nonatomic) int progressCounter;

@property (strong, nonatomic) UIButton *deleteButton;

@end

@implementation CaptureViewController

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
    self.view.backgroundColor = color(16, 16, 16, 1);
    
    self.maskView = [self getMaskView];
    [self.view addSubview:_maskView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initRecorder];
    [SBCaptureToolKit createVideoFolderIfNotExist];
    [self initProgressBar];
    
    
    [self hideMaskView];
}

- (void)initRecorder
{
    self.recoder = [[SBVideoRecorder alloc] init];
    _recoder.delegate = self;
    _recoder.preViewLayer.frame = CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.width);
    [self.view.layer insertSublayer:_recoder.preViewLayer atIndex:0];
}

- (void)initProgressBar
{
    self.progressBar = [ProgressBar getInstance];
    [SBCaptureToolKit setView:_progressBar toOriginY:DEVICE_SIZE.width];
    [self.view insertSubview:_progressBar belowSubview:_maskView];
    [_progressBar startShining];
}

- (void)initDeleteButton
{
    CGSize viewSize = self.view.frame.size;
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(30, viewSize.height - 35, 50, 50)];
    [_deleteButton setImage:[UIImage imageNamed:@"record_delete_normal.png"] forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"record_delete_disable.png"] forState:UIControlStateDisabled];
    [_deleteButton addTarget:self action:@selector(pressDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
}

- (void)setDeleteButtonStyle:(DeleteButtonStyle)style
{
    switch (style) {
        case DeleteButtonStyleNormal:
        {
            _deleteButton.enabled = YES;
            [_deleteButton setImage:[UIImage imageNamed:DELETE_BTN_NORMAL_IAMGE] forState:UIControlStateNormal];
        }
            break;
        case DeleteButtonStyleDelete:
        {
            _deleteButton.enabled = YES;
            [_deleteButton setImage:[UIImage imageNamed:DELETE_BTN_DELETE_IAMGE] forState:UIControlStateNormal];
        }
            break;
        case DeleteButtonStyleDisable:
        {
            _deleteButton.enabled = NO;
        }
            break;
        default:
            break;
    }
}

- (void)pressDeleteButton:(UIButton *)button
{
    
}

- (void)hideMaskView
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.maskView.frame;
        frame.origin.y = self.maskView.frame.size.height;
        self.maskView.frame = frame;
    }];
}

- (UIView *)getMaskView
{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height + DELTA_Y)];
    maskView.backgroundColor = color(30, 30, 30, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    label.font = [UIFont systemFontOfSize:50.0f];
    label.textColor = color(100, 100, 100, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"S B";
    label.backgroundColor = [UIColor clearColor];
    
    [maskView addSubview:label];
    
    return maskView;
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



- (void)startProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    self.progressCounter = 0;
}

- (void)stopProgressTimer
{
    [_progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)onTimer:(NSTimer *)timer
{
    self.progressCounter++;
    [_progressBar setLastProgressToWidth:self.progressCounter * TIMER_INTERVAL / MAX_VIDEO_DUR * DEVICE_SIZE.width];
}

#pragma mark - SBVideoRecorderDelegate
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL
{
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [self startProgressTimer];
    [_progressBar stopShining];
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"录制视频错误:%@", error);
    } else {
        NSLog(@"录制视频完成: %@", outputFileURL);
    }
    
    [self stopProgressTimer];
    [_progressBar startShining];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *filePath = [SBCaptureToolKit getVideoSaveFilePathString];
    [_recoder startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_recoder stopRecording];
}

@end



















