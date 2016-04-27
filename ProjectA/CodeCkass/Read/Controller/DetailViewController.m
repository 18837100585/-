//
//  DetailViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/7.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+Html.h"
#import "CommentViewController.h"
#import "ReadDetailDBManager.h"
#import "DetailModel.h"

@interface DetailViewController ()<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//阅读详情(收藏)管理
@property (nonatomic ,strong) ReadDetailDBManager *readDB;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIBarButtonItem *shareBUttonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:(UIBarButtonItemStylePlain) target:self action:@selector(shareAction:)];
    UIBarButtonItem *collectionBUttonItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:(UIBarButtonItemStylePlain) target:self action:@selector(collectionAction:)];
    UIBarButtonItem *commonBUttonItem = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:(UIBarButtonItemStylePlain) target:self action:@selector(commonAction:)];
    self.navigationItem.rightBarButtonItems = @[shareBUttonItem,collectionBUttonItem,commonBUttonItem];
    
    self.readDB = [[ReadDetailDBManager alloc]init];
    //查询用户收藏的列表
    NSArray *array = [_readDB findUserCollectionListWithUserId:[UserLoad getUserInfo].uid];
    //遍历收藏列表，看是否该文章已经被收藏
    for (ReadListModel *model in array) {
        if ([model.readid isEqualToString:_model.readid ]) {
            collectionBUttonItem.title = @"取消收藏";
            break;
        }
    }
    
    [self requestData];
}
- (void)shareAction:(UIBarButtonItem *)sender {
    if ([UserLoad isLoad]) {
        //分享功能实现
        //1.要分享的视图控制器
        //2.友盟的appKey
        //3.要分享的内容
        [UMSocialSnsService presentSnsIconSheetView:self appKey:U_MengShareAPPKEY shareText:self.model.content  shareImage:[UIImage imageNamed:@"1_2.png"]  shareToSnsNames:@[UMShareToQQ,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone] delegate:(id<UMSocialUIDelegate>)self];
    }else {
        [self loginAction];
    }
    
    
    
}
- (void)collectionAction:(UIBarButtonItem *)sender {
    if ([UserLoad isLoad]) {
        //创建表，如果表已经存在，直接存放数据
        [self.readDB creatTable];
        if ([sender.title isEqualToString:@"取消收藏"]) {
            sender.title = @"收藏";
            //移除数据
            [self .readDB deleteReadDetailModelWithid:_model.readid];
            NSLog(@"---------%@",_model.readid);
            return;
        }
        //如果没有收藏
        [self.readDB saveReadDetailModel:_model];
        sender.title = @"取消收藏";
      
    }else {
        [self loginAction];
    }
    
}

- (void)loginAction {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:nil];
}

- (void)commonAction:(UIBarButtonItem *)sender {
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.model = self.model;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:self.model.contentid forKey:@"contentid"];
   [NetWorkRequestManager requestForPostWithUrl:DetailUrl parmDic:dic success:^(id responseObject) {
       //默认情况下，UIWebView加载html时，会以原始页面的大小进行显示，如果页面超过webView的大小，则会出现滚动效果，那么用户只能通过滚动查看不同区域的内容，不能使用捏合手势进行方法和缩小
       
       NSString *htmlString = responseObject[@"data"][@"html"];
       NSString *changeString = [NSString importStyleWithHtmlString:htmlString];
       //baseUrl可以让webView按照本地样式进行加载
       NSURL *baseUrl = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
       [self.webView loadHTMLString:changeString baseURL:baseUrl];
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
