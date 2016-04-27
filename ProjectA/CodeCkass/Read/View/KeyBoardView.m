//
//  KeyBoardView.m
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "KeyBoardView.h"



@implementation KeyBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //初始化文本输入框
        self.textView = [[UITextView alloc]initWithFrame: CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        //设置textView的字号
        self.textView.font = [UIFont systemFontOfSize:20];
        self.textView.textColor = RandomColor;
        self.textView.backgroundColor = [UIColor yellowColor];
        //更改返回键
        self.textView.returnKeyType = UIReturnKeySend;
        [self addSubview:_textView];
        self.textView.delegate = self;
    }
    return self;
}

#pragma mark --UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //如果点击换行按钮，也就是send按钮
    if ([text isEqualToString:@"\n"]) {
        if (self.sendComment) {
            self.sendComment(self.textView.text);
        }
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    if (_isChange) {
        return;
    }
    //获取文本
    NSString *text = textView.text;
    //计算字体的高度
    CGSize textSize = [text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName]];
    //判断输入内容的宽度是否大于当前视图的宽度
    if (textSize.width > self.textView.frame.size.width) {
        _isChange = YES;
        //改变自身的frame
        CGRect tempRect = self.frame;
        tempRect.size.height +=22;
        tempRect.origin.y -= 22;
        self.frame = tempRect;
        
        //改变输入框的frame
        CGRect textVFrame = self.textView.frame;
        textVFrame.size.height += 18;
        self.textView.frame  = textVFrame;
    }
}


@end
