//
//  ProductViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductTableViewCell.h"
#import "ReadListModel.h"

@interface ProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
 
@end

@implementation ProductViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requeseData];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProduceCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProduceCell"];
    ReadListModel *model = self.dataArray[indexPath.row];
    cell.titleCell.text = model.title;
    [cell.oneView setImageWithURL:[NSURL URLWithString:model.coverimg]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)requeseData {
   [ NetWorkRequestManager requestForPostWithUrl:ProductUrl parmDic:nil success:^(id responObject) {
       for (NSDictionary *dic  in responObject[@"data"][@"list"]) {
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
