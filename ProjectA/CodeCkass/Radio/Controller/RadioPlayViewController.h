//
//  RadioPlayViewController.h
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "BaseViewController.h"
#import "RadioDetailModel.h"
@interface RadioPlayViewController : BaseViewController

@property (nonatomic, strong)RadioDetailModel *model;
//播放列表
@property (nonatomic, strong) NSMutableArray *dataListArray;

//播放实体
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger playIndex;

@end
