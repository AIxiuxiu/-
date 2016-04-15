//
//  ZZConst.m
//  萌宝派
//
//  Created by zhizhen on 15/7/24.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
NSString * const ZZReceiveMessageNotification = @"ReceiveNewMessage";
NSString * const ZZAppDidBecomeActiveNotification = @"AppDidBecomeActive";
NSString * const  ZZUpdateRongYunNewMessageInfoNotification = @"UpdateRongYunNewMessageInfo";
NSString * const  ZZConnectPersonChangeNotification = @"ConnectPersonChange";
NSString * const   ZZAttentionPlateChangeNotification = @"AttentionPlateChange";//关注板块改变
NSString* const ZZChangeUserHeadImageNotification = @"ChangeUserHeadImage";//用户改变头像
NSString*  const   ZZStorePostChangeNotification = @"StorePostChange";//收藏改变
CGFloat  const  upDownSpace  =5;
CGFloat  const  ZZTabBarHeight = 49;//tabbar高度
CGFloat  const  ZZNaviHeight = 64;//tabbar高度
CGFloat  const  ZZLineSpace = 4;//行间距
CGFloat  const  ZZCharSpace = 1;//字间距
CGFloat  const  ZZParagraphSpace = 3;//段间距
CGFloat  const  ZZReplyLineSpace = 1;//行间距
CGFloat  const  ZZLRmargin = 10 ;//距离屏幕左右间距
NSUInteger  const  ZZMiMaMinLenth = 6 ;//密码最少位数
NSUInteger  const  ZZMiMaMaxLenth  = 12;//密码最多位数
NSUInteger  const  ZZNickMaxLenth  = 14;//密码最多位数
CGFloat  const  ZZNetDely = 1.0 ;//网络请求延迟时间