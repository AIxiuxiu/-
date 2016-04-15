//
//  ZZAttentionTableViewCell.h
//  萌宝派
//
//  Created by zhizhen on 15/4/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZUser;
@interface ZZAttentionTableViewCell : UITableViewCell

@property (nonatomic, strong)ZZUser *user;
@property(nonatomic,strong)UIImageView* bigLv;
@property(nonatomic,strong)UIImageView* middleLv;
@property(nonatomic,strong)UIImageView* smallLv;
@property(nonatomic,strong)UIImageView* headImage;
@property(nonatomic,strong)UILabel* nickLabel;
@property(nonatomic,strong)UILabel* permissLabel;
@property(nonatomic,strong)UILabel* numberLabel;
@property(nonatomic,strong)UIImageView* iconImage;
@property(nonatomic,strong)UILabel* lineLabel;

+ (ZZAttentionTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@end
