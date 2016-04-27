//
//  CommentTableViewCell.h
//  ProjectA
//
//  Created by laouhn on 16/4/11.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *contentid;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *addtime;

@end
