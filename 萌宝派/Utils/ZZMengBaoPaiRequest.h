//
//  ZZMengBaoPaiRequest.h
//  萌宝派
//
//  Created by zhizhen on 14-11-12.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//
//网络请求
#import <Foundation/Foundation.h>
@class ZZBabyRecordInfo;
@class ZZLeaveWordPost;
@class ZZUser;
@class ZZTopicInformation;
#import "ZZReplayInformation.h"
#import "ZZPlateTypeInfo.h"
#import "ZZExpert.h"
typedef void (^CallBack)(id obj);


@interface ZZMengBaoPaiRequest : NSObject
+(ZZMengBaoPaiRequest*)shareMengBaoPaiRequest;
@property(nonatomic,strong)NSString*  baseUrl;
@property(nonatomic,strong)NSString*  token;
-(void)networkActivityIndicator;
#pragma mark ---------------------注册登录----------------------
#pragma mark 验证手机号是否注册过-----
-(void)postValidPhoneIsResignWithPhoneNumber:(NSString*)number andBack:(CallBack)callback;  //new
#pragma mark 获取验证码
-(void)postSecurityWithPhoneNumber:(NSString*)number andBack:(CallBack)callback;
#pragma mark 忘记密码
//忘记密码 获取验证码后提交
-(void)postValidSecurityWithRegisterPhone:(NSString*)phoneNumber andSecurity:(NSString*)security andBack:(CallBack)callback;
#pragma mark 更新密码
//忘记密码  更新密码
-(void)postUpdatePWDWithRegisterPhone:(NSString*)phoneNumber  andNewPassword:(NSString*)password  andBack:(CallBack)callback;
#pragma mark 手机号注册-----
-(void)postAddUserWithPhoneNumber:(NSString*)number   andPassword:(NSString*)password  andSecurity:(NSString*)security  andNick:(NSString*)nick  andBack:(CallBack)callback;  //new

#pragma mark 手机号登录-----
-(void)postLoginUserWithPhoneNumber:(NSString*)number   andPassword:(NSString*)password  andToken:(NSString*)token andBack:(CallBack)callback;  //new

#pragma mark 选择用户状态-----
-(void)postAddIndentityWtihInt:(NSUInteger)index andBack:(CallBack)callback;  //new

#pragma mark 三方注册登录－－－－－－－
-(void)postAddUserByThirdWithUserOpenId:(NSString*)userOpenId    andNick:(NSString*)nick   andBack:(CallBack)callback;  //new
#pragma mark ---------------------个人----------------------
#pragma mark 查询登录用户信息－－－－－－－
-(void)postQueryUserInfoWithTokenAndBack:(CallBack)callback;

#pragma mark 更新个人信息
-(void)postUpdateUserinfoWithNick:(NSString*)nick  andStatus:(NSInteger)status  andImage:(UIImage*)image  andBack:(CallBack)callback;
#pragma mark ---------------------通用方法----------------------
#pragma mark  按区域查询所有板块
-(void)postFindALLPlatesByAreaType:(NSString*)area  andBack:(CallBack)callback;

#pragma mark 添加或删除关注，人或板块
-(void)postUpdateAttentionUserOrPlateWithCode:(NSString*)code   andPlatedId:(NSUInteger)plateId  andUserId:(NSUInteger)userId  andAddOrDelete:(BOOL)yesOrNo  andCallback:(CallBack)callback;

#pragma mark   添加 或删除 收藏
-(void)postUpdateStoreUpPostWithPostId:(NSUInteger)postId  andPlateType:(ZZPlateTypeInfo*)plateType andAddOrDelete:(BOOL)yesOrNo    andBack:(CallBack)callback;

#pragma mark  所有板块点赞或取消点赞
-(void)postUpdateSpotPostWithPlate:(ZZPlateTypeInfo*)plate  andPostId:(NSUInteger)postId andAddOrDelete:(BOOL)yesOrNo andBack:(CallBack)callback;
#pragma mark  帖子或回复举报
-(void)postReportPostOrPostReplyWithPlate:(ZZPlateTypeInfo*)plate  andPostId:(NSUInteger)postId  andReply:(NSUInteger)replyId  andBack:(CallBack)callback;
//#pragma mark ---------------------精彩专区----------------------
//
//#pragma mark   精彩专区添加帖子
//-(void)postAddNewWonderfulPostWithPlate:(ZZPlateTypeInfo*)plate  andTitle:(NSString*)title andImageArray:(NSArray*)imageArray andBack:(CallBack)callback;
//
//#pragma mark   精彩专区查询帖子列表
//-(void)postFindWonderFulPostWithPlate:(ZZPlateTypeInfo*)plate andPostId:(NSInteger)postId  andUpDown:(NSUInteger)upDown  andBack:(CallBack)callback;
//
//#pragma mark   精彩专区查询帖子详情
//-(void)postFindWonderFulPostDetialInfoWithPlate:(ZZPlateTypeInfo*)plate andPostId:(NSUInteger)postId  andUserId:(NSUInteger)userId  andBack:(CallBack)callback;
//#pragma mark  精彩删帖
//-(void)postDeleteWonderFulrConstellationPostWithPlate:(ZZPlateTypeInfo*)plate PostId:(NSUInteger)postId  andBack:(CallBack)callback;


