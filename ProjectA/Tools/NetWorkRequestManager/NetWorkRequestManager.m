//
//  NetWorkRequestManager.m
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "NetWorkRequestManager.h"
#import "AFNetworking.h"

@implementation NetWorkRequestManager

+ (void)requestForGetWithUrl:(NSString *)str parmDic:(NSMutableDictionary *)dic success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    [NetWorkRequestManager requewstType:GET WithUrl:str parmDic:dic success:success failure:failure];
    
}

+ (void)requestForPostWithUrl:(NSString *)str parmDic:(NSMutableDictionary *)dic success:(void (^)(id responObject))success failure:(void (^)(NSError *error))failure {
    
 [NetWorkRequestManager requewstType:POST WithUrl:str parmDic:dic success:success failure:failure];
    //创建请求管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //发送网络请求
//    [manager POST:str parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
  }
+ (void)requewstType:(NSInteger)type WithUrl:(NSString *)str parmDic:(NSMutableDictionary *)dic success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    //创建可变请求
    NSMutableURLRequest *mutableRequest =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:str]];
    //如果是POST请求
    if (type == 0) {
        //如果参数不为空
        if (dic) {
            mutableRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
            mutableRequest.HTTPMethod = @"POST";
            
        }
    }
  
    //创建全局会话
    NSURLSession *session = [NSURLSession sharedSession];
    //根据全局会话创建请求任务对象
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error==nil) {
            id temp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
            success(temp);
        }else {
            failure(error);
        }
    }];
    //开启任务
    [dataTask resume];
    

    
}

@end
