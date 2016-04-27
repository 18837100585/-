//
//  ReadDetailViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/7.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailViewCell.h"
#import "DetailViewController.h"

@interface ReadDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *firstTableView;

@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
@property (strong, nonatomic)  UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic, strong) NSMutableArray *addTimeArray;
@property (nonatomic,strong) NSMutableArray *hotListArray;
@property (nonatomic, strong) NSString *string ;
//请求的开始位置
@property (nonatomic, assign) NSInteger start;
//顶部返回按钮
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation ReadDetailViewController
- (NSMutableArray *)addTimeArray {
    if (!_addTimeArray) {
        self.addTimeArray = [NSMutableArray array];
    }
    return _addTimeArray;
}
- (NSMutableArray *)hotListArray {
    if (!_hotListArray) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segment = [[UISegmentedControl  alloc] initWithItems:@[@"最新", @"最热"]];
    self.segment.selectedSegmentIndex = 0;
   // self.navigationController.navigationBar.translucent=NO;
    self.string = [self.readModel.type stringValue];
    self.segment.frame = CGRectMake(0, 0, 128, 30);
    [self.segment addTarget:self action:@selector(changeSegmentControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
   // self.firstTableView.backgroundColor = [UIColor redColor];
   
    [self.firstTableView registerNib:[UINib nibWithNibName:@"ReadDetailViewCell" bundle:nil] forCellReuseIdentifier:@"FIRST"];
    [self.hotTableView registerNib:[UINib nibWithNibName:@"ReadDetailViewCell" bundle:nil] forCellReuseIdentifier:@"Second"];
   [self refreshAndReloadData];
    [self refreshAndReload];
    
    self.topButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [ _topButton setTitle:@"返回顶部" forState:(UIControlStateNormal)];
    _topButton.backgroundColor = RandomColor;
    _topButton.frame = CGRectMake(0, 0, hScreenWidth, 40);
    [_topButton addTarget:self action:@selector(backToTop) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_topButton];
    
    
}

- (void)backToTop {
    [UIView animateWithDuration:1.5 animations:^{
        if (_segment.selectedSegmentIndex == 0) {
            [_firstTableView setContentOffset:CGPointZero animated:YES];
        }else {
            [_hotTableView setContentOffset:CGPointZero animated:YES];
        }
        self.topButton.frame = CGRectMake(0, 0, hScreenWidth, 40);
    }];
}

- (void)refreshAndReloadData {
    //添加下拉刷新方法
    __weak typeof(self)weakself = self;
    [_firstTableView addPullToRefreshWithActionHandler:^{
        if (_addTimeArray.count !=0) {
            [_addTimeArray removeAllObjects];
        }
        
        [weakself requeseDatawithSort:@"addtime"];
        [weakself.firstTableView reloadData];
    }];
    //程序自动调用下拉刷新方法
    [_firstTableView triggerPullToRefresh];
    //设置自定义标题
    [_firstTableView.pullToRefreshView setTitle:@"门口有美女" forState:(SVPullToRefreshStateAll)];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"YYYY/MM/dd:hh:mm:ss"];
    NSString *nowString = [dataFormatter stringFromDate:nowDate];
    //设置子标题
    [_firstTableView.pullToRefreshView setSubtitle:nowString forState:(SVPullToRefreshStateAll)];
    //设置箭头颜色
    _firstTableView.pullToRefreshView.arrowColor = RandomColor;
    
    //上拉加载
    [_firstTableView addInfiniteScrollingWithActionHandler:^{
        _start +=10;
        [weakself requeseDatawithSort:@"addtime"];
        [weakself.firstTableView reloadData];
    }];
    [_firstTableView triggerInfiniteScrolling];

    
}



- (void)refreshAndReload {
    //添加下拉刷新方法
    __weak typeof(self)weakself = self;
    [_hotTableView addPullToRefreshWithActionHandler:^{
        if (_hotListArray.count !=0) {
            [_hotListArray removeAllObjects];
        }
        
        [weakself requeseDatawithSort:@"hot"];
        [weakself.hotTableView reloadData];
    }];
    //程序自动调用下拉刷新方法
    [_hotTableView triggerPullToRefresh];
    //设置自定义标题
    [_hotTableView.pullToRefreshView setTitle:@"门口有美女" forState:(SVPullToRefreshStateAll)];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"YYYY/MM/dd:hh:mm:ss"];
    NSString *nowString = [dataFormatter stringFromDate:nowDate];
    //设置子标题
    [_hotTableView.pullToRefreshView setSubtitle:nowString forState:(SVPullToRefreshStateAll)];
    //设置箭头颜色
    _hotTableView.pullToRefreshView.arrowColor = RandomColor;
    
    //上拉加载
    [_hotTableView addInfiniteScrollingWithActionHandler:^{
        _start +=10;
        [weakself requeseDatawithSort:@"hot"];
        [weakself.hotTableView reloadData];
    }];
    [_hotTableView triggerInfiniteScrolling];
    

}

//请求数据
- (void)requeseDatawithSort:(NSString *)sort {
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSString stringWithFormat:@"%@",self.string] forKey:@"typeid"];
    [dic setObject:sort forKey:@"sort"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_start] forKey:@"start"];

   [NetWorkRequestManager requestForPostWithUrl:ReadDetailUrl parmDic:dic success:^(id responObject) {
       if ([sort isEqualToString: @"addtime"]) {
           for (NSDictionary *dic in responObject[@"data"][@"list"]) {
               self.readModel = [[ReadListModel alloc]init];
               [self.readModel setValuesForKeysWithDictionary:dic];
                self.readModel.contentid = dic[@"id"];
               self.readModel.readid= dic[@"id"];
               [self.addTimeArray addObject:self.readModel];
           }
       }
       if ([sort isEqualToString:@"hot"]) {
           for (NSDictionary *dic in responObject[@"data"][@"list"]) {
                 self.readModel = [[ReadListModel alloc]init];
                [self.readModel setValuesForKeysWithDictionary:dic];
               self.readModel.contentid = dic[@"id"];
               [self.hotListArray addObject:self.readModel];
            
           }
           
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           [_firstTableView.pullToRefreshView stopAnimating];
           [_firstTableView.infiniteScrollingView stopAnimating];
           [self.hotTableView.pullToRefreshView stopAnimating];
           [_hotTableView.infiniteScrollingView stopAnimating];
           [self.firstTableView reloadData];
           [self.hotTableView reloadData];
       });

   } failure:^(NSError *error) {
       
   }];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return self.addTimeArray.count;
    }
        return  self.hotListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        ReadDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FIRST"];
        self.readModel = self.addTimeArray[indexPath.row];
       [cell.oneView setImageWithURL:[NSURL URLWithString:self.readModel.coverimg]];
        cell.nameLabel.text = self.readModel.name;
        cell.titleLabel.text = self.readModel.title;
        cell.contentLabel.text =self.readModel.content;
        return cell;
    }
    ReadDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Second"];
    self.readModel = self.hotListArray[indexPath.row];
    [cell.oneView setImageWithURL:[NSURL URLWithString:self.readModel.coverimg]];
    cell.nameLabel.text = self.readModel.name;
    cell.titleLabel.text = self.readModel.title;
    cell.contentLabel.text =self.readModel.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    if (tableView == self.firstTableView) {
        detailVC.model = [self.hotListArray objectAtIndex:indexPath.row];
    }
    detailVC.model = self.addTimeArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)changeSegmentControl:(UISegmentedControl *)sender {
    UISegmentedControl *seg  = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex ) {
        case 0:
            [_rootScrollView setContentOffset:CGPointZero animated:YES];
            break;
        case 1:
            [_rootScrollView setContentOffset:CGPointMake(hScreenWidth, 0)];
            break;
        default:
            break;
    }
}
#pragma  mark --UIScrollViewDelegate
//已经减速结束，改变seg的选中下标
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.rootScrollView) {
            self.segment.selectedSegmentIndex = scrollView.contentOffset.x/hScreenWidth;
    }else {
        if (scrollView.contentOffset.y >=2*hScreenHeight) {
            self.topButton.frame = CGRectMake(0, 64, hScreenWidth, 40);
        }
    }

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
