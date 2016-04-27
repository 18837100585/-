//
//  FMDBManager.m
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "FMDBManager.h"


@implementation FMDBManager

+(FMDBManager *)shareManager {
    static FMDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc]init];
    });
    return manager;
}
//重写init方法，在init方法里面对数据库进行创建
- (instancetype)init {
    if (self = [super init]) {
        [self creatDataBaseWithName:DBNAME];
        
    }
    return self;
}
/*
 *document目录
 *第一个参数 ：文件名称
 *第二个参数： 作用域
 *第三个参数：绝对路径或者是相对路径
 */
- (void)creatDataBaseWithName:(NSString *)name {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //获取数据库要保存的路径以及数据库名称
    NSString *dbPath = [documentPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", DBNAME]];
    //这个方法只是根据路径创建数据库对象,并没有把数据库文件创建出来
    self.db = [[FMDatabase alloc]initWithPath:dbPath];
    //open操作才是真正的创建数据库文件，如果成功返回yes 失败返回no 并且会返回失败信息
    BOOL isOpen =  [_db open];
    isOpen == YES ? NSLog(@"数据库创建成功") :NSLog(@"数据库创建失败");
    
}

- (void)closeDataBase {
    [self.db close];
    
    
}

- (void)dealloc {
    [self closeDataBase];
}

@end
