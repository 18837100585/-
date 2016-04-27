//
//  TopicDetailViewCell.h
//  ProjectA
//
//  Created by laouhn on 16/4/12.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
