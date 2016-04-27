//
//  DownloadViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/14.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "DownloadViewController.h"
#import "RadioPlayDB.h"
#import "DownloadManager.h"
#import "ReadDetailViewCell.h"
#import "RadioDetailModel.h"

@interface DownloadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)RadioPlayDB *radioDB;

@end

@implementation DownloadViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.radioDB = [[RadioPlayDB alloc]init];
    NSArray *array = [_radioDB getDownloadList];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReadDetailViewCell" bundle:nil] forCellReuseIdentifier:@"NEWCELL"];

    [self.dataArray addObjectsFromArray:array];
   
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NEWCELL"];
  
    
   [cell.oneView setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"coverimg"]]];
   cell.titleLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
