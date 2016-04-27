//
//  RadioPlayDB.m
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "RadioPlayDB.h"

@implementation RadioPlayDB
//重写初始化方法给数据库对象进行赋初值
- (instancetype)init {
    if (self = [super init]) {
        self.db = [FMDBManager shareManager].db;
    }
    return self;
}

//创建表
- (void)createTable {
    NSString *creatTableString = [NSString stringWithFormat:@"create table if not exists %@ (title text,coverimg text,musicUrl text,savePath text)",RADIODOWNLOADTABLE];
    BOOL res = [_db executeUpdate:creatTableString];
    res == YES ? NSLog(@"创建表成功") :NSLog(@"创建表失败");
    
}
//插入一条数据
- (void)saveDownloadRadioInfo:(NSArray *)array {
    NSString *insertTableString = [NSString stringWithFormat:@"insert into %@ (title,coverimg,musicUrl,savePath)values(?,?,?,?)",RADIODOWNLOADTABLE];
    BOOL res = [_db executeUpdate:insertTableString withArgumentsInArray:array];
     res == YES ? NSLog(@"插入成功") :NSLog(@"插入失败");
}
//获取下载列表
- (NSArray *)getDownloadList {
    //获取下载的所有数据
    NSString *findStr = [NSString stringWithFormat:@"select *from %@",RADIODOWNLOADTABLE];
    //查询操作
    FMResultSet *set = [_db executeQuery:findStr];
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    //遍历存储
    while ([set next]) {
        NSDictionary *dic = @{@"title":[set stringForColumn:@"title"],@"coverimg":[set stringForColumn:@"coverimg"],@"musicUrl":[set stringForColumn:@"musicUrl"],@"savePath":[set stringForColumn:@"savePath"]};
        [dataArray addObject:dic];
    }
    //关闭
    [set close];
    return dataArray;
}

@end
