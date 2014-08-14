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
#import "DeleteButton.h"

#define TIMER_INTERVAL 0.05f

#define TAG_ALERTVIEW_CLOSE_CONTROLLER 10086

@interface CaptureViewController ()

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) SBVideoRecorder *recorder;

@property (strong, nonatomic) ProgressBar *progressBar;

@property (strong, nonatomic) DeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *settingButton;

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
    [self initDeleteButton];
    [self initOKButton];
    [self initTopLayout];
    
    [self hideMaskView];
}

- (void)initRecorder
{
    self.recorder = [[SBVideoRecorder alloc] init];
    _recorder.delegate = self;
    _recorder.preViewLayer.frame = CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.width);
    [self.view.layer insertSublayer:_recorder.preViewLayer atIndex:0];
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
    self.deleteButton = [DeleteButton getInstance];
    [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
    [SBCaptureToolKit setView:_deleteButton toOrigin:CGPointMake(15, self.view.frame.size.height - _deleteButton.frame.size.height - 10)];
    [_deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_deleteButton belowSubview:_maskView];
    
}

- (void)initOKButton
{
    CGFloat okButtonW = 50;
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, okButtonW, okButtonW)];
    _okButton.enabled = NO;
    
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_normal_bg.png"] forState:UIControlStateNormal];
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_highlighted_bg.png"] forState:UIControlStateHighlighted];
    
    [_okButton setImage:[UIImage imageNamed:@"record_icon_hook_normal.png"] forState:UIControlStateNormal];
    
    [SBCaptureToolKit setView:_okButton toOrigin:CGPointMake(self.view.frame.size.width - okButtonW - 10, self.view.frame.size.height - okButtonW - 10)];
    
    [_okButton addTarget:self action:@selector(pressOKButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_okButton belowSubview:_maskView];
}

- (void)initTopLayout
{
    CGFloat buttonW = 35.0f;
    
    //关闭
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, buttonW, buttonW)];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_normal.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_disable.png"] forState:UIControlStateDisabled];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_highlighted.png"] forState:UIControlStateSelected];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_highlighted.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_closeButton belowSubview:_maskView];
    
    //前后摄像头转换
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10) * 2 - 10, 5, buttonW, buttonW)];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_normal.png"] forState:UIControlStateNormal];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_disable.png"] forState:UIControlStateDisabled];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted.png"] forState:UIControlStateSelected];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted.png"] forState:UIControlStateHighlighted];
    [self.view insertSubview:_switchButton belowSubview:_maskView];
    
    //setting
    self.settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10), 5, buttonW, buttonW)];
    [_settingButton setImage:[UIImage imageNamed:@"record_tool_normal.png"] forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"record_tool_disable.png"] forState:UIControlStateDisabled];
    [_settingButton setImage:[UIImage imageNamed:@"record_tool_highlighted.png"] forState:UIControlStateSelected];
    [_settingButton setImage:[UIImage imageNamed:@"record_tool_highlighted.png"] forState:UIControlStateHighlighted];
    [self.view insertSubview:_settingButton belowSubview:_maskView];
}

- (void)pressCloseButton
{
    if ([_recorder getTotalVideoDuration] > 0.0f) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"放弃这个视频真的好么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
        alertView.tag = TAG_ALERTVIEW_CLOSE_CONTROLLER;
        [alertView show];
    } else {
        [self dropTheVideo];
    }
}

- (void)pressSwitchButton
{
    
}

- (void)pressSettingButton
{
    
}

- (void)pressDeleteButton
{
    if (_deleteButton.style == DeleteButtonStyleNormal) {//第一次按下删除按钮
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleDelete];
        [_deleteButton setButtonStyle:DeleteButtonStyleDelete];
    } else if (_deleteButton.style == DeleteButtonStyleDelete) {//第二次按下删除按钮
        [self deleteLastVideo];
        [_progressBar deleteLastProgress];
        
        if ([_recorder getVideoCount] > 0) {
            [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        } else {
            [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
        }
    }
}

- (void)pressOKButton
{
    _okButton.enabled = NO;
}

//放弃本次视频，并且关闭页面
- (void)dropTheVideo
{
    [_recorder deleteAllVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除最后一段视频
- (void)deleteLastVideo
{
    if ([_recorder getVideoCount] > 0) {
        [_recorder deleteLastVideo];
    }
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



//- (void)startProgressTimer
//{
//    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
//    self.progressCounter = 0;
//}
//
//- (void)stopProgressTimer
//{
//    [_progressTimer invalidate];
//    self.progressTimer = nil;
//}
//
//- (void)onTimer:(NSTimer *)timer
//{
//    self.progressCounter++;
//    [_progressBar setLastProgressToWidth:self.progressCounter * TIMER_INTERVAL / MAX_VIDEO_DUR * DEVICE_SIZE.width];
//}

#pragma mark - SBVideoRecorderDelegate
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL
{
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
    [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"录制视频错误:%@", error);
    } else {
        NSLog(@"录制视频完成: %@", outputFileURL);
    }
    
    [_progressBar startShining];
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"删除视频错误: %@", error);
    } else {
        NSLog(@"删除了视频: %@", fileURL);
        NSLog(@"现在视频长度: %f", totalDur);
    }
    
    if ([_recorder getVideoCount] > 0) {
        [_deleteButton setStyle:DeleteButtonStyleNormal];
    } else {
        [_deleteButton setStyle:DeleteButtonStyleDisable];
    }
    
    _okButton.enabled = (totalDur >= MIN_VIDEO_DUR);
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur
{
    [_progressBar setLastProgressToWidth:videoDuration / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
    _okButton.enabled = (videoDuration + totalDur >= MIN_VIDEO_DUR);
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_deleteButton.style == DeleteButtonStyleDelete) {//取消删除
        [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleNormal];
        return;
    }
    
    NSString *filePath = [SBCaptureToolKit getVideoSaveFilePathString];
    [_recorder startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_recorder stopRecording];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case TAG_ALERTVIEW_CLOSE_CONTROLLER:
        {
            switch (buttonIndex) {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    [self dropTheVideo];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end



















