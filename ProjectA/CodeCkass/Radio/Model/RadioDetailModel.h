//
//  RadioDetailModel.h
//  ProjectA
//
//  Created by laouhn on 16/4/9.
//  Copyright © 2016年 Seastar. All rights reserved.
//

#import "RadioListModel.h"

@interface RadioDetailModel : RadioListModel

@property (nonatomic, strong) NSDictionary *radioInfo;
@property (nonatomic, strong) NSString *musicVisit;
@property (nonatomic, strong) NSString *musicUrl;
@property (nonatomic, strong) NSString *webview_url;

@end
