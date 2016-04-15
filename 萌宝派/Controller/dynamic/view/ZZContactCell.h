//
//  ZZContactCell.h
//  萌宝派
//
//  Created by charles on 15/3/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCConversation;

@interface ZZContactCell : UITableViewCell

@property(nonatomic,strong) RCConversation*  conversation;

+ (ZZContactCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@end
