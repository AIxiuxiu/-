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
+(BOOL)addRongUserInfo:(RCUserInfo*)rongUserInfo;
+(BOOL)updateRongUserInfo:(RCUserInfo*)rongUserInfo;

//根据pushid
+(BOOL)selectDataWithRongUserInfoUserId:(NSString*)userId;
+(RCUserInfo*)readuserInfoWithPushid:(NSString*)userId;
@end
