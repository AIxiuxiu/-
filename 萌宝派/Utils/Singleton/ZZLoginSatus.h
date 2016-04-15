//
//  ZZLoginSatus.h
//  萌宝派
//
//  Created by zhizhen on 15/4/23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
static NSString *domain = @"openfire.smart-kids.com";
//static NSString *domain = @"l94cdftuw7o8fti";
@interface ZZLoginSatus : NSObject
singleton_interface(ZZLoginSatus);
@property (nonatomic, copy) NSString *token;//用户名
@property(nonatomic,copy)NSString*  domin;//网络域名

/**
 *  登录的状态 YES 登录过/NO 注销
 */
@property (nonatomic, assign) BOOL  loginStatus;
/**
 *  后台进入，yes为活跃
 */
@property(nonatomic,assign)BOOL   activeStatus;
/**
融云token
 */
@property(nonatomic,copy)NSString*  rongToken;

@property (nonatomic, copy) NSString *jid;

/**
 *  从沙盒里获取用户数据
 */
-(void)loadUserInfoFromSanbox;

/**
 *  保存用户数据到沙盒
 
 */
-(void)saveUserInfoToSanbox;
@end
