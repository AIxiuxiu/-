//
//  ZZMessageTableViewCell.h
//  萌宝派
//
//  Created by zhizhen on 15/4/14.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSystemMessage.h"
@interface ZZMessageTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel* lineLabel;//竖线
@property(nonatomic,strong)UILabel*  circleLabel;//竖线上圆圈
@property(nonatomic,strong)UILabel*   dateLabel;//时间
@property(nonatomic,strong)UILabel*   titleLabel;//标题

@property(nonatomic,strong)UILabel*  horizontalLineLabel;//横线
@property(nonatomic,strong)UILabel*  redPointLabel;//红点

@property(nonatomic,strong)ZZSystemMessage*  message;
@end
