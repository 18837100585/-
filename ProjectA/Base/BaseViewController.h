//
//  BaseViewController.h
//  ProjectA
//
//  Created by laouhn on 16/4/5.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong)MBProgressHUD *hud;

- (void)showMBProgressHUD;

- (void)hiddenMBProgressHUD;

- (void)showMBProgressHUDWithTitle:(NSString *)title;
- (void)showMBProgressHUDWithTitle:(NSString *)title delay:(NSTimeInterval)time;

@end
