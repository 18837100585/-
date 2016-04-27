//
//  RadioTableViewCell.h
//  ProjectA
//
//  Created by laouhn on 16/4/6.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *oneView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;

@end