#pragma mark ---------------------宝宝----------------------
#pragma mark   添加宝宝，或者更新宝宝信息
-(void)postAddBabyOrUpdateBabyInfoWithImage:(UIImage*)image  andBirthday:(NSString*)birthday  andNick:(NSString*)nick  andSex:(NSInteger)sex  andBabyId:(NSUInteger)babyId  andback:(CallBack)callback;

#pragma mark   删除宝宝
-(void)postDeleteBabyWithBabyId:(NSUInteger)babyId  andBack:(CallBack)callback;

#pragma mark   查找宝宝详情
-(void)postFindBabyDetailInfoWithBabyId:(NSUInteger)babyId   andBack:(CallBack)callback;

#pragma mark   查询宝宝板块信息
-(void)postFindBabyPlateInfoAndBack:(CallBack)callback;

#pragma mark   添加宝宝日志
-(void)postAddBabyGrowingLogWithBabyId:(NSUInteger)babyId   andImageArray:(NSArray*)images  andBack:(CallBack)callback;

#pragma mark  删除宝宝日志
-(void)postDeleteBabyGrowingLogWithBabyId:(NSUInteger)babyId  andDiaryId:(NSUInteger)diaryId  andBack:(CallBack)callback;

#pragma mark  宝宝成长日志列表
-(void)postFindBabyGrowingLogListWithBabyId:(NSUInteger)babyId  andDiaryId:(NSUInteger)diaryId  andUpDown:(NSUInteger)upDown  andBack:(CallBack)callback;

#pragma mark ---------------------同龄----------------------
#pragma  mark 同龄板块按类型查找竖版
-(void)postFindStarConstellationPostListsWithPlate:(ZZPlateTypeInfo*)plate andPostId:(NSInteger)postId  andUpDown:(NSUInteger)upDown  andBack:(CallBack)callback;

#pragma mark   同龄板块添加帖子
-(void)postAddNewStarPostWithPlate:(ZZPlateTypeInfo*)plate  andTitle:(NSString*)title  andContent:(NSString*)content   andImageArray:(NSArray*)imageArray andBack:(CallBack)callback;

#pragma mark   查询帖子详情
-(void)postFindStarConstellationPostDetialInfoWithPlate:(ZZPlateTypeInfo*)plate     andPostId:(NSUInteger)postId  andUserId:(NSUInteger)userId  andBack:(CallBack)callback;

#pragma mark   添加回复
-(void)postAddStarConstellationPostReplyWithPlate:(ZZPlateTypeInfo* )plate  andPostId:(NSUInteger)postId  andReply:(ZZReplayInformation*)parentReply  andContent:(NSString*)content  andImage:(UIImage*)image andSort:(NSUInteger)sort   andBack:(CallBack)callback;

#pragma mark 查询回复
-(void)postFindStarConstellationPostReplyWithPlate:(ZZPlateTypeInfo*)plate  andPostId:(NSUInteger)postId  andUpdown:(NSUInteger)upDown  andReplyId:(NSUInteger)replyId  andSort:(NSUInteger)sort andBack:(CallBack)callback ;

#pragma mark   删除回复
-(void)postDeleteStarConstellationPostReplyWithPlate:(ZZPlateTypeInfo*)plate   andReplyId:(NSUInteger)replyId  andBack:(CallBack)callback;

#pragma mark  删除帖子
-(void)postDeleteStarConstellationPostWithPlate:(ZZPlateTypeInfo*)plate    PostId:(NSUInteger)postId  andBack:(CallBack)callback;
/*
#pragma mark  关注人发布列表
-(void)postFindAttentionUserPublishListWithUserId:(NSUInteger)userId andBack:(CallBack)callback;
*/
#pragma mark  -----------------------关注、收藏----------------------
#pragma mark 这个用户是否关注
- (void)postFindThisUserAttention:(NSUInteger)userId andBack:(CallBack)callback;
#pragma mark   关注人发布更多
-(void)postFindAttentionUserMorePublishListWithUserId:(NSUInteger)userId andPostId:(NSUInteger)postId andUpDOwn:(NSUInteger)upDown andTypeNumber:(NSUInteger)typeNumber andBack:(CallBack)callback;

