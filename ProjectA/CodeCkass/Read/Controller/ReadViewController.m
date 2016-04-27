//
//  ReadViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/5.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadCollectionViewCell.h"
#import "ReadListModel.h"
#import "CarouseModel.h"
#import "MBProgressHUD.h"
#import "BaseViewController.h"
#import "ReadDetailViewController.h"

@interface ReadViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AutoScrollViewDelegate>

@property (nonatomic , strong) UICollectionView *readCollectionView;
@property (nonatomic, strong)NSMutableArray *readListArray;
@property (nonatomic, strong) NSMutableArray *carouseArray;//轮播图数据源
@property (nonatomic, strong) AutoScrollView *rootScrollView;
@end

@implementation ReadViewController

- (NSMutableArray *)readListArray {
    if (!_readListArray) {
        self.readListArray = [NSMutableArray array];
    }
    return _readListArray;
}
- (NSMutableArray *)carouseArray {
    if (!_carouseArray ) {
        self.carouseArray = [NSMutableArray array];
    }
    return _carouseArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatCollectionView];
    [self reaquestData];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"nav_menu_icon@2x"];
      self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailViewController *readDetail = [[ReadDetailViewController alloc]init];
    readDetail.readModel = [self.readListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:readDetail animated:YES];
}

- (void)reaquestData {
      [self showMBProgressHUD];
    [NetWorkRequestManager requestForPostWithUrl:ReadUrl parmDic:nil success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"data"][@"list"]) {
            ReadListModel *model = [[ReadListModel alloc]init];
            [model setValue:dic[@"type"]forKey:@"type"];
            [model setValuesForKeysWithDictionary:dic];
            [self.readListArray addObject:model];
            //轮播图数据源
            NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"carousel"]) {
                CarouseModel *model = [[CarouseModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [imageArray addObject:model.img];
                [self.carouseArray addObject:model];
                
            }
            
            //回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.rootScrollView = [[AutoScrollView alloc]initWithFrame:CGRectMake(0, 64, hScreenWidth, 164) imageUrlArray:imageArray timeInterval:2];
                self.rootScrollView.delegate = self;
                [self.view addSubview:_rootScrollView];
                [self.readCollectionView reloadData];
            });
        }
        
    } failure:^(NSError *error) {
        NSLog(@"hh");
    }];
    [self hiddenMBProgressHUD];
}
#pragma mark -- AutoScrollViewDelegate
//轮播图代理方法
- (void)clickImageViewAtIndex:(NSInteger)index {
   // NSLog(@"点击%ld",index);
}

#pragma mark -- 创建集合视图
- (void)creatCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((hScreenWidth-20)/3,(hScreenHeight -164-20-64)/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    self.readCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 164+64, hScreenWidth, hScreenHeight-164-64) collectionViewLayout:flowLayout];
   // _readCollectionView.backgroundColor = RandomColor;
    _readCollectionView.delegate = self;
    _readCollectionView.dataSource = self;
    [_readCollectionView registerNib:[UINib nibWithNibName:@"ReadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ReadCell"];
    [self.view addSubview:_readCollectionView];
}

#pragma mark --UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.readListArray.count;
}

#pragma mark --UICollectionViewDataSource


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadCollectionViewCell *cell = [_readCollectionView  dequeueReusableCellWithReuseIdentifier:@"ReadCell" forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    ReadListModel *model = self.readListArray[indexPath.row];
    [cell.oneView setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.titleLabel.text = model.name;
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
