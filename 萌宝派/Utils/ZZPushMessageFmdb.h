//
//  ZZPushMessageFmdb.h
//  萌宝派
//
//  Created by 张亮亮 on 15/4/19.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSystemMessage.h"
@interface ZZPushMessageFmdb : NSObject
+(NSArray*)sysMessagesWithMessageId:(NSInteger)messageId;
+(BOOL)addBabyRecord:(ZZSystemMessage*)sysMessage;
+(BOOL)updateBabyRecord:(ZZSystemMessage*)sysMessage;
+(BOOL)deleteTable;
+(NSUInteger)selectDataWithFlag:(NSUInteger) flag;
//根据pushid
+(BOOL)selectDataWithMessagePushId:(NSUInteger)pushId;
@end
