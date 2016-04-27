//
//  UserModel.h
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject <NSCoding>
@property (nonatomic, strong)NSString *auth;

@property (nonatomic, strong)NSString *coverimg;

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *uname;
@end
