//
//  AutoScrollView.m
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "AutoScrollView.h"

@interface AutoScrollView ()<UIScrollViewDelegate>
/**滚动视图*/
@property (nonatomic, strong) UIScrollView *myScrollView;
/** 小圆点*/
@property (nonatomic, strong) UIPageControl *myPageControl;
/**计时器*/
@property (nonatomic, strong) NSTimer *timer;
/**图片数组*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**时间间隔*/
@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation AutoScrollView

- (id)initWithFrame:(CGRect)frame imageUrlArray:(NSMutableArray *)imageArray timeInterval:(NSTimeInterval)time {
    if (self = [super initWithFrame:frame]) {
        //给属性赋值，方便之后使用
        self.dataArray = imageArray;
        self.interval = time;
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:[self.dataArray lastObject]];
        [tempArray addObjectsFromArray:imageArray];
        [tempArray addObject:[imageArray firstObject]];
        [self creatScrollView:tempArray];
        [self initWithTimer];
    }
    return self;
}

#pragma  mark -- 开启计时器
- (void)initWithTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}
//计时器调用方法
- (void)timerAction {
    [self.myScrollView setContentOffset:CGPointMake(_myScrollView.contentOffset.x + _myScrollView.frame.size.width, 0) animated:YES];
}

- (void)creatScrollView:(NSMutableArray *)imageArr {
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    //内容量
    self.myScrollView.contentSize= CGSizeMake(self.bounds.size.width*imageArr.count, self.bounds.size.height);
    self.myScrollView.pagingEnabled = YES;
    _myScrollView.contentOffset = CGPointMake(_myScrollView.frame.size.width,0);
    _myScrollView.delegate = self;
    [self addSubview:_myScrollView];
    
    for (int i = 0; i < imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_myScrollView.frame.size.width *i, 0, _myScrollView.frame.size.width, _myScrollView.frame.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:imageArr[i]]];
        //打开图片的交互
        imageView.userInteractionEnabled= YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:gesture];
        [_myScrollView addSubview:imageView];
    }
    self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width-100, self.bounds.size.height-50, 100, 30)];
    _myPageControl.currentPage = 0;
    _myPageControl.numberOfPages = self.dataArray.count;
    [self addSubview:_myPageControl];
    
    
}

#pragma mark -- 点击图片调用的操作
- (void)tapAction {
    if (_delegate &&[_delegate respondsToSelector:@selector(clickImageViewAtIndex:)]) {
        [_delegate clickImageViewAtIndex:_myPageControl.currentPage];
    }
}

#pragma  mark -- UIScrollViewDelegate
//滚动视图的偏移量发生变化，动态改变pageControl的当前页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.myPageControl.currentPage = [[NSString stringWithFormat:@"%f",pageNum]integerValue]-1;
    
    
}
//开始进行拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //滚动视图将计时器暂停。防止自动滚动与拖拽产生冲突
    [self.timer setFireDate:[NSDate distantFuture]];
}
//已经结束减速，从新开始计时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changeHeaderAndFooterImage];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.interval]];
}
//对最后一张图片和第一种图片进行处理
- (void)changeHeaderAndFooterImage {
    //第一张图片
    if (_myScrollView.contentOffset.x== 0) {
        [_myScrollView setContentOffset:CGPointMake(self.dataArray.count*_myScrollView.frame.size.width, 0) animated:NO];
    }
    //最后一张图片
    if (_myScrollView.contentOffset.x ==((self.dataArray.count + 1)*_myScrollView.frame.size.width)) {
        [_myScrollView setContentOffset:CGPointMake(_myScrollView.frame.size.width,0) animated:NO];
    }
    
}
//结束滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self changeHeaderAndFooterImage];
}

@end
