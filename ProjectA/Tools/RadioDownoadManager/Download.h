//
//  Download.h
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadDelegate <NSObject>
//下载完成后 通知单例移除下载对象
- (void)didFinishLoadWith:(NSString *)urll;

@end

//下载完成的block回调
typedef void(^DownloadSuccess)(NSString *savePath,NSString *url) ;
//下载中的block回调
typedef void(^Downloading)(long long writenByte,CGFloat progress);

@interface Download : NSObject

@property (nonatomic, assign)id<DownloadDelegate>delegate;

//下载的进度
@property (nonatomic, assign)CGFloat progress;
//下载的状态
@property (nonatomic, assign)NSURLSessionTaskState state;
//正在下载的网址
@property (nonatomic, strong)NSString *url;
//初始化方法，配置下载需要的信息
- (instancetype)initWithUrl:(NSString *)url;
//开始下载
- (void)start;
//暂停下载
- (void)suspend;
//下载状态的block，
- (void)didFinishDownload:(DownloadSuccess)success downloading:(Downloading)downloading;

@end
