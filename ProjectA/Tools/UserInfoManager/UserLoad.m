//
//  UserLoad.m
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "UserLoad.h"
#define KEY @"USER"

static UserModel *sharemanager = nil;


@implementation UserLoad

//保存用户信息
+ (void)saveUserInfoWith:(UserModel *)model  {
//    if (!sharemanager) {
//        
//    }
    NSUserDefaults *userD = [NSUserDefaults  standardUserDefaults];
  NSData *data =   [NSKeyedArchiver archivedDataWithRootObject:model];
    [userD setObject:data forKey:KEY];
    //NSUserDefaults 不是立即写入，需要我们进行同步一下
    [userD synchronize];
}
//清空用户信息
+ (void)cleanUserInfo {
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD removeObjectForKey:KEY];
    [userD synchronize];
    sharemanager = nil;
    
}
//获取用户
+(UserModel *)getUserInfo {
    if (!sharemanager) {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSData *data = [userD objectForKey:KEY];
        if (data) {
           sharemanager = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else {
            return nil;
        }
    }
    return  sharemanager;
    
}



//判断是否登陆
+(BOOL)isLoad {
    UserModel *infoModel = [UserLoad getUserInfo];
    if (infoModel == nil) {
        return NO;
    } else {
        return YES;
    }
}
    
    


@end
