//
//  ZZExpertIntroduceCell.h
//  萌宝派
//
//  Created by charles on 15/4/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZExpert.h"
@interface ZZExpertIntroduceCell : UITableViewCell
@property(nonatomic,strong)UILabel* adeptLabel;//专长
@property(nonatomic,strong)UILabel* experienceLabel;//经验
@property(nonatomic,strong)UILabel* adeptContentLabel;//专长内容
@property(nonatomic,strong)UILabel* experienceContentLabel;//经验内容
@property(nonatomic,strong)UILabel* lineLabel;//一线
@property(nonatomic)float cellHeight;
@property(nonatomic,strong)ZZExpert* expertUser;
@end
