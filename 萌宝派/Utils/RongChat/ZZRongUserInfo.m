//
//  ZZRongUserInfo.m
//  萌宝派
//
//  Created by zhizhen on 15/5/27.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZRongUserInfo.h"
#import "FMDB.h"
static FMDatabase *_db;
@implementation ZZRongUserInfo
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"RongUserInfo.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    //  CREATE TABLE IF NOT EXISTS SYSTEMMESSAGE(sMessageId INTEGER PRIMARY KEY AUTOINCREMENT,sMessageTitle  TEXT, sMessageContent TEXT, sMessageDate TEXT,sMessageFlag INTEGER,sMessagePushId INTEGER
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_RongUserInfo (id INTEGER PRIMARY KEY, userId  TEXT , name TEXT , portraitUri TEXT);"];
}
+(void)uploadUserInfoWithUserId:(NSString*)userid  andNick:(NSString*)nick  andImageurl:(NSString*)imageurl{
    RCUserInfo*  userInfo = [[RCUserInfo  alloc]initWithUserId:userid name:nick portrait:imageurl];
    if ([self  selectDataWithMessagePushId:userid]) {
        [self  updateBabyRecord:userInfo];
    }else{
        [self  addBabyRecord:userInfo];
    }
}
+(BOOL)addBabyRecord:(RCUserInfo*)rongUserInfo{
        return   [_db executeUpdateWithFormat:@"INSERT INTO t_RongUserInfo(userId,name,portraitUri) VALUES (%@,%@,%@);",rongUserInfo.userId,rongUserInfo.name,rongUserInfo.portraitUri];
}
+(BOOL)updateBabyRecord:(RCUserInfo*)rongUserInfo{
        return   [_db executeUpdateWithFormat:@"UPDATE   t_RongUserInfo  SET name = %@,portraitUri=  %@ WHERE userId = %@;",rongUserInfo.name,rongUserInfo.portraitUri, rongUserInfo.userId];
}
//根据pushid
+(BOOL)selectDataWithMessagePushId:(NSString*)userId{
       return  [_db boolForQuery:[NSString   stringWithFormat:@"SELECT COUNT(*) FROM t_RongUserInfo WHERE userId = %@;",userId] ];
}
+(RCUserInfo*)readuserInfoWithPushid:(NSString*)userId{
    FMResultSet *set =  [_db executeQueryWithFormat:@"SELECT * FROM t_RongUserInfo  WHERE userId = %@;",userId];
   
    
    // 不断往下取数据
    
    RCUserInfo*  userInfo =nil;
    while (set.next) {
        userInfo = [[RCUserInfo  alloc]initWithUserId:[set stringForColumn:@"userId"] name:[set stringForColumn:@"name"] portrait:[set stringForColumn:@"portraitUri"]];

    }
    return userInfo;
}
@end
