//
//  PlayManager.h
//  ProjectA
//
//  Created by laouhn on 16/4/13.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <Foundation/Foundation.h>

//播放模式，单曲，随机，列表
typedef  NS_ENUM(NSInteger ,PlayType) {
    PlayTypeSingle,
    PlayTypeRandom,
    PlayTypeList
};
//播放状态,播放,暂停
typedef NS_ENUM(NSInteger ,PlayStatus)  {
    PlayStatusPlay,
    PlayStatusPause
};


@interface PlayManager : NSObject
//播放的数据源
@property (nonatomic, strong) NSMutableArray *musicArray;
//播放模式
@property (nonatomic, assign)PlayType playType;
@property (nonatomic, assign)PlayStatus playStatus;
//播放的下标
@property (nonatomic, assign) NSInteger index;
//播放的总时长
@property (nonatomic, assign) CGFloat totalTime;
//当前播放的时间
@property (nonatomic,assign)CGFloat currentTime;
@property (nonatomic, strong)AVPlayer *avPlayer;

@property (nonatomic,strong) NSMutableArray *allMusicDetailArray;

#pragma mark -- Method
//播放
- (void)play;
//暂停
- (void)pause;
//停止播放
- (void)stop;
//上一首
- (void)lastMusic;
//下一首
- (void)nextMusic;
//指定位置进行播放
- (void)seekToNewTime:(float)time;
//指定下标进行播放
- (void)changeMusicWithIndex:(NSInteger)index;
//播放完成后调用的操作
- (void)playDidFinish;
//单例初始化
+(PlayManager *)shareManager;

@end
