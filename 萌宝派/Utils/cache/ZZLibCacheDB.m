//
//  ZZLibCacheDB.m
//  萌宝派
//
//  Created by zhizhen on 15/6/25.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLibCacheDB.h"
#import "FMDB.h"
#import "ZZLoginSatus.h"
static FMDatabase *_db;
@implementation ZZLibCacheDB
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LibCache.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    
    [_db open];
 
    _db.userVersion = 1;
    //  CREATE TABLE IF NOT EXISTS SYSTEMMESSAGE(sMessageId INTEGER PRIMARY KEY AUTOINCREMENT,sMessageTitle  TEXT, sMessageContent TEXT, sMessageDate TEXT,sMessageFlag INTEGER,sMessagePushId INTEGER
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_libCache (id INTEGER PRIMARY KEY, libName  TEXT NOT NULL , libToken TEXT NOT NULL , libData TEXT NOT NULL );"];
}
+(BOOL)updateOrAddCacheData:(NSDictionary*)cache  libName:(NSString*)libName{
    BOOL  backBool = 0;
    if ([self  whetherExistWithLibName:libName]) {
         [self  updateCacheData:cache libName:libName];
    
    }else{
           [self addCacheData:cache libName:libName];
    }
    return backBool;
}
+(BOOL)whetherExistWithLibName:(NSString*)libName{
    return  [_db boolForQuery:[NSString   stringWithFormat:@"SELECT COUNT(*) FROM t_libCache WHERE libName = '%@'  and libToken = '%@';",libName,[ZZLoginSatus  sharedZZLoginSatus].token] ];
}
+(NSDictionary*)selectHomeNetDataWithLibName:(NSString*)libName{
    FMResultSet *set =  [_db executeQueryWithFormat:@"SELECT * FROM t_libCache  WHERE libName = %@ and libToken = %@;",libName,[ZZLoginSatus  sharedZZLoginSatus].token];

    // 不断往下取数据
    NSDictionary*  backDic ;
    while (set.next) {
        NSData *statusData = [set objectForColumnName:@"libData"];
       backDic = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
       // userInfo = [[RCUserInfo  alloc]initWithUserId:[set stringForColumn:@"userId"] name:[set stringForColumn:@"name"] portrait:[set stringForColumn:@"portraitUri"]];
        
    }
    return backDic;
}
#pragma mark private methods
//添加
+(BOOL)addCacheData:(NSDictionary*)cache  libName:(NSString*)libName{
      NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:cache];
    BOOL backBool =   [_db executeUpdateWithFormat:@"INSERT INTO t_libCache(libName,libToken,libData) VALUES (%@,%@,%@);",libName,[ZZLoginSatus  sharedZZLoginSatus].token,statusData];
    
    return backBool;
}
//更新
+(BOOL)updateCacheData:(NSDictionary*)cache  libName:(NSString*)libName{
     NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:cache];
    BOOL  backBool =   [_db executeUpdateWithFormat:@"UPDATE   t_libCache  SET libData = %@ WHERE libToken = %@ and libName = %@;",statusData,[ZZLoginSatus  sharedZZLoginSatus].token, libName];
    return backBool;
}


@end
