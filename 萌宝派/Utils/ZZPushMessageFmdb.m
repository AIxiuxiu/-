//
//  ZZPushMessageFmdb.m
//  萌宝派
//
//  Created by 张亮亮 on 15/4/19.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZPushMessageFmdb.h"
#import "FMDB.h"

static FMDatabase *_db;
@implementation ZZPushMessageFmdb
+ (void)initialize
{
     NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSArray *extensions = @[@"babyName.sqlite",@"babyRecord.sqlite",@"sysMessage.sqlite"];
      NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *extension in extensions) {
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:extension] error:NULL];
    }
  
    NSString *path = [documentsDirectory  stringByAppendingPathComponent:@"pushMessage.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
  //  CREATE TABLE IF NOT EXISTS SYSTEMMESSAGE(sMessageId INTEGER PRIMARY KEY AUTOINCREMENT,sMessageTitle  TEXT, sMessageContent TEXT, sMessageDate TEXT,sMessageFlag INTEGER,sMessagePushId INTEGER
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_sysMessage (id INTEGER PRIMARY KEY , sMessageContent  TEXT, sMessageDate TEXT ,sMessageFlag INTEGER ,sMessagePushId INTEGER );"];
}
+(NSArray*)sysMessagesWithMessageId:(NSInteger)messageId{
    // 得到结果集
    //FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_babyRecord ORDER BY id DESC LIMIT  ;"];
    FMResultSet *set = nil;
    if (messageId) {
        set =  [_db executeQueryWithFormat:@"SELECT * FROM t_sysMessage  WHERE id < %ld  ORDER BY id DESC LIMIT 0,10 ;",messageId];
    }else{
        set = [_db executeQueryWithFormat:@"SELECT * FROM t_sysMessage  ORDER BY id DESC LIMIT 0,10 ;"];
    }

    // 不断往下取数据
   
    NSMutableArray *sysMessages = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        ZZSystemMessage *sysMessage = [[ZZSystemMessage alloc] init];
        sysMessage.sMessageId = [set longForColumn:@"id"];;

     sysMessage.sMessageContent =  [set stringForColumn:@"sMessageContent"];
        sysMessage.sMessageDate =  [set stringForColumn:@"sMessageDate"];
      sysMessage.sMessageFlag =  [set longForColumn:@"sMessageFlag"];
        sysMessage.sMessagePushId =  [set longForColumn:@"sMessagePushId"];
       
        [sysMessages addObject:sysMessage];
        
    }
    return sysMessages;
}
+(BOOL)addBabyRecord:(ZZSystemMessage*)sysMessage{
    return   [_db executeUpdateWithFormat:@"INSERT INTO t_sysMessage(sMessageContent,sMessageDate,sMessageFlag,sMessagePushId) VALUES (%@,%@,%ld,%ld);",sysMessage.sMessageContent,sysMessage.sMessageDate,sysMessage.sMessageFlag,sysMessage.sMessagePushId];
}
+(BOOL)updateBabyRecord:(ZZSystemMessage*)sysMessage{
    return   [_db executeUpdateWithFormat:@"UPDATE   t_sysMessage  SET sMessageFlag = %d WHERE id = %ld;",0,sysMessage.sMessageId];
}

+(BOOL)deleteTable{
    return  [_db  executeUpdate:@"DROP TABLE IF  EXISTS t_sysMessage"];
}
+(NSUInteger)selectDataWithFlag:(NSUInteger) flag{
    //select count ( * ) from t_student where score >= 60
    
    NSUInteger count = [_db intForQuery:@"SELECT COUNT(*) FROM t_sysMessage WHERE sMessageFlag = 1;"];

    return count;
}
+(BOOL)selectDataWithMessagePushId:(NSUInteger)pushId{
    NSUInteger count = [_db boolForQuery:[NSString   stringWithFormat:@"SELECT COUNT(*) FROM t_sysMessage WHERE sMessagePushId = '%ld';",pushId] ];
    return count;
}
@end
