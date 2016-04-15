//
//  ZZTopicPostCell.h
//  竖版改版
//
//  Created by charles on 15/3/5.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//
@class ZZPost;
@class ZZUprightViewController;
#import <UIKit/UIKit.h>

@interface ZZTopicPostCell : UITableViewCell
@property(nonatomic,strong)UIView* postBackGround;
@property(nonatomic,strong)UIImageView* headImage;
@property(nonatomic,strong)UILabel* name;
@property(nonatomic,strong)UIImageView* bigLv;
@property(nonatomic,strong)UIImageView* midLv;
@property(nonatomic,strong)UIImageView* sLv;
@property(nonatomic,strong)UIImageView* clockImage;
@property(nonatomic,strong)UIImageView* readImage;
@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* countLabel;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* contentLabel;

@property(nonatomic,strong)UIImageView* pictureImage1;
@property(nonatomic,strong)UIImageView* pictureImage2;
@property(nonatomic,strong)UIImageView* pictureImage3;

@property(nonatomic,strong)UILabel*  identityLabel;//身份label
/**
 *0527 王雷添加的属性 置顶
 */
@property(nonatomic,strong)UIImageView* topImageView;
/**
 *  0527 王雷添加的属性 删除按钮
 */
@property(nonatomic,strong)UIButton* deleteButton;
/**
 *  这个cell显示的帖子
 */
@property(nonatomic,strong)ZZPost* topicCellpost;
/**
 *  委托，回调
 */
@property(nonatomic,weak)ZZUprightViewController*  delegate;
@end
