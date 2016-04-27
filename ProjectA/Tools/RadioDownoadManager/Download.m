//
//  Download.m
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "Download.h"

@interface Download()<NSURLSessionDownloadDelegate>
//下载完成
@property (nonatomic, copy)DownloadSuccess downloadSuccess;
//下载中
@property (nonatomic, copy) Downloading downloading;

//会话
@property (nonatomic, strong)NSURLSession *session;
//根据会话创建下载任务的对象
@property (nonatomic, strong)NSURLSessionDownloadTask *task;

@end
@implementation Download



//初始化方法，配置下载需要的信息
- (instancetype)initWithUrl:(NSString *)url {
    if (self == [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        //创建一个下载的任务
        self.task = [_session downloadTaskWithURL:[NSURL URLWithString:url]];
        //初始化的时候对url进行赋值，方便下面使用
        _url = url;
        
    }
    return self;
}
//下载完成的一个协议
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    //获取cache文件夹的路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    //创建新的文件夹路径,拿到服务器的命名，根据服务器的命名创建新的路径
    NSString *filePath = [cachePath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    //创建管理类对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //转移文件
    [fileManager moveItemAtPath:location.path toPath:filePath error:nil];
    if (_delegate &&[_delegate respondsToSelector:@selector(didFinishLoadWith:)]) {
        //这个回调的作用是在单例里面删除这个下载对象，保证他可以被释放.
        [_delegate didFinishLoadWith:_url];
    }
    
    if (self.downloadSuccess) {
        self.downloadSuccess(filePath,_url);
    }
    //和NSTimer类似，下载完成后都要调用下面额方法，使其销毁
    [session invalidateAndCancel];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //算出当前的下载进度
    CGFloat progre = (float)totalBytesWritten / totalBytesExpectedToWrite;
    self.progress = progre *100;
    //将当前的下载进度进行回调
    if (self.downloading) {
        self.downloading(bytesWritten,_progress);
    }
    
}
//开始下载
- (void)start {
    [self.task resume];
}
//暂停下载
- (void)suspend {
    [self.task suspend];
}
//下载状态的block，一定要给他赋值，不然会在调用的时候出现问题
- (void)didFinishDownload:(DownloadSuccess)success downloading:(Downloading)downloading {
    self.downloading =downloading;
    self.downloadSuccess = success;
    
}

- (NSURLSessionTaskState)state {
    return _task.state;
}



@end
