//
//  TopicDetailViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/9.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicDetailModel.h"
#import "TopicDetailViewCell.h"


@interface TopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopicDetailViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicDetailViewCell" bundle:nil] forCellReuseIdentifier:@"ONECELL"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ONECELL"];
    TopicDetailModel *model = self.dataArray[indexPath.row];
    [cell.oneView  setImageWithURL:[NSURL URLWithString:model.userinfo[@"icon"]]];
    cell.titleLabel.text = model.userinfo[@"uname"];
    cell.addTimeLabel.text = model.addtime_f;
    cell.contentLabel.text = model.content;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:self.model.contentid forKey:@"contentid"];
    [NetWorkRequestManager requestForPostWithUrl:TopicDetail parmDic:dic success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"commentlist"]) {
            TopicDetailModel *model = [[TopicDetailModel alloc]init];
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
