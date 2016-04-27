//
//  WelcomeViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ReadViewController.h"
#import "DDMenuController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) AppDelegate *app;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatView];
}

- (void)creatView {
    NSArray *array = [NSArray arrayWithObjects:@"seastar1.jpg",@"seastar2.jpg",@"seastar3.jpg" ,nil];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, hScreenWidth, hScreenHeight)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(array.count *hScreenWidth, hScreenHeight);
   //添加图片到滚动视图
    for (int i =0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*hScreenWidth, 0, hScreenWidth, hScreenHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"seastar%d.jpg",i+1]];
        //最后一张图片添加手势
        if (i== array.count -1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popToRootViewController)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
        [scrollView addSubview:imageView];
    }
    [self.view addSubview:scrollView];
}

- (void)popToRootViewController {
    //设置plist中是否第一次启动的key值，下次启动不再模态出该页面
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:THEFIRSTLUNCH];
    ReadViewController *readVC = [[ReadViewController alloc]init];
    readVC.title = @"阅读";
 UINavigationController *readNVC = [[UINavigationController alloc]initWithRootViewController:readVC];
 DDMenuController *ddm = [[DDMenuController alloc]initWithRootViewController:readNVC];
 
    MenuViewController *menuVC= [[MenuViewController alloc]init];
    menuVC.ddm = ddm;
    ddm.leftViewController = menuVC;
    self.view.window.rootViewController =ddm;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
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
