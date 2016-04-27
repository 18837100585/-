//
//  TopicViewCell.h
//  ProjectA
//
//  Created by laouhn on 16/4/7.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@end
