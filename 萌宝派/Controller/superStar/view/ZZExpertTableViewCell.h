//
//  ZZExpertTableViewCell.h
//  萌宝派
//
//  Created by charles on 15/4/8.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZExpertTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView* superStarHeadImageView;//达人头像
@property(nonatomic,strong)UILabel* superStarNameLabel;//达人名字
@property(nonatomic,strong)UIButton* attentionButton;//达人按钮
@property(nonatomic,strong)UILabel* lineLabel;
@property(nonatomic)BOOL attention;
@end
