//
//  ZZUprightViewController.h
//  萌宝派
//
//  Created by charles on 15/3/10.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSecondViewController.h"
#import "ZZHeaderView.h"
#import "ZZPlateTypeInfo.h"
@interface ZZUprightViewController : ZZSecondViewController
@property(nonatomic,strong)ZZHeaderView* topView;
@property(nonatomic,strong)ZZPlateTypeInfo*  plateType;
@property(nonatomic,strong)UITableView* topicView;
//@property(nonatomic,strong)UIImageView* headImage;
//@property(nonatomic,strong)UILabel* topicName;
//@property(nonatomic,strong)UILabel* endLabel;
//@property(nonatomic,strong)UILabel* number;
//@property(nonatomic,strong)UIButton* attentionButton;
//@property(nonatomic,strong)UILabel* contentLabel;
/**
 *  发布成功后刷新帖子列表
 *
 *  @param dic 发布成功后返回的数据
 */
-(void)publishSuccessRefreshWith:(NSDictionary*)dic;
/**
 *  帖子cell删除按钮回调事件
 *
 *  @param deleteIndexpath 删除的那个cell
 */
-(void)topicPostCellDeleteButtonActionWithIndexPath:(NSIndexPath*)deleteIndexpath;
/**
 *  帖子cell头像点击回调事件
 *
 *  @param clickIndexpath 被点击头像的那个cell 
 */
-(void)topicpostCellHeadImageClickedWithIndexPath:(NSIndexPath*) clickIndexpath;
@end
