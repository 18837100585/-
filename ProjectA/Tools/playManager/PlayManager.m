//
//  PlayManager.m
//  ProjectA
//
//  Created by laouhn on 16/4/13.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "PlayManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RadioDetailModel.h"

@implementation PlayManager
+(PlayManager *)shareManager {
    static PlayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    manager = [PlayManager new];
    });
    return manager;
}

//重写init方法，对播放模式及状态赋初值
- (instancetype)init {
    if (self = [super init]) {
        self.playStatus = PlayStatusPause;
        self.playType = PlayTypeList;
    }
    return self;
}
#pragma mark -- 重写数据源方法
- (void)setMusicArray:(NSMutableArray *)musicArray {
    //移除设置数据源的时候都要把之前的数据源给清空
    [_musicArray removeAllObjects];
    //将新的不放数据源赋值给他
    _musicArray = [musicArray mutableCopy];
    AVPlayerItem *playItem =[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _musicArray[_index]]]];
    //如果存在播放器，进行更换Item，否则就要初始化
    if (_avPlayer) {
        [_avPlayer replaceCurrentItemWithPlayerItem:playItem];
    }else {
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:playItem];
    }
}

//播放
- (void)play {
    [_avPlayer play];
    //更改播放状态
    _playStatus = PlayStatusPlay;
    
    //配置后台播放时的信息
   [self configLockScreen];
    
}
- (void)configLockScreen {
    RadioDetailModel *model = [_allMusicDetailArray objectAtIndex:_index];
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    //专辑名
    [infoDic setObject:@"seastar" forKey:MPMediaItemPropertyAlbumTitle];
    //歌曲名
    [infoDic setObject:model.title forKey:MPMediaItemPropertyTitle];
    //歌手名
    [infoDic setObject:@"星涛" forKey:MPMediaItemPropertyArtist];
    //封面图片
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.coverimg]];
    UIImage *image = [UIImage imageWithData:data];
    MPMediaItemArtwork *artwork  = [[MPMediaItemArtwork alloc]initWithImage:image];
    [infoDic setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //播放时长
    [infoDic setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.avPlayer.currentItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
    //当前播放的信息中心
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = infoDic;
    
    
}
//暂停
- (void)pause {
    [_avPlayer pause];
    _playStatus = PlayStatusPause;
}
//停止播放
- (void)stop {
    //设置播放位置从0开始
    [self seekToNewTime:0];
    _playStatus = PlayStatusPause;
}
//上一首
- (void)lastMusic {
    //如果是随机模式
    if (_playType == PlayTypeRandom) {
        _index = arc4random()%_musicArray.count;
    }else {
        //如果是第一首
        if (_index == 0) {
            _index = _musicArray.count-1;
        }else {
            _index--;
        }
    }
    [self changeMusicWithIndex:_index];
}
//下一首
- (void)nextMusic {
    if (_playType == PlayTypeRandom) {
        _index = arc4random()%_musicArray.count;
   }else {
        //如果是最后一首
        if (_index == _musicArray.count) {
            _index =0;
        }else {
            _index++;
        }
    }
    [self changeMusicWithIndex:_index];
}
//指定位置进行播放
- (void)seekToNewTime:(float)time {
    //获取当前播放的时间
    CMTime newTime = _avPlayer.currentTime;
    //重新设置播放时间
    newTime.value = newTime.timescale *time;
    //注意，如果你使用seekToTime方法时，快速拖动播放进度条，会造成音乐停止播放，所以我们用下面的方法，在设置好新的播放时间后，让播放器进行播放一下
   [_avPlayer seekToTime:newTime completionHandler:^(BOOL finished) {
       [_avPlayer play];
   }];
}
//指定下标进行播放
- (void)changeMusicWithIndex:(NSInteger)index {
    _index = index;
    //更换歌曲
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_musicArray[_index]]]];
    [_avPlayer replaceCurrentItemWithPlayerItem:item];
    //播放
    [_avPlayer play];
    }
//播放完成后调用的操作
- (void)playDidFinish {
    //如果是单曲循环
    if (_playType == PlayTypeSingle) {
        [self seekToNewTime:0];
    }else {
        [self nextMusic];
        //歌曲完成后告诉视图控制器进行更新UI
        [[NSNotificationCenter defaultCenter]postNotificationName:PLAYDIDFINISH object:nil];

    }
}
- (CGFloat)totalTime {
    //安全处理，判断除数为0
    if (_avPlayer.currentItem.duration.timescale==0) {
        return 0;
    }else {
      return   _avPlayer.currentItem.duration.value /_avPlayer.currentItem.duration.timescale;
    }
}
//当前播放时间
- (CGFloat)currentTime {
    if (_avPlayer.currentTime.timescale ==0) {
        return 0;
    }else {
        return _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
    }
}


@end
