//
//  ZZPost.h
//  萌宝派
//
//  Created by zhizhen on 15-3-23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"
#import "ZZPlateTypeInfo.h"
//#import "ZZCase.h"
@interface ZZPost : NSObject
@property(nonatomic)NSUInteger  postId;// 帖子id
@property(nonatomic,strong)NSString*  postTitle;// 帖子标题
@property(nonatomic,strong)NSString*   postContent;// 帖子内容
@property(nonatomic,strong)NSArray*  postImagesArray;// 帖子图片数组
@property(nonatomic,strong)NSString*  postDateStr;// 帖子发布时间
@property(nonatomic,strong)ZZUser*  postUser;// 帖子发布者
@property(nonatomic)NSUInteger   postReplyCount;// 帖子回复数
@property(nonatomic,strong)ZZPlateTypeInfo*  postPlateType;// 帖子所属板块类型
@property (nonatomic) BOOL  postOrderSort;  //帖子正序倒序，倒序为0，正序为1
/**
 * 点赞数 张亮亮   0513 增加
 */
@property(nonatomic)NSInteger  postSportCount;
/**
 *当前用户是否已经点赞  张亮亮   0513 增加
 */
@property(nonatomic)BOOL  postCurrentUserSpot;

//@property(nonatomic,strong)ZZCase*  postCaseType;//是案例时有这个属性与postPlateType只能有其一
@property(nonatomic)BOOL  postJudge; //置顶
@property(nonatomic)BOOL  postStoreUp;
-(instancetype)initWithId:(NSUInteger)postId
                 andTitle:(NSString*)postTitle
               andContent:(NSString*)postContent
           andImagesArray:(NSArray*)postImagesArray
               andDateStr:(NSString*)postDateStr
                  andUser:(ZZUser*)postUser
            andReplyCount:(NSUInteger)postReplyCount
             andPlateType:(ZZPlateTypeInfo*)postPlateType
                 andJudge:(BOOL)postJudge
               andStoreUp:(BOOL)postStoreUp;

@end
