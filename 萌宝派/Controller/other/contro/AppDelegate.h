//
//  AppDelegate.h
//  萌宝派
//
//  Created by guhuanhuan on 15-3-2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;


/*
 王雷 0520 添加引导动画的一些属性
 */
@property(nonatomic,strong)NSUserDefaults *userDefaults;
@property(nonatomic,strong)UIImageView* leadImageView;//引导动画
@property(nonatomic)NSInteger isTouchNumber;//判断首页引导动画点击一次后不再显示的条件
@property(nonatomic)NSInteger isUprightNumber;//判断竖版页面引导动画点击一次后不再显示的条件
@property(nonatomic)NSInteger isDetailNumber;//判断详情页面引导动画点击一次后不再显示的条件
@property(nonatomic)NSInteger isJourneyNumber;//判断专家行程页面引导动画点击一次后不再显示的条件
/**

 *进入登陆界面还是主页
 */

-(void)loginOrHomeByLoginStaus;
/**
 *改变rootViewController
 *type 1为登录界面   2为主页
 */
-(void)gotoBWindowAndController:(NSInteger) type;
/**
 
 *1首页上   2首页下  3详情  4行程  5发帖
 *王雷 0520 添加引导动画方法
 */
-(void)addLeadActionView:(NSInteger)number;

@end
