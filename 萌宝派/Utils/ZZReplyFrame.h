//
//  ZZReplyFrame.h
//  萌宝派
//
//  Created by zhizhen on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZReplayInformation.h"

@interface ZZReplyFrame : NSObject
@property (nonatomic, assign)CGRect whiteBackViewF;
@property (nonatomic, assign)CGRect floorLabelF;
@property (nonatomic, assign)CGRect headIVF;
@property (nonatomic, assign)CGRect nickLabelF;
@property (nonatomic, assign)CGRect permissLabelF;
@property (nonatomic, assign)CGRect timeButtonF;
@property (nonatomic, assign)CGRect contentLabelF;
@property (nonatomic, assign)CGRect contentIVF;
@property (nonatomic, assign)CGRect replyButtonF;
@property (nonatomic, assign)CGRect reportButtonF;
@property (nonatomic, assign)CGRect deleteButtonF;
@property (nonatomic, strong)ZZReplayInformation *reply;

@property (nonatomic, assign)CGRect replyViewF;
@property (nonatomic, assign)CGRect replyFloorLabelF;
@property (nonatomic, assign)CGRect replyHeadIVF;
@property (nonatomic, assign)CGRect replyNickLabelF;
@property (nonatomic, assign)CGRect replyContentLabelF;

@property (nonatomic) CGFloat  cellHeight;

/**
 *  将ZZReply模型转为ZZReplyFrame模型
 */
+ (NSArray *)replyFramesWithReplys:(NSArray *)replys;

@end
