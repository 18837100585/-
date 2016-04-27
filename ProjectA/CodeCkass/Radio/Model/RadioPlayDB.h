//
//  RadioPlayDB.h
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBManager.h"
#import <FMDB.h>


@interface RadioPlayDB : NSObject
//数据库对象
@property (nonatomic ,strong) FMDatabase *db;
//创建表
- (void)createTable;
//插入一条数据
- (void)saveDownloadRadioInfo:(NSArray *)array;
//获取下载列表
- (NSArray *)getDownloadList;


@end
