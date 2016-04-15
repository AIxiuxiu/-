//
//  ZZUser.h
//  萌宝派
//
//  Created by zhizhen on 14-11-5.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//
//用户
#import <Foundation/Foundation.h>
#import "ZZMengBaoPaiImageInfo.h"
typedef NS_ENUM(NSInteger, ZZUserAccountTypeState){
    
    ZZUserAccountTypeStateOfficial = 1,   //官方注册登录
    
    ZZUserAccountTypeStateQQ = 2,         //三方qq登录
    
    ZZUserAccountTypeStateXinLang = 3     //三方新浪登录
} ;
@interface ZZUser : NSObject

//     服务器有的
@property(nonatomic)NSUInteger  userId;        //用户ID
@property(nonatomic,strong)NSString*  nick;       //用户昵称
@property(nonatomic,assign)NSUInteger   status;      //用户状态 1、备孕中，2、怀孕中，3、已出生

@property(nonatomic)NSUInteger  loginTime;//
@property(nonatomic)NSInteger   gold;//金币

@property(nonatomic,assign)NSInteger helpLevel;//等级
@property(nonatomic,assign)NSUInteger        permissions;         // 用户权限，3为普通用户，2为萌宝小编，1为管理员
@property(nonatomic,strong)ZZMengBaoPaiImageInfo*  mbpImageinfo;  //
@property(nonatomic)BOOL  attention;
@property(nonatomic)BOOL  isCurrentUser; //是不是当前登录用户

@property(nonatomic,copy)NSString*  uToken;
//达人的属性
@property(nonatomic)BOOL isSuperStarUser;//是否是达人
@property(nonatomic)int superStarType;//达人类型
@property(nonatomic)NSInteger superStarLv;//达人等级
@property(nonatomic,strong)NSString*  superStarName;//达人类型 汉字版

@property(nonatomic)NSUInteger   attentionCount;
@property(nonatomic)NSUInteger   publishCount;
@property(nonatomic)NSUInteger   storeCount;
-(instancetype)initWithId:(NSUInteger)userId
                  andNick:(NSString*)nick
             andLoginTime:(NSUInteger)loginTime
          andmbpImageInfo:(ZZMengBaoPaiImageInfo*)mbpImageinfo;


//客户端独有的
+(ZZUser*)shareSingleUser;
+(NSArray*)getIdentifyArray;


//注销用户时调用，所有的属性为空
+(void)cleanUserValue;
-(NSString*)getUserIdentifyByIden:(NSUInteger)iden;

-(CGFloat)getIntergrLevelWithLoginTime:(NSUInteger)time  andHelpLevel:(NSUInteger)helpLevel;
//大图标
-(NSString*)getBigLevelImagePathWithLoginTime:(NSInteger)loginTime;
//小图标
-(NSString*)getSmallLevelImagePathWithLoginTime:(NSInteger)loginTime;
//达人等级
-(NSString*)getClassImagePathWithDaRenLevel:(NSInteger)daRenLevel;
/**
 *返回身份
 
 */
-(NSString*)getUserIdentify;

/**
 *  得到用户个人中心的背景照片
 *
 *  @return <#return value description#>
 */
-(NSString *)getUserPersonalCenterBackGroundImageName;


/**
 *  更新联系人
 */
+(void)updateConnectPerson;
/**
 *  更新关注的板块信息
 */
+(void)updateAttentionPlate:(NSUInteger) plateId  add:(BOOL)addOrDele;

/**
 *  更新帖子收藏信息
 */
+(void)updateStorePost:(NSUInteger) postId areaType:(NSString *)areaType add:(BOOL)addOrDele;
@end
