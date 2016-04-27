//
//  BaseModel.m
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
//如果代码中的key值不存在，会抛出异常，可以通过重写下面的方法解决这个问题
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
