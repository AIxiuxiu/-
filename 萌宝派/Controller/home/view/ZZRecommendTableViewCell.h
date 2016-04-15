//
//  ZZRecommendTableViewCell.h
//  萌宝派
//
//  Created by zhizhen on 15-3-4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPlateTypeInfo.h"
@interface ZZRecommendTableViewCell : UITableViewCell

+ (ZZRecommendTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UIImageView*  typeImageView;  //类型图
@property(nonatomic,strong)UILabel*  describeLabel;  //描述label 如精彩专区
@property(nonatomic,strong)UILabel* typeLabel;   //类型label
@property(nonatomic,strong)UILabel*   publishCountLabel;  //发帖数量label
@property(nonatomic,strong)UILabel*   detailLabel;   //详情label
//@property(nonatomic,strong)UIButton*  attentionButton;   //关注按钮
@property(nonatomic,strong)UILabel*  lineLabel;//线

@property(nonatomic,strong)ZZPlateTypeInfo*  plateType;

@property(nonatomic,strong)UIImageView* publishIV;
@property(nonatomic,strong)UIImageView* heartIv;
@end
