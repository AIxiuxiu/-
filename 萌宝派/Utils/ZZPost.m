//
//  ZZPost.m
//  萌宝派
//
//  Created by zhizhen on 15-3-23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZPost.h"

@implementation ZZPost
-(instancetype)initWithId:(NSUInteger)postId
                 andTitle:(NSString*)postTitle
               andContent:(NSString*)postContent
           andImagesArray:(NSArray*)postImagesArray
               andDateStr:(NSString*)postDateStr
                  andUser:(ZZUser*)postUser
            andReplyCount:(NSUInteger)postReplyCount
             andPlateType:(ZZPlateTypeInfo*)postPlateType
                 andJudge:(BOOL)postJudge
               andStoreUp:(BOOL)postStoreUp{
    self = [super  init];
    if (self) {
        self.postId = postId;
        self.postTitle = postTitle;
        self.postContent = postContent;
        self.postImagesArray = postImagesArray;
        self.postDateStr = postDateStr;
        self.postUser = postUser;
        self.postReplyCount = postReplyCount;
        self.postPlateType = postPlateType;
        self.postJudge = postJudge;
        self.postStoreUp = postStoreUp;
    }
    
    return self;
}

+(NSArray*)postStickArray{
    ZZPost* post = [[ZZPost alloc]init];
    post.postTitle = @"iouhjkkjhkjljjl";
    return @[post];
}

+(NSArray*)postOthers{
    ZZPost* post= [[ZZPost  alloc]init];
    post.postTitle = @"iujjilkjkl";
    post.postContent = @"uiersanhykkkl";
    post.postDateStr = @"02-22 16:17";
    post.postReplyCount = 100;
    ZZUser*  user = [[ZZUser  alloc]init];
    user.nick = @"nick";
    
    post.postUser = user;
    return @[post];
}
@end
