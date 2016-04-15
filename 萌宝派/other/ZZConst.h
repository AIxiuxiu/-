//
//  ZZConst.h
//  萌宝派
//
//  Created by zhizhen on 15/7/24.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//  全局变量放在这儿声明

#import <Foundation/Foundation.h>

extern NSString* const ZZReceiveMessageNotification;//接收到新的推送信息
extern NSString* const ZZAppDidBecomeActiveNotification;//app进入前台
extern NSString* const ZZChangeUserHeadImageNotification;//用户改变头像  leftviewC
extern  NSString*  const  ZZUpdateRongYunNewMessageInfoNotification;//接收到融云新消息
extern  NSString*  const   ZZConnectPersonChangeNotification;//关注用户改变
extern  NSString*  const   ZZAttentionPlateChangeNotification;//关注板块改变
extern  NSString*  const   ZZStorePostChangeNotification;//收藏改变
extern  CGFloat  const  upDownSpace ;//导航栏与下部控件的间距
extern  CGFloat  const  ZZTabBarHeight ;//tabbar高度
extern  CGFloat  const  ZZNaviHeight ;//navi高度
extern  CGFloat  const  ZZLineSpace ;//行间距
extern  CGFloat  const  ZZCharSpace ;//字间距
extern  CGFloat  const  ZZParagraphSpace ;//段间距
extern  CGFloat  const  ZZReplyLineSpace ;//行间距
extern  CGFloat  const  ZZLRmargin ;//距离屏幕左右间距
extern  NSUInteger  const  ZZMiMaMinLenth ;//密码最少位数
extern  NSUInteger  const  ZZMiMaMaxLenth ;//密码最多位数
extern  NSUInteger  const  ZZNickMaxLenth ;//密码最多位数
extern  CGFloat  const  ZZNetDely ;//刷新时网络请求延迟时间