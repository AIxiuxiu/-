//
//  ZZReplayInformation.h
//  萌宝派
//
//  Created by charles on 14-11-26.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"
#import "ZZMengBaoPaiImageInfo.h"
@interface ZZReplayInformation : NSObject

@property(nonatomic)NSUInteger  replayId;   //回复的id
@property(nonatomic,strong)ZZReplayInformation*   relReplayPost;//回复的回复
@property(nonatomic,strong)ZZMengBaoPaiImageInfo* imageInfo;//回复的图片
@property(nonatomic)NSUInteger  replays;

@property(nonatomic,strong)ZZUser*  user;//  用户  回复者
@property(nonatomic)NSUInteger  replayPostType;//回复帖子的类型
@property(nonatomic)NSUInteger  replayPostId;//回复帖子id
@property(nonatomic,strong)NSString* replayContent;//回复人的内容
@property(nonatomic,strong)NSString* replayTime;//回复的时间
@property(nonatomic)BOOL  isCurrentUser;
@property(nonatomic)BOOL  isDelete;
@property(nonatomic)NSUInteger  floor;


@property (nonatomic, strong)NSAttributedString *attributedContent;
@end
