//
//  RadioPlayViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "RadioDetailModel.h"
#import "PlayManager.h"
#import "DownloadManager.h"
#import "Download.h"
#import "RadioPlayDB.h"

@interface RadioPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIWebView *playWebView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) PlayManager *manager;
@property (nonatomic, strong) NSTimer *timer;
//下载按钮
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end

@implementation RadioPlayViewController

#pragma mark -- 创建音乐播放器
- (void)creatPlayManager {
    //创建播放对象
    self.manager = [PlayManager shareManager];
    //传入播放的位置
    _manager.index = _playIndex;
    //传入播放的数据源
    _manager .musicArray = _dataArray;
    
    //将整个数据源闯过去用于远程控制展示数据
    _manager.allMusicDetailArray = self.dataListArray;
 
    //播放
    //[_manager play];
    
    //创建计时器,在计时器方法中获取播放时长
   self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(getPlayTime) userInfo:nil repeats:YES];
    //RunLoop 用于处理事件循环，或者不停的调用工作的方法或输入事件,使用RunLoop可以大大降低CPU的使用率,线程在有工作的时候忙于工作，没有工作的时候处于休息状态.
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

- (void)getPlayTime {
    //设置滑块的最大值和最小值
    _progressSlider.minimumValue = 0;
    _progressSlider.maximumValue = _manager.totalTime;
    //当前的进度
    _progressSlider.value = _manager.currentTime;
    //显示时间
    _timeLabel.text = [NSString stringWithFormat:@"%02lld:%02lld",(int64_t)(_manager.totalTime-_manager.currentTime)/60,(int64_t)(_manager.totalTime-_manager.currentTime)%60];
    if (_manager .totalTime == _manager.currentTime &&_manager.totalTime!=0) {
        [_manager playDidFinish];
    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataListArray {
    if (!_dataListArray) {
        self.dataListArray = [NSMutableArray array];
    }
    return _dataListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.playIndex =[PlayManager shareManager].index;
    //调用指定下标进行播放时，就会通知更新UI
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:PLAYDIDFINISH object:nil];
    
    [self initUI];
   [self creatPlayManager];
 }

- (BOOL)canBecomeFirstResponder {
    return YES;
}


#pragma  mark --初始化视图上的数据
- (void)initUI {
    //获取点击的播放实体
    RadioDetailModel *model = _dataListArray[_playIndex];
    self.title = model.title;
    //加载播放时的电台图片
    [self.videoImage setImageWithURL:[NSURL URLWithString:model.coverimg]];
    _videoImage.layer.masksToBounds = YES;
    _videoImage.layer.cornerRadius = _videoImage.frame.size.width/2;
    [self setWebViewContentWithUrl:model.webview_url];
    //设置播放列表的选中状态
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_playIndex  inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionTop)];
}

#pragma mark --加载网页
- (void)setWebViewContentWithUrl:(NSString *)webUrl {
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:webUrl]];
    //根据请求进行加载网页
    [_playWebView loadRequest:request];
}

#pragma  mark --更新UI
- (void)refreshUI {
    [self refreshUIWithIndex:_manager.index];
}
//改变播放音乐进度方法
- (IBAction)musicProgressAction:(UISlider *)sender {
    [_manager seekToNewTime:_progressSlider.value];
}
- (void)refreshUIWithIndex:(NSInteger )index {
    //获取点击播放的实体
    RadioDetailModel *model = _dataListArray[index];
    self.title = model.title;
    [_videoImage setImageWithURL:[NSURL URLWithString:model.coverimg]];
    [self setWebViewContentWithUrl:model.webview_url];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_playIndex inSection:0];
    [_tableView deselectRowAtIndexPath:oldIndexPath animated:YES];
    //添加新的选中状态
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:(UITableViewScrollPositionTop)];
    //改变播放的音乐
    [_manager changeMusicWithIndex:index];
    _playIndex = index;
}
#pragma mark -- 下载操作
- (IBAction)downloadButtonAction:(UIButton *)sender {
    //判断用户是否登录
    if ([UserLoad isLoad]) {
        //交互关闭
        self.downloadButton.enabled = NO;
        [_downloadButton setTitle:@"0%" forState:UIControlStateNormal];
        //单例初始化
        DownloadManager *manager = [DownloadManager shareManager];
        RadioDetailModel *model = [self.dataListArray objectAtIndex:_playIndex];
        //初始化下载对象
        Download *download = [manager creatDownloadWithUrl:model.musicUrl];
        //开始下载
        [download start];
        //根据当前的现在状态进行相应的配置
        [download didFinishDownload:^(NSString *savePath, NSString *url) {
           //下载成功
            [_downloadButton setTitle:@"下载成功" forState:(UIControlStateNormal)];
            _downloadButton.enabled = YES;
            
            //下载完成后，保存数据
            RadioPlayDB *radioDB = [[RadioPlayDB alloc]init];
            //创建表
            [radioDB createTable];
            //保存到数据库
            [radioDB saveDownloadRadioInfo:@[model.title,model.coverimg,model.musicUrl,savePath]];
            //
            
        } downloading:^(long long writenByte, CGFloat progress) {
           //下载中
            [_downloadButton setTitle:[NSString stringWithFormat:@"%ld%%",(NSInteger)progress] forState:(UIControlStateNormal)];
            
        }];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    
}

- (IBAction)lastMusic:(UIBarButtonItem *)sender {
    [self refreshUIWithIndex:_manager.index];
    [_manager lastMusic];
}
- (IBAction)playandPauseAction:(UIBarButtonItem *)sender {
    UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
    if (_manager.playStatus == PlayStatusPlay) {
        [_manager pause];
        barButtonItem.title = @"播放";
    }else {
   
    barButtonItem.title = @"暂停";
    [_manager play];
    }
}

- (IBAction)nextMusic:(UIBarButtonItem *)sender {
      [self refreshUIWithIndex:_manager.index];
    [_manager nextMusic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self refreshUIWithIndex:indexPath.row];
}

#pragma  mark--UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    RadioDetailModel *model =_dataListArray[indexPath.row];
    cell.textLabel.text =model.title;
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.musicVisit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
