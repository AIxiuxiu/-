//
//  ZZNewsCell.h
//  萌宝派
//
//  Created by charles on 15/3/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZMessage;

@interface ZZNewsCell : UITableViewCell


@property(nonatomic,strong)ZZMessage*  message;
+ (ZZNewsCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@end
