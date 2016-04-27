//
//  ReadDetailDBManager.m
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "ReadDetailDBManager.h"

@implementation ReadDetailDBManager

- (instancetype)init {
    if (self = [super init]) {
        self.DB = [FMDBManager shareManager].db;
     
    }
    return self;
}

//收藏表
- (void)creatTable {
    //查询一下创建的表是否存在
    FMResultSet *set =[_DB executeQuery:[NSString stringWithFormat:@"select *from %@ where type = 'table' and name = '%@'",DBNAME,READDETAILTABLE]];
    //判断是否存在
    BOOL isExist = [set next];
    if (isExist) {
        NSLog(@"表已经存在");
    }else {
        NSString *tableString = [NSString stringWithFormat:@"create table %@ (readid text,userId text,title text, content text,coverimg text)",READDETAILTABLE];
        //创建表
     BOOL success = [_DB executeUpdate:tableString];
        success == YES ? NSLog(@"创建表成功") : NSLog(@"创建表失败");
    }
    
}
//收藏阅读详情实体的方法
- (void)saveReadDetailModel:
         (ReadListModel *)model {
    NSString *addString = [NSString stringWithFormat:@"insert into %@(readid ,userId ,title,content,coverimg)values(?,?,?,?,?)",READDETAILTABLE];
    NSMutableArray *argumentArray = [NSMutableArray arrayWithCapacity:0];
    if (model.readid) {
        [argumentArray addObject:model.readid];
    }
    if ([UserLoad isLoad]) {
        [argumentArray addObject:[UserLoad getUserInfo].uid];
    }
    if (model.title) {
        [argumentArray addObject:model.title];
    }
    if (model.content) {
        [argumentArray addObject:model.content];
    }
    if (model.coverimg) {
        [argumentArray addObject:model.coverimg];
    }
    BOOL addSuccess = [_DB executeUpdate:addString withArgumentsInArray:argumentArray];
    addSuccess == YES ? NSLog(@"能插入") : NSLog(@"不能插入");
}
//取消收藏
- (void)deleteReadDetailModelWithid:(NSString *)readId {
    NSString *deleteString = [NSString stringWithFormat:@"delete from %@ where readid ='%@'",READDETAILTABLE,readId];
    BOOL deleteSuc = [_DB executeUpdate:deleteString];
    deleteSuc == YES ? NSLog(@"删除成功") :NSLog(@"删除失败");
    
}
//查询用户当前收藏的列表
- (NSArray *)findUserCollectionListWithUserId:(NSString *)userId {
    NSString *searchString = [NSString stringWithFormat:@"select * from %@ where userId = '%@'",READDETAILTABLE,userId];
    //查询操作
    FMResultSet *set = [_DB executeQuery:searchString];
    //接收查询结果
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        ReadListModel *model = [[ReadListModel alloc ]init];
        model.title = [set stringForColumn:@"title"];
        model.content = [set stringForColumn:@"content"];
        model.readid = [set stringForColumn:@"readid"];
        model.coverimg = [set stringForColumn:@"coverimg"];
        [array addObject:model];
    }
    return array;
}

@end
