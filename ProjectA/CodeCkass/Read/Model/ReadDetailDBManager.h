//
//  ReadDetailDBManager.h
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "ReadListModel.h"
#import "FMDBManager.h"

@interface ReadDetailDBManager : NSObject
//数据库对象
@property (nonatomic, strong) FMDatabase *DB;
//收藏表
- (void)creatTable;
//收藏阅读详情实体的方法
- (void)saveReadDetailModel:(ReadListModel *)model;
//取消收藏
- (void)deleteReadDetailModelWithid:(NSString *)readId;
//查询用户当前收藏的列表
- (NSArray *)findUserCollectionListWithUserId:(NSString *)userId;


@end
