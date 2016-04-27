//
//  UserModel.m
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _auth = [aDecoder decodeObjectForKey:@"auth"];
        _uid = [aDecoder decodeObjectForKey:@"uid"];
        _icon = [aDecoder decodeObjectForKey:@"icon"];
        _uname = [aDecoder decodeObjectForKey:@"uname"];
        _coverimg= [aDecoder decodeObjectForKey:@"coverimg"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_auth forKey:@"auth"];
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_icon forKey:@"icon"];
    [aCoder encodeObject:_uname forKey:@"uname"];
    [aCoder encodeObject:_coverimg forKey:@"coverimg"];
}

@end
