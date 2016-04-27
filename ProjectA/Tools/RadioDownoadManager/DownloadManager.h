//
//  DownloadManager.h
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Download.h"

@interface DownloadManager : NSObject<DownloadDelegate>
//用c创建一个字典，用来保存当前的下载对象，使单例持有他，从而不会被销毁
@property (nonatomic, strong) NSMutableDictionary *dic;
//初始化方法
+(DownloadManager *)shareManager;

//根据url添加一个下载
- (Download *)creatDownloadWithUrl:(NSString *)url;
//根据一个url找到一个下载
- (Download *)findDownloadWithUrl:(NSString *)url;



@end
