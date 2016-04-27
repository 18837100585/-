//
//  ReadListModel.h
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadListModel : NSObject

@property (nonatomic, strong)NSNumber *type;

@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSDictionary *userinfo;

@property (nonatomic, strong) NSString *coverimg;

@property (nonatomic, strong)NSString *content;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentid;

@property (nonatomic, strong)NSDictionary *counterList;

@property (nonatomic, strong) NSString *readid;
@end
