//
//  ZZJsonParse.h
//  萌宝派
//
//  Created by zhizhen on 14-10-23.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//
//解析
#import <Foundation/Foundation.h>

#import "ZZUser.h"
#import "ZZBaby.h"
#import "ZZReplayInformation.h"
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZExpert.h"
#import "ZZMessage.h"
#import "ZZPlateTypeInfo.h"
#import "ZZPost.h"
#import "ZZBabyDiaryInfo.h"
#import "ZZGoldRecord.h"

#import "ZZMessage.h"

@interface ZZJsonParse : NSObject
+(NSString*)stringReplacOfString:(NSString*)str;
#pragma  mark -----------板块详情
+(ZZPlateTypeInfo*)parsePlateTypeInfoByDic:(NSDictionary*)dic;
#pragma  mark -----------登录用户信息
+(void)parseLoginUserInfoByDic:(NSDictionary*)dic;
#pragma  mark -----------更新登录用户信息
+(void)parseUpdateLoginUserInfoByDic:(NSDictionary*)dic;
#pragma mark 同龄同城竖版解析方法
+(ZZPost*)parseSameAgeVerticalVersionPostInfoByDic:(NSDictionary*)dic;
//#pragma mark 精彩竖版解析方法
//+(ZZPost *)parseWonderFulPostInfoByDic:(NSDictionary *)dic;
#pragma mark 回复解析
+(ZZReplayInformation*)parseSameAgePostReplyInfoByDic:(NSDictionary*)dic;
#pragma mark 宝宝基本信息
+(ZZBaby*)parseBabyInfoByDic:(NSDictionary*)dic;
#pragma mark 宝宝日志信息
+(ZZBabyDiaryInfo*)parseBabyDiaryByDic:(NSDictionary*)dic;
#pragma mark  关注用户
+(ZZUser*)parseAttentionUserByDic:(NSDictionary*)dic;
#pragma mark  专家列表
+(ZZExpert*)parseExpertListByDic:(NSDictionary*)dic;
#pragma mark  案例类型
+(ZZPlateTypeInfo*)parseCaseTypeByDic:(NSDictionary*)dic;
//+(ZZCase*)parseCaseTypeByDic:(NSDictionary*)dic;
#pragma mark  案例列表
+(ZZPost*)parseCaseListByDic:(NSDictionary*)dic;
#pragma mark  达人和专家的类型
+(ZZPlateTypeInfo*)parseSuperStarAndExpertTypeByDic:(NSDictionary*)dic;
#pragma mark  按类型查达人
+(ZZUser*)parseSuperStarListByDic:(NSDictionary*)dic;
#pragma mark  金币解析
+(ZZGoldRecord*)parseGoldListByDic:(NSDictionary*)dic;
#pragma mark  消息解析
+(ZZMessage*)parseMessageListByDic:(NSDictionary*)dic;
#pragma mark   广告图片解析
+(ZZPost*)parseImageInfoByDic:(NSDictionary*)dic;

#pragma mark   在线专家
+(ZZExpert*)parseOnLineExpetByDic:(NSDictionary*)dic;
#pragma mark   解析code为0时
+(NSString*)parseNetGetFailInfoByDic:(NSDictionary*)dic;
#pragma mark   用户头像昵称
+(ZZUser*)parseUserNickAndImageUrlByDic:(NSDictionary*)dic;
/*
#pragma mark 宝宝
//宝宝记录基本信息
+(ZZBabyRecordInfo*)parseBabyRecordInfoByDic:(NSDictionary*)dic;

//用户基本信息
#pragma mark 用户
+(ZZUser*)parseUserInfoByDic:(NSDictionary*)dic;
//登录用户信息  个人、宝宝、宝宝记录
+(ZZUser*)parseLoginUserinfoByDic:(NSDictionary*)dic;
#pragma mark 营养百汇
//营养百汇基本信息
+(ZZTopicInformation*)parseNutritionInfoByDic:(NSDictionary*)dic;
//营养百汇回复基本信息
+(ZZReplayInformation*)parseNutritionReplyByDic:(NSDictionary*)dic;
#pragma mark 互助
//互助贴基本回复
+(ZZTopicInformation*)parseHelpEachInfoByDic:(NSDictionary*)dic;
//互助贴基本回复
+(ZZReplayInformation*)parseHelpEachReplyByDic:(NSDictionary*)dic;
#pragma mark 回复基本
//回复信息
+(ZZReplayInformation*)parseReplayInfoByDic:(NSDictionary*)dic;
//回复详情
+(ZZReplayInformation*)parseReplayDetailInfoByDic:(NSArray*)array;

#pragma mark 酒店
//酒店基本信息
+(ZZHotelInformation*)parseHotelPostByDic:(NSDictionary*)dic;
//酒店信息，酒店基本信息、该酒店回复信息
+(ZZHotelInformation*)parseHotelPostDetailInfoByDic:(NSDictionary*)dic;
#pragma mark 话题
//话题基本信息
+(ZZTopicInformation*)parseTpoicRoomPostByDic:(NSDictionary*)dic;
//话题回复基本信息
+(ZZReplayInformation*)parseTopicReplyDetailByDic:(NSDictionary*)dic;
#pragma mark 游记
//发布基本信息
+(ZZTravelInformation* )parsePublishInfoByDic:(NSDictionary*)dic;
//发布回复详细信息
+(ZZReplayInformation*)parsePulishReplayDetailInfoByDic:(NSArray *)array;
//发布回复信息，现在采用的
+(ZZTravelInformation*)parsePublishPostDetailInfoByDic:(NSDictionary*)dic;
#pragma mark 活动
//活动基本信息
+(ZZGameInformation*)parseActivityInfoByDic:(NSDictionary*)dic;
//
//活动回复信息
+(ZZReplayInformation*)parseActivityReplyInfoByDic:(NSDictionary*)dic;
#pragma mark 相册
//相册
+(NSArray*)parseImagePathArrayWithType:(int)type ByArray:(NSArray*)array ;
//根据类型解析图片
+(ZZMengBaoPaiImageInfo*)parseImagePathWithType:(int)type  ByDic:(NSDictionary*)dic;
#pragma mark 签到
//签到信息
+(ZZMood*)parseMoodInfoByDic:(NSDictionary*)dic;
//积分记录
+(ZZRecord*)parseRecordInfoByDic:(NSDictionary*)dic;
#pragma mark 留言板
//专家信息
+(ZZExpert*)parseExpertInfoByDic:(NSDictionary*)dic;
//留言信息
+(ZZLeaveWordPost*)parseLeaveWordPostInfoByDic:(NSDictionary*)dic;
//留言回复
+(ZZReplayInformation*)parseLeaveWordReplyInfoByDic:(NSDictionary*)dic;


#pragma mark 消息
//消息信息
+(ZZMessage*)parseMessageInfoByDic:(NSDictionary*)dic;
//+(ZZMessage*)parseEveryDayMsgListByDic:(NSDictionary*)dic;
//消息中查询活动详情信息
+(ZZGameInformation*)parseActivityInfoFromMessageByDic:(NSDictionary*)dic;
//消息中查询留言详情信息
+(ZZLeaveWordPost*)parseLeaveWordInfoFromMessageByDic:(NSDictionary*)dic;
 */
@end
