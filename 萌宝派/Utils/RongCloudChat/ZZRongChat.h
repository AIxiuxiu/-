//
//  ZZRongChat.h
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <RongIMKit/RongIMKit.h>

typedef void (^RongChatCallBack)(id obj);
@interface ZZRongChat : NSObject
@property(nonatomic,assign)BOOL  rongConnetSuccess;
/**
 单例
 */
singleton_interface(ZZRongChat);

/**
 获取设备的deviceToken  用于推送
 @param deviceToken 用于 Apple Push Notification Service 的设备唯一标识。
 */
-(void)rongChatGetDeviceToken:(NSData *)deviceToken ;


/**
 初始化融云SDK

 */
-(void)rongChatInit;


/**
 连接融云服务器
 @param token 用户在融云账户的token  调用有结果时有返回值
 */
-(void)rongChatConnectServerWithToken:(NSString*)token    andCallback:(RongChatCallBack)rongBack;

/*
 断开融云服务器
 */
-(void)rongChatDisConnectServer;

/**
 得到回话列表
 根据类型
 */
-(NSArray*)rongGetConversationListWithSelfConversation;

/**
 得到相应会话列表的未读消息数
 */
-(int)rongGetUnreadMessageCountWithSelfConversation;

/**
 根据targetid清楚未读消息状态
 */
-(void)rongClearMessagesUnreadStatus:(RCConversationType)conversationType andTargetId:(NSString *)targetId;

/**
 *  得到相应用户
 *
 *  @param userId token
 *
 *  @return <#return value description#>
 */
-(RCUserInfo *)getZZUserInfoWithUserId:(NSString *)userId;

/**
 *  容云聊天信息数量改变的通知
 */
-(void)rongMessageCountChangeNoti;
@end
