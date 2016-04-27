//
//  RadioDetailViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/8.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailModel.h"
#import "RadioDetailViewCell.h"
#import "RadioPlayViewController.h"

@interface RadioDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSMutableArray *playListArray;

@end

@implementation RadioDetailViewController

- (NSMutableArray *)playListArray {
    if (!_playListArray) {
        self.playListArray = [NSMutableArray array];
    }
    return _playListArray;
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioDetailViewCell" bundle:nil] forCellReuseIdentifier:@"RadioDetailCell"];
    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlayViewController *playVC = [[RadioPlayViewController alloc]init];
    playVC.dataListArray= self.listArray;
    playVC.dataArray = self.playListArray;
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)requestData {
    [self showMBProgressHUD];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:self.model.radioid forKey:@"radioid"];
    [NetWorkRequestManager requestForPostWithUrl:RadioDetail parmDic:dic success:^(id responObject) {
        self.dictionary = responObject[@"data"][@"radioInfo"];
            for (NSDictionary *dic  in responObject[@"data"][@"list"]) {
            RadioDetailModel *model =  [[RadioDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
                [model setValue:dic[@"playInfo"][@"webview_url"] forKey:@"webview_url"];
                [self.playListArray addObject:model.musicUrl];
            [self.listArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.tableHeaderView=[self creadHeaderView];
            [self.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
    [self hiddenMBProgressHUD];
}

- (UIView *)creadHeaderView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, hScreenWidth, 300)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, hScreenWidth-10, 240)];
    [image setImageWithURL:[NSURL URLWithString:self.dictionary[@"coverimg"]]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 250, hScreenWidth-10, 30)];
    label.text = self.dictionary[@"desc"];
    [view addSubview:image];
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioDetailCell"];
    RadioDetailModel *model = self.listArray[indexPath.row];
    [cell.oneView setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.titleLabel.text = model.title;
    cell.visitLabel.text = model.musicVisit;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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
