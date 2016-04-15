//
//  ZZMessage.h
//  聪宝汇
//
//  Created by zhizhen on 14-8-20.
//  Copyright (c) 2014年 zhizhen. All rights reserved.
//
//消息类型
#import <Foundation/Foundation.h>
#import "ZZReplayInformation.h"
#import "ZZPost.h"


@interface ZZMessage : NSObject

@property(nonatomic)NSUInteger  messageId;     //messageId
@property(nonatomic,strong)ZZPost* postInfo;//帖子
@property(nonatomic,strong)ZZReplayInformation* replayInfo;//回复人的信息


@end
