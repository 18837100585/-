//
//  KeyBoardView.h
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyBoardView : UIView<UITextViewDelegate>

//是否进行换行处理
@property (nonatomic, assign) BOOL isChange;
//输入文本框
@property (nonatomic, strong) UITextView *textView;
//发送评论的回调
@property (nonatomic, copy) void(^sendComment)(NSString *content);

@end
