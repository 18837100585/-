//
//  LoginViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "RegisterViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(registerAction)];
    
}

- (void)registerAction {
    RegisterViewController *registVC = [[RegisterViewController alloc]init];
    [self.navigationController presentViewController:registVC animated:YES completion:nil];
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//登陆操作
- (IBAction)loginButonAction:(UIButton *)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:_nameTextField.text forKey:@"email"];
    [dic setObject:_passwordTextField.text forKey:@"passwd"];
    [NetWorkRequestManager requestForPostWithUrl:LoginUrl parmDic:dic success:^(id responObject) {
        //登陆结果
        NSInteger result = [responObject[@"result"] integerValue] ;
        //登陆成功
        if (result ==1) {
            [UserLoad cleanUserInfo];
            UserModel *userModel = [[UserModel alloc]init];
            [userModel setValuesForKeysWithDictionary:responObject[@"data"]];
            //存储用户信息
            [UserLoad  saveUserInfoWith:userModel];
            //返回左侧菜单栏页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            //登陆失败
        }else {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
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
