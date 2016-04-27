//
//  CommentViewController.m
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "CommentViewController.h"
#import "KeyBoardView.h"
#import "CommentTableViewCell.h"
#import "CommonModel.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) KeyBoardView *keyboardV;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CommentViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加评论" style:(UIBarButtonItemStyleDone) target:self action:@selector(addComment)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
    __weak typeof(self) weakself = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        _start =0;
        [_dataArray removeAllObjects];
        [weakself requestData];
        [_tableView reloadData];
        
    }];
    [_tableView triggerPullToRefresh];
    [_tableView addInfiniteScrollingWithActionHandler:^{
        _start+=10;
        [weakself requestData];
        [_tableView reloadData];
    }];
    
}



#pragma mrk -- 请求数据
- (void)requestData {
    UserModel *model = [UserLoad getUserInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:model.auth forKey:@"auth"];
    [dic setObject:[NSString stringWithFormat:@"%@",self.model.readid] forKey:@"contentid"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_start] forKey:@"start"];
    [NetWorkRequestManager requestForPostWithUrl:CommontUrl  parmDic:dic success:^(id responObject) {
        for (NSDictionary *dic  in responObject[@"data"][@"list"]) {
            CommonModel *model = [[CommonModel alloc]init];
            model.addtime_f = dic[@"addtime_f"];
            model.content = dic[@"content"];
            model.icon = dic[@"userinfo"][@"icon"];
            model.uid = dic [@"userinfo"][@"uid"];
            model.uname = dic[@"userinfo"][@"uname"];
            [self.dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            [_tableView.pullToRefreshView stopAnimating];
            [_tableView.infiniteScrollingView stopAnimating];
        });
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark --UItableDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    CommonModel *model =self.dataArray[indexPath.row];
    [cell.oneView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.icon]]];
    cell.contentid.text = model.uname;
    cell.content.text = model.content;
    cell.addtime.text = model.addtime_f;
    return cell;
}


#pragma  mark -- 添加评论
- (void)addComment {
    //键盘将要弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    if (_keyboardV == nil) {
        self.keyboardV = [[KeyBoardView alloc]initWithFrame:CGRectMake(0, hScreenWidth+100, hScreenWidth, 44)];
    }
    //成为第一响应者
    [self.keyboardV.textView becomeFirstResponder];
    //给block回调
    __weak typeof (self)weakSelf = self;
    self.keyboardV.sendComment = ^(NSString *comment) {
        [weakSelf sendCommentWithContent:comment];
    };
    
    [self.view addSubview:_keyboardV];
}

- (void)sendCommentWithContent:(NSString *)content {
    [self.keyboardV.textView canResignFirstResponder];
    UserModel *userInfo = [UserLoad getUserInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:userInfo.auth forKey:@"auth"];
    [dic setObject:[NSString stringWithFormat:@"%@",self.model.readid] forKey:@"contentid"];
    [dic setObject:content forKey:@"content"];
    [NetWorkRequestManager requestForPostWithUrl:ADDCOMMENT_url parmDic:dic success:^(id responObject) {
        NSInteger number = [responObject[@"result"] integerValue ];
        if (number == 1) {
            [self.dataArray removeAllObjects];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self requestData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showMBProgressHUDWithTitle:@"发布中" delay:1];
                });
            });
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
//键盘将要弹出调用
- (void)keyboardWillShow:(NSNotification *)noti {
    //获取键盘的frame
    CGRect keyBoardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘弹出的时长
    CGFloat time = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    [UIView animateWithDuration:time animations:^{
      //  self.keyboardV.transform = CGAffineTransformMakeTranslation(0,-100-keyBoardRect.size.height);
        self.keyboardV.frame = CGRectMake(0, hScreenHeight-44-keyBoardRect.size.height, hScreenWidth, 44);
    }];
}
//键盘将要隐藏调用
- (void)keyboardWillHidden:(NSNotification *)noti {
    //获取键盘的frame
  //CGRect keyBoardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘弹出的时长
    CGFloat time = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    [UIView animateWithDuration:time animations:^{
        //  self.keyboardV.transform = CGAffineTransformMakeTranslation(0,-100-keyBoardRect.size.height);
        self.keyboardV.frame = CGRectMake(0, hScreenWidth-44, hScreenWidth, 44);
        self.keyboardV.textView.text = @"";
        [self.keyboardV removeFromSuperview];
    }];

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.keyboardV .textView resignFirstResponder];
    [self.keyboardV removeFromSuperview];
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
