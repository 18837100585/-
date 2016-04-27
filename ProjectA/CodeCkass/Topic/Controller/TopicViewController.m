//
//  TopicViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "TopicViewController.h"
#import "ReadListModel.h"
#import "TopicViewCell.h"
#import "TopicDetailViewController.h"

@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TopicViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicViewCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailViewController *detailVC= [[TopicDetailViewController alloc]init];
    detailVC.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
    ReadListModel *model = self.dataArray[indexPath.row];
    NSString *string = model.userinfo[@"icon"];
    [cell.oneView setImageWithURL:[NSURL URLWithString:string]];
    cell.oneView.layer.masksToBounds = YES;
    cell.oneView.layer.cornerRadius= 25;
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.content;
    cell.nameView.text = model.userinfo[@"uname"];
    cell.viewLabel.text = [NSString stringWithFormat:@"%@",model.counterList[@"view"]];
    cell.likeLabel.text = [NSString stringWithFormat:@"%@",model.counterList[@"like"]];
    cell.commentLabel.text = [NSString stringWithFormat:@"%@",model.counterList[@"comment"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)requestData {
    [NetWorkRequestManager requestForPostWithUrl:TopicUrl parmDic:nil success:^(id resultObject) {
        for (NSDictionary *dic in resultObject[@"data"][@"list"]) {
            ReadListModel *model = [[ReadListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
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
