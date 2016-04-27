//
//  FMDBManager.h
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface FMDBManager : NSObject
//数据库对象
@property (nonatomic, strong) FMDatabase *db;
//单例方法
+(FMDBManager *)shareManager;
//关闭数据库
- (void)closeDataBase;


@end