#pragma mark   我的收藏
-(void)postFindMyStorePostTithPostId:(NSUInteger)postId  andUpDown:(int)upDown andTypeNumber:(NSUInteger)typeNumber andBack:(CallBack)callback;

#pragma mark  我的关注
-(void)postFindMyAttentionByUserId:(NSUInteger)userId  andUpDown:(int)upDown  andBack:(CallBack)callback;

#pragma mark  -----------------------专家 达人----------------------
#pragma mark 专家(名医)
-(void)postFindExpertByUserId:(NSInteger)userId andUpDown:(int)upDown andType:(int)type andCity:(int)city andBack:(CallBack)callBack;
#pragma mark 已关注和推荐专家达人列表
-(void)postFindRecommendExpertByUserId:(NSInteger)userId andRecommend:(int)recommend andUpDown:(int)upDown andCity:(int)city andBack:(CallBack)callBack;
//#pragma mark ---------------------专家id查询专家信息----------------------
//-(void)postFindExpertInformationByuserId:(NSInteger)userId andBack:(CallBack)callBack;

#pragma mark 专家行程
-(void)postExpertJourneyByuserId:(NSInteger)userId andBack:(CallBack)callBack;

#pragma mark 更新专家是否在线
-(void)postExpertOnLineByUserId:(NSInteger)userId andOnLine:(int)online andBack:(CallBack)callBack;
#pragma mark 达人类型
-(void)postFindSuperStarTypeByType:(int)type andBack:(CallBack)callBack;
#pragma mark 关注和推荐达人用户
-(void)postFindEreDarAttentionByRecommend:(int)recommend andUserId:(NSInteger)userId andUpDown:(int)upDown andBack:(CallBack)callBack;
#pragma mark 按类型查达人
-(void)postFindSuperStarByType:(int)type anduserId:(NSInteger)userId andUpDown:(int)upDown andBack:(CallBack)callBack;

#pragma mark 达人申请
-(void)postFindSuperStarByType:(int)type andContext:(NSString*)context andPhone:(NSString*)phone andWeiXin:(NSString*)weixin andQq:(NSString*)qq andBack:(CallBack)callBack;
#pragma mark -------------------搜索---------------------
#pragma mark 搜索
-(void)postSearchByType:(int)type andSearchContent:(NSString*)str  andId:(NSUInteger)searchId  andUpDown:(int)upDown  andBack:(CallBack)callback;
#pragma mark -------------------案例---------------------
#pragma mark 案例列表
-(void)postFindCaseByCaseId:(NSInteger)caseId  andPlateType:(ZZPlateTypeInfo*)plateType andUpDown:(int)upDown andBack:(CallBack)callBack;
#pragma mark 案例类型
-(void)postFindCaseTypeBack:(CallBack)callBack;
#pragma mark --------------------其他--------------------
#pragma mark 金币纪录
-(void)postFindGoldListWithId:(NSUInteger)goldRecordId  andUpDown:(int)upDown  andBack:(CallBack)callback;
#pragma mark 消息
-(void)postFindMessageByMessageId:(NSInteger)messageId andUpDown:(int)upDown  andBack:(CallBack)callback;
#pragma mark 反馈
//提交意见
-(void)postAddFeedBackAndContent:(NSString*)content   andBack:(CallBack)callback;
#pragma mark 注销
//yes  为注销
-(void)postLoginOutAndEnterBackGround:(BOOL)enterBack     AndBack:(CallBack)callback;

#pragma mark  版本号
-(void)postFindVersionAndBack:(CallBack)callback;
#pragma mark  在线专家和小编
-(void)postfindOnLineAndCallBack:(CallBack)callback;
#pragma mark --------------------首页--------------------
#pragma mark 广场
-(void)postFindHomePageAndCallBack:(CallBack)callback;
#pragma mark  关注
-(void)postFindHomePageAttentionLastId:(NSUInteger)lastId andUpDown:(NSInteger)upDown  CallBack:(CallBack)callback;

#pragma mark  根据token获取用户昵称头像
-(void)postFindUserNickWithToken:(NSString*)uToken   andCallBack:(CallBack)callback;
@end
