//
//  UserLoad.h
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserLoad : NSObject
//保存用户信息
+ (void)saveUserInfoWith:(UserModel *)model ;
//清空用户信息
+ (void)cleanUserInfo;
//获取用户
+(UserModel *)getUserInfo;
//判断是否登陆
+(BOOL)isLoad;

@end
