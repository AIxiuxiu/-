//
//  ZZWonderDetailViewController.h
//  萌宝派
//
//  Created by zhizhen on 15-3-16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//
@class ZZReplayInformation;

#import "ZZSecondViewController.h"
#import "ZZPost.h"

@interface ZZWonderDetailViewController : ZZSecondViewController

@property(nonatomic,strong)ZZPost* postIncoming;

@property(nonatomic,strong)UITableView* detailView;


///**
// *  回复cell头像点击事件
// *
// *  @param user 选中的cell对应的用户
// */
//-(void)replayCellClickHeadImageActionWithUser:(ZZUser*)user;
//
///**
// *  回复cell删除按钮点击事件
// *
// *  @param indexpath 要删除的cell的区、行
// */
//-(void)replayCellDeleteButtonActionWithDeleteIndexpath:(NSIndexPath*)indexpath;
//
///**
// *  回复cell举报按钮点击事件
// *
// *  @param indexpath 要举报的cell的区、行
// */
//-(void)replayCellReportButtonActionWithReportIndexpath:(NSIndexPath*)indexpath;
//
///**
// *  回复cell回复按钮点击事件
// *
// *  @param replay   要回复的cell
// */
//-(void)replayCellReplayButtonActionWithReplay:(ZZReplayInformation*)replay;
//
///**
// *  回复cell显示的图片点击事件
// *
// *  @param indexpath 点击的图片的cell的区、行
// */
//-(void)replayCellClickShowImageActionWithReplay:(ZZReplayCell*)replayCell;
@end
