//
//  ZZRongUserInfo.h
//  萌宝派
//
//  Created by zhizhen on 15/5/27.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
@interface ZZRongUserInfo : NSObject
+(void)uploadUserInfoWithUserId:(NSString*)userid  andNick:(NSString*)nick  andImageurl:(NSString*)imageurl;
+(BOOL)addBabyRecord:(RCUserInfo*)rongUserInfo;
+(BOOL)updateBabyRecord:(RCUserInfo*)rongUserInfo;

//根据pushid
+(BOOL)selectDataWithMessagePushId:(NSString*)userId;
+(RCUserInfo*)readuserInfoWithPushid:(NSString*)userId;
@end
