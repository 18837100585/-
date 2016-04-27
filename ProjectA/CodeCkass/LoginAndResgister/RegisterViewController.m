//
//  RegisterViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *honey;

@end

@implementation RegisterViewController
- (IBAction)registeButtonAction:(UIButton *)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:self.nameTextFiled.text forKey:@"email"];
    [dic setObject:self.honey.text forKey:@"uname"];
    [dic setObject:self.passwordTextFiled.text forKey:@"passwd"];
   [NetWorkRequestManager requestForPostWithUrl:Register_URL parmDic:dic success:^(id responObject) {
       NSInteger result = [responObject [@"result"] integerValue];
       if ( result == 1) {
           UserModel *userModel = [[UserModel alloc]init];
           [userModel setValuesForKeysWithDictionary:responObject[@"data"]];
        userModel.coverimg = @"";
           [UserLoad cleanUserInfo];
           [UserLoad saveUserInfoWith:userModel];
           dispatch_async(dispatch_get_main_queue(), ^{
               [self dismissViewControllerAnimated:YES completion:^{
                   
               }];
           });
       }else {
           UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:responObject[@"data"][@"msg"] preferredStyle:(UIAlertControllerStyleAlert)];
           UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
               
           }];
           [alertC addAction:sureAction];
           dispatch_async(dispatch_get_main_queue(), ^{
               [self presentViewController:alertC animated:YES completion:nil];
           });
       }
       
       
   } failure:^(NSError *error) {
       
   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title =@"注册";
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
