//
//  BaseViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/5.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (MBProgressHUD *)creadMBProgressHUD {
    if (_hud == nil) {
        self.hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_hud];
    }
    return _hud;
}

- (void)showMBProgressHUD {
    [self showMBProgressHUDWithTitle:nil];
}

- (void)hiddenMBProgressHUD {
    if (_hud) {
        [_hud removeFromSuperview];
    }
    _hud = nil;
}

- (void)showMBProgressHUDWithTitle:(NSString *)title {
    [self creadMBProgressHUD];
    if (title.length == 0) {
        self.hud.labelText = @"请稍后";
    }else {
        self.hud.labelText = title;
    }
    [_hud show:YES];
}
- (void)showMBProgressHUDWithTitle:(NSString *)title delay:(NSTimeInterval)time {
    [self showMBProgressHUDWithTitle:title];
    [self performSelector:@selector(hiddenMBProgressHUD) withObject:nil afterDelay:time];
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
