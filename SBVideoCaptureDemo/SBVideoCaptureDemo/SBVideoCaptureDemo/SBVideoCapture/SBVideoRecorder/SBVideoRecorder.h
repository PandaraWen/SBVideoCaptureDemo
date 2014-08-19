//
//  SBVideoRecorder.h
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SBVideoRecorder;
@protocol SBVideoRecorderDelegate <NSObject>

@optional
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL;
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error;
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur;
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error;
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL ;

@end

@interface SBVideoRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (weak, nonatomic) id <SBVideoRecorderDelegate> delegate;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

- (CGFloat)getTotalVideoDuration;
- (void)stopCurrentVideoRecording;
- (void)startRecordingToOutputFileURL:(NSURL *)fileURL;

- (void)deleteLastVideo;//调用delegate
- (void)deleteAllVideo;//不调用delegate

- (NSUInteger)getVideoCount;

- (void)mergeVideoFiles;

- (BOOL)isCameraSupported;
- (BOOL)isFrontCameraSupported;
- (BOOL)isTorchSupported;

- (void)switchCamera;
- (void)openTorch:(BOOL)open;

- (void)focusInPoint:(CGPoint)touchPoint;

@end
