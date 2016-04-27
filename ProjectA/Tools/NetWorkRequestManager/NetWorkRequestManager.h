//
//  NetWorkRequestManager.h
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求类型
typedef enum{POST,GET}requestType;

@interface NetWorkRequestManager : NSObject
/*
 *GET请求连接
 *str： 请求连接
 *dic： 参数
 *success ：成功回调
 *failure：失败回调
 */
+ (void)requestForGetWithUrl:(NSString *)str parmDic:(NSMutableDictionary *)dic success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

+ (void)requestForPostWithUrl:(NSString *)str parmDic:(NSMutableDictionary *)dic success:(void (^)(id responObject))success failure:(void (^)(NSError *error))failure;

@end
