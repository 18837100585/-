//
//  DownloadManager.m
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

- (NSMutableDictionary *)dic {
    if (!_dic) {
        self.dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

+(DownloadManager *)shareManager {
    static DownloadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc]init];
    });
    return manager;
}

//根据url添加一个下载
- (Download *)creatDownloadWithUrl:(NSString *)url {
      //判断是否已经有这个下载了，如果有了 从字典里面取出来这个下载
    Download *download = self.dic[url];
    //如果没有下载对象
    if (!download) {
        download = [[Download alloc]initWithUrl:url];
        //添加到字典中
        [_dic setValue:download forKey:url];
    }
    download.delegate = self;
    return download;
}
#pragma mark --DownLoadDelegate
//下载完成后执行的代理方法
- (void)didFinishLoadWith:(NSString *)urll {
    [self.dic removeObjectForKey:urll];
}

//根据一个url找到一个下载
- (Download *)findDownloadWithUrl:(NSString *)url {
    return self.dic[url];
    
}

@end
