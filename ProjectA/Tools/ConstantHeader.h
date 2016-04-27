//
//  ConstantHeader.h
//  ProjectAAcount
//
//  Created by laouhn on 16/4/5.
//  Copyright © 2016年 Seastar. All rights reserved.
//

//存放一些尺寸，像屏幕宽度，高度；或者一些颜色

#ifndef ConstantHeader_h
#define ConstantHeader_h
/**屏幕宽度*/
#define hScreenWidth [UIScreen mainScreen].bounds.size.width
/**屏幕高度0.*/
#define hScreenHeight [UIScreen mainScreen].bounds.size.height
/**随机颜色*/
#define RandomColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]
//数据库名
#define DBNAME @"LoveMoment.sqlite"
//存放阅读详情的表
#define READDETAILTABLE @"ReadDetailTable"

#define  THEFIRSTLUNCH @"TheFirsrLunch"
//歌曲播放完成标识
#define PLAYDIDFINISH @"PlayDidFinish"

#define RADIODOWNLOADTABLE @"RadioDownloadTable"

//友盟
#define U_MengShareAPPKEY  @"56fe61b267e58e75d40009ba"


#endif /* ConstantHeader_h */
