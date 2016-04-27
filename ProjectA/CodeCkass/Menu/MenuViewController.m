//
//  MenuViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/5.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "ReadViewController.h"
#import "RadioViewController.h"
#import "ProductViewController.h"
#import "TopicViewController.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LikeViewController.h"
#import "DownloadViewController.h"

@interface MenuViewController ()<UITableViewDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.dataArray = [NSMutableArray arrayWithObjects:@"阅读",@"电台",@"良品",@"话题", nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UserModel *model = [UserLoad getUserInfo ];
    if (model) {
        [self .loginButton setTitle:model.uname forState:(UIControlStateNormal)];
    }else {
         [self .loginButton setTitle:@"登陆|注册" forState:(UIControlStateNormal)];
    }
    
}
#pragma mark --登陆与注册
- (IBAction)loginAndRegisterButton:(UIButton *)sender {//登陆
    if ([UserLoad isLoad]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [UserLoad cleanUserInfo];
           //  [self .loginButton setTitle:@"登陆|注册" forState:(UIControlStateNormal)];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:sureAction];
        [alertVC addAction:cancel];
        [self.view.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
        //未登陆
    }else {
        [self loginAction];
    }
 
    
}

- (void)loginAction {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController *LoginNVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self.view.window.rootViewController presentViewController: LoginNVC animated:YES completion:nil];
}
#pragma mark --收藏
- (IBAction)collectionButtonAction:(UIButton *)sender {
    LikeViewController *likeVC = [[LikeViewController alloc]init];
    [self.view.window.rootViewController presentViewController:likeVC animated:YES completion:nil];
    
}
#pragma  mark -- 下载
- (IBAction)downloadButtonAction:(UIButton *)sender {
    DownloadViewController *downloadVC = [[DownloadViewController alloc]init];
    [self.view.window.rootViewController presentViewController:downloadVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- UITableDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DDMenuController *ddm = ((AppDelegate *)[UIApplication sharedApplication].delegate).ddm;
    DDMenuController *ddm1 = self.ddm;
    UIViewController *tempVC = nil;
    switch (indexPath.row) {
        case 0:
            tempVC = [[ReadViewController alloc]init];
            break;
          case 1:
            tempVC =[[RadioViewController alloc]init];
            break;
            case 2:
            tempVC = [[ProductViewController alloc]init];
            break;
            case 3:
            tempVC= [[TopicViewController alloc]init];
            break;
        default:
            break;
    }
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:tempVC];
   [ddm setRootController:navigation animated:YES];
    [ddm1 setRootController:navigation animated:YES];
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
