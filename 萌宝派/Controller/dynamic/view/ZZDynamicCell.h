//
//  ZZDynamicCell.h
//  萌宝派
//
//  Created by charles on 15/3/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
@interface ZZDynamicCell : UITableViewCell
@property (nonatomic, strong)ZZUser *user;

+ (ZZDynamicCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@end
