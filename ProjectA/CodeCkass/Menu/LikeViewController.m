//
//  LikeViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "LikeViewController.h"
#import "ReadListModel.h"
#import "ReadDetailViewCell.h"
#import "ReadDetailDBManager.h"

@interface LikeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//阅读详情(收藏)管理
@property (nonatomic ,strong) ReadDetailDBManager *readDB;

@end

@implementation LikeViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ReadDetailViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
     self.readDB = [[ReadDetailDBManager alloc]init];
    NSArray *array = [_readDB findUserCollectionListWithUserId:[UserLoad getUserInfo].uid];
    [self.dataArray addObjectsFromArray:array];
    
    
    }
- (IBAction)backAction:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    ReadListModel *model =self.dataArray[indexPath.row];
    [cell.oneView  setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.titleLabel.text = model.title;
    cell.nameLabel.text = model.userinfo[@"uname"];
    cell.contentLabel.text = model.content;
    return cell;
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
