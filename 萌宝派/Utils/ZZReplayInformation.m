//
//  ZZReplayInformation.m
//  萌宝派
//
//  Created by charles on 14-11-26.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZReplayInformation.h"

@implementation ZZReplayInformation
-(void)setReplayContent:(NSString *)replayContent{
    _replayContent = [replayContent  copy];
         self.attributedContent = [replayContent  getReplyAttributedStringFont:ZZTitleFont color:ZZLightGrayColor];
    
}

-(void)setRelReplayPost:(ZZReplayInformation *)relReplayPost{
    _relReplayPost = relReplayPost;
    self.relReplayPost.attributedContent = [self.relReplayPost.replayContent  getReplyAttributedStringFont:ZZContentFont color:ZZLightGrayColor];
}
-(void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    if (isDelete) {
        self.replayContent = @"此回复已删除";
        self.imageInfo = nil;
    }
}
@end
