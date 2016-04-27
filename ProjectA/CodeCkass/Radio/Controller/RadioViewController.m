//
//  RadioViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioTableViewCell.h"
#import "CarouseModel.h"
#import "AutoScrollView.h"
#import "RadioDetailViewController.h"

@interface RadioViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *carouseArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AutoScrollView *rootScrollView;
@end

@implementation RadioViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)carouseArray {
    if (!_carouseArray) {
        self.carouseArray = [NSMutableArray array];
    }
    return _carouseArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"电台";
    [self requestData];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, hScreenWidth, hScreenHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioTableViewCell" bundle:nil] forCellReuseIdentifier:@"RadioCell"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.rootScrollView];
 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc]init];
    detailVC.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)requestData {
    [self showMBProgressHUD];
    [NetWorkRequestManager requestForPostWithUrl:radioUrl parmDic:nil success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"alllist"]) {
            RadioListModel *model = [[RadioListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
          // NSLog(@"%ld",_dataArray.count);
        }
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in responseObject[@"data"][@"carousel"]) {
            CarouseModel *model = [[CarouseModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [imageArray addObject:model.img];
            [self.carouseArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rootScrollView = [[AutoScrollView alloc]initWithFrame:CGRectMake(0, 0, hScreenWidth, 150) imageUrlArray:imageArray timeInterval:2];
        
            self.tableView.tableHeaderView =_rootScrollView;
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
    [self hiddenMBProgressHUD];
}
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 110;
    }
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RadioCell" forIndexPath:indexPath];
    
    RadioListModel *model = self.dataArray[indexPath.row];
    [cell.oneView setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.titleLabel.text = model.title;
   cell.nameLabel.text = model.userinfo[@"uname"];
    cell.detailLabel.text = model.desc;
    cell.zanLabel.text =[NSString stringWithFormat: @"%@",model.count];
    return cell;WithUrl
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
