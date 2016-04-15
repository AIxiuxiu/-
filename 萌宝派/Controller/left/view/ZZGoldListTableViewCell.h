//
//  ZZGoldListTableViewCell.h
//  萌宝派
//
//  Created by charles on 15/4/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZGoldRecord.h"
@interface ZZGoldListTableViewCell : UITableViewCell
+ (ZZGoldListTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)ZZGoldRecord* goldRecord;

@end
