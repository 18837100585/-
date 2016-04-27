//
//  CommonModel.h
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "BaseModel.h"

@interface CommonModel : BaseModel

@property (nonatomic, copy) NSString *addtime_f;

@property (nonatomic,copy) NSString *content ;
@property (nonatomic, strong) NSString *contentid;
@property (nonatomic, strong) NSString *icon;


@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *uname;


@end
