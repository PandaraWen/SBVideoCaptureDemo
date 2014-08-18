//
//  SBCaptureToolKit.m
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import "SBCaptureToolKit.h"
#import "SBCaptureDefine.h"

@implementation SBCaptureToolKit

+ (void)setView:(UIView *)view toSizeWidth:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginX:(CGFloat)x
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginY:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOrigin:(CGPoint)origin
{
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}

+ (BOOL)createVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建图片文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (NSString *)getVideoMergeFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFolderPathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    return path;
}
@end


























