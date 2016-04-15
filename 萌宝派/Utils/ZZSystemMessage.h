//
//  ZZSystemMessage.h
//  萌宝派
//
//  Created by zhizhen on 15/4/14.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZSystemMessage : NSObject
@property(nonatomic)NSUInteger  sMessageId;
@property(nonatomic,strong)NSString*  sMessageContent;
@property(nonatomic,strong)NSString*  sMessageDate;
@property(nonatomic)NSUInteger  sMessageFlag;
@property(nonatomic)NSUInteger  sMessagePushId;
@end
