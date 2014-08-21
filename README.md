# SBVideoCaptureDemo
---

A custom UI video recording demo with AVFoundation.framework, recording multiple videos and finally merge them into a square video file.

一个用AVFoundation自定义界面的视频录制demo。 仿照“微视”，录制多段视频，然后合并成一个正方形的视频文件。

## ScreenShots:
------------

![screenShot1][1]

![screenShot2][2]


Usage:
----------
0. Import 4 framework
```
MediaPlayer.framework(if "PlayVeiwController is needed"), QuartzCore.framework, AVFoundation.framework, CoreGraphics.framework;
```

1. Drag "SBVideoCapture" folder to your project;

2. import the head file, and initalize the class SBVideoRecorder

```swift
- (void)initRecorder
{
    self.recorder = [[SBVideoRecorder alloc] init];
    _recorder.delegate = self;
    _recorder.preViewLayer.frame = CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.width);
    [self.preview.layer addSublayer:_recorder.preViewLayer];
}
```

 You can find more details in file "CaptureViewController.m"

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

[1]: http://hte4mj-resource.stor.sinaapp.com/SBVideoCapture/1.PNG
[2]: http://hte4mj-resource.stor.sinaapp.com/SBVideoCapture/2.PNG