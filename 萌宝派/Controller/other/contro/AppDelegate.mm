
//
//  AppDelegate.m
//  萌宝派
//
//  Created by guhuanhuan on 15-3-2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZTabBarViewController.h"
#import "ZZLeftViewController.h"

#import "DDMenuController.h"

//#import "ZZLoginViewController.h"
#import "LoginVC.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZNAViewController.h"
//三方

/**
 *  友盟三方
 */
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "ZZUMSdk.h"

#import "SDWebImageManager.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


#import "APService.h"

#import "ZZPushMessageFmdb.h"

#import "ZZLoginSatus.h"

//融云
#import "ZZRongChat.h"

#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ZZLoadingViewController.h"

#import "ZZSystemDetailMessageVC.h"
@implementation AppDelegate
#pragma mark  private methods
/*
 王雷 0520 添加引导动画
 */
-(UIImageView *)leadImageView{
    if (!_leadImageView) {
        _leadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _leadImageView.backgroundColor = [UIColor clearColor];
        _leadImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTapAction:)];
        [_leadImageView addGestureRecognizer:tap];

    }
    
    return _leadImageView;
}


-(void)addTapAction:(UITapGestureRecognizer*)tap{

    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.leadImageView.tag == 1) {
        //首页上
        [self addLeadActionView:2];
        
    }else if (self.leadImageView.tag == 2){
        //首页下
        self.isTouchNumber = 100;
        [self.userDefaults setInteger:self.isTouchNumber forKey:@"isTouchNumber"];
        [self.userDefaults synchronize];
        [self.leadImageView removeFromSuperview];
    }else if (self.leadImageView.tag == 5){
        self.isUprightNumber = 101;
        [self.userDefaults setInteger:self.isUprightNumber forKey:@"isUprightNumber"];
        [self.userDefaults synchronize];
        [self.leadImageView removeFromSuperview];
    }else if (self.leadImageView.tag == 6){
        //竖版2
        self.isUprightNumber = 101;
        [self.userDefaults setInteger:self.isUprightNumber forKey:@"isUprightNumber"];
        [self.userDefaults synchronize];
        [self.leadImageView removeFromSuperview];
    }else if (self.leadImageView.tag == 3){
        //详情
        self.isDetailNumber = 102;
        [self.userDefaults setInteger:self.isDetailNumber forKey:@"isDetailNumber"];
        [self.userDefaults synchronize];
        [self.leadImageView removeFromSuperview];
    }else{
        //行程
        self.isJourneyNumber = 103;
        [self.userDefaults setInteger:self.isJourneyNumber forKey:@"isJourneyNumber"];
        [self.userDefaults synchronize];
        [self.leadImageView removeFromSuperview];
    }
    
}

-(void)addLeadActionView:(NSInteger)number{
    switch (number) {
        case 1:
            //首页上
            if(ScreenHeight ==480){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"shouye1" ofType:@"png"]]];
            }else if (ScreenHeight == 667){
                
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"62-1" ofType:@"png"]]];
            }else if(ScreenHeight == 736){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"6P2-1" ofType:@"png"]]];
            }else{
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"2-1" ofType:@"png"]]];
            }
            
            self.leadImageView.tag = number;
            break;
        case 2:
            //首页下
            if(ScreenHeight ==480){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"shouye2" ofType:@"png"]]];
            }else if (ScreenHeight == 667){
                
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"62-2" ofType:@"png"]]];
            }else if(ScreenHeight == 736){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"6P2-2" ofType:@"png"]]];
            }else{
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"2-2" ofType:@"png"]]];
            }
            
            self.leadImageView.tag = number;
            break;
        case 3:
            //详情
        
            if (ScreenHeight == 480) {
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"detail4" ofType:@"png"]]];
            }else if (ScreenHeight == 667){
                
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"61" ofType:@"png"]]];
            }else if(ScreenHeight == 736){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"6P1" ofType:@"png"]]];
            }else{
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"1" ofType:@"png"]]];
            }
            
            self.leadImageView.tag = number;
            break;
        case 4:
            //行程
            if (ScreenHeight == 480) {
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"xingchen" ofType:@"png"]]];
            }else if (ScreenHeight == 667){
                
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"63" ofType:@"png"]]];
            }else if(ScreenHeight == 736){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"6P3" ofType:@"png"]]];
            }else{
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"3" ofType:@"png"]]];
            }
            
            self.leadImageView.tag = number;
            break;
        case 5:
            //发帖
            if (ScreenHeight == 480) {
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"4-1" ofType:@"png"]]];
            }else if (ScreenHeight == 667){
                
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"64-1" ofType:@"png"]]];
            }else if(ScreenHeight == 736){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"6P4-1" ofType:@"png"]]];
            }else{
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"5-1" ofType:@"png"]]];
            }
            
            self.leadImageView.tag = number;
            break;
        case 6:
            //发帖2
            if (ScreenHeight == 480) {
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"4-2" ofType:@"png"]]];
            }else if (ScreenHeight == 667){
                
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"64-2" ofType:@"png"]]];
            }else if(ScreenHeight == 736){
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"6P4-2" ofType:@"png"]]];
            }else{
                [self.leadImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"5-2" ofType:@"png"]]];
            }
            
            self.leadImageView.tag = number;
            break;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.leadImageView];
    
}

//- (id)init
//{
//    if (self = [super init]) {
//        _viewDelegate = [[AGViewDelegate alloc] init];
//     
//    }
//    return self;
//}
//登录还是进入主页
-(void)loginOrHomeByLoginStaus{

    /*
     张亮亮  0513  当状态为登录且token长度为32时直接登录
     */
    if ([ZZLoginSatus  sharedZZLoginSatus].loginStatus&&[ZZLoginSatus  sharedZZLoginSatus].token.length ==32&&![ZZLoginSatus  sharedZZLoginSatus].activeStatus) {
        //        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginUserWithPhoneNumber:nil andPassword:nil andToken:[ZZLoginSatus  sharedZZLoginSatus].token andBack:^(id obj) {
        //            //当登录失败时
        //            if (!obj) {
        //                [self  gotoBWindowAndController:1];
        //            }else{
        //                [self  loginSuccessNotion];
        //            }
        //        }];
        
        [self  gotoBWindowAndController:11];
    }else{
        [self  gotoBWindowAndController:1];
    }
    
}


//根据type  选用不同的rootviewcontroller  1 登录  ；2 首页并进行通知登录成功了
-(void)gotoBWindowAndController:(NSInteger) type{
    if (type == 1) {
        ZZNAViewController*  naviCon = [[ZZNAViewController alloc]initWithRootViewController:[[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil]];
        naviCon.navigationBarHidden = YES;
        self.window.rootViewController = naviCon;
    }else if(type ==2){
        ZZTabBarViewController*  mainVC = [[ZZTabBarViewController  alloc]init];
        DDMenuController*  menuCon = [[DDMenuController  alloc]initWithRootViewController:mainVC];
        menuCon.leftViewController =   [[ZZLeftViewController  alloc]init];
        // menuCon.rightViewController = [[ZZRightViewController  alloc]init];
        self.window.rootViewController = menuCon;
        [self  loginSuccessNotion];
        
        // 发通知
        
    }else  if(type == 11){//只创建界面 不发通知
        ZZTabBarViewController*  mainVC = [[ZZTabBarViewController  alloc]init];
        DDMenuController*  menuCon = [[DDMenuController  alloc]initWithRootViewController:mainVC];
        menuCon.leftViewController =   [[ZZLeftViewController  alloc]init];
        
        self.window.rootViewController = menuCon;
    }else{
        return;
    }
}
//
-(void)loginSuccessNotion{
#warning 一般情况下，都不会马上连接，会稍微等等
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSNotification* notification = [NSNotification notificationWithName:ZZAppDidBecomeActiveNotification object:nil userInfo:nil];
        
        [[NSNotificationCenter  defaultCenter  ]postNotification:notification];
    });
    
}


#pragma mark  life  cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    //设置缓存
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
//                                                            diskCapacity:100 * 1024 * 1024
//                                                                diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
     [[UIApplication  sharedApplication]setStatusBarHidden:NO];
    //读取登录信息  token的单例
    [[ZZLoginSatus  sharedZZLoginSatus]  loadUserInfoFromSanbox];

    /**
     *   0604 王雷添加的友盟sdk注册
     *  友盟sdk注册
     */
    [[ZZUMSdk sharedZZUMSdk] umSdkShareInit];
    
  
        //融云 注册
    [[ZZRongChat  sharedZZRongChat]rongChatInit];
   

    // 要使用百度地图，请先启动BaiduMapManager
  BMKMapManager*  mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"quRblrwVeCkSsEBVC8V7hrIw" generalDelegate:self];
    if (ret) {
        
    }
    //图片缓存大小
    [SDImageCache  sharedImageCache].maxCacheSize = 100*1024*1024;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //沉睡两秒  延长启动动画
    [NSThread   sleepForTimeInterval:2];
    //状态栏网络标识
    [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]  networkActivityIndicator];
    /*
     */
    //是否是更新后第一次运行
    NSUserDefaults* defaults = [NSUserDefaults  standardUserDefaults];
    NSString* saveVersion = [defaults  objectForKey:@"VersionString"];
    NSString*   currentVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([saveVersion  isEqualToString:currentVersion]) {
        [self  loginOrHomeByLoginStaus];
       //测试用，后面删除，上面！后面也去除
//        [defaults setObject:currentVersion forKey:@"VersionString" ];
//        [defaults  synchronize];
    }else{
        ZZLoadingViewController*  loadingVC = [[ZZLoadingViewController  alloc]init];
         self.window.rootViewController = loadingVC;

       
        [defaults setObject:currentVersion forKey:@"VersionString" ];
        [defaults  synchronize];
   }
    [self.window makeKeyAndVisible];
    [ APService  setLogOFF];
       [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)     categories:nil];
     [APService setupWithOption:launchOptions];


    return YES;
}

#pragma mark  百度调用
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
        [ZZLoginSatus  sharedZZLoginSatus].activeStatus = NO;
     if ([ZZLoginSatus  sharedZZLoginSatus].loginStatus) {
      [ [ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginOutAndEnterBackGround:NO AndBack:^(id obj) {
             
         }];
         [[ZZRongChat  sharedZZRongChat]rongChatDisConnectServer];
     }
  
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [ZZLoginSatus  sharedZZLoginSatus].activeStatus = YES;
    [BMKMapView didForeGround];
    if ([ZZLoginSatus  sharedZZLoginSatus].loginStatus&&[ZZLoginSatus  sharedZZLoginSatus].token.length ==32&&[self.window.rootViewController  isKindOfClass:[DDMenuController  class]]) {
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginUserWithPhoneNumber:nil andPassword:nil andToken:[ZZLoginSatus  sharedZZLoginSatus].token andBack:^(id obj) {
            
            if (obj) {
                [self  loginSuccessNotion];
            }else{
                if (![ZZUser  shareSingleUser].status) {
                     [self  gotoBWindowAndController:1];
                }
            }
        }];
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

#pragma mark  程序进程结束
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      [ZZLoginSatus  sharedZZLoginSatus].activeStatus = NO;
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginOutAndEnterBackGround:NO AndBack:^(id obj) {
        
    }];
    [[ZZRongChat  sharedZZRongChat]rongChatDisConnectServer];
}
#pragma mark  远程推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //_deviceToken = [NSString stringWithFormat:@"%@",deviceToken];
  
    [APService registerDeviceToken:deviceToken];
    //融云
    [[ZZRongChat  sharedZZRongChat]rongChatGetDeviceToken:deviceToken];
   
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
}

//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [application setApplicationIconBadgeNumber:0];
 
    [APService handleRemoteNotification:userInfo];
}
//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        
        [self  notificationClickedJump:[self  receiveNewMessageWithNotification:userInfo]];
     
    }else{
       [self  receiveNewMessageWithNotification:userInfo];
   
        // IOS 7 Support Required
   
        [APService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }

 
}
#pragma mark 分享回调
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    //return [ShareSDK handleOpenURL:url
                        //wxDelegate:self];
    /**
     *  0604 王雷添加的友盟
     */
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
    
    /**
     *  0604 王雷添加的友盟
     */
    return  [UMSocialSnsService handleOpenURL:url];
}
#pragma mark  BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
 
    
}

- (void)onGetPermissionState:(int)iError
{
 
}
#pragma mark  Notification

//ReceiveRemoteNotification:(NSDictionary *)userInfo
-(ZZSystemMessage *)receiveNewMessageWithNotification:(NSDictionary*)dic{
    ZZSystemMessage* message = [[ZZSystemMessage  alloc]init];
    message.sMessagePushId = [[dic  objectForKey:@"_j_msgid"]integerValue];
    if (!message.sMessagePushId) {
        message.sMessagePushId =0;
    }
   
    NSDictionary *aps = [dic  objectForKey:@"aps"];
    message.sMessageContent = [aps  objectForKey:@"alert"];
    if (!message.sMessageContent) {
        message.sMessageContent = @"";
    }
    NSDateFormatter* df = [[NSDateFormatter alloc]init];

        [df setDateFormat:@"MM-dd HH:mm"];
  
    NSString*  dates = [df  stringFromDate:[NSDate  date]];
    message.sMessageDate = dates;
    message.sMessageFlag = 1;
    if ([ZZPushMessageFmdb   selectDataWithMessagePushId:message.sMessagePushId]) {
        
    }else{
        [UIApplication  sharedApplication].applicationIconBadgeNumber += 1;
        [ZZPushMessageFmdb  addBabyRecord:message];
       NSNotification* notification = [NSNotification notificationWithName:ZZReceiveMessageNotification object:nil userInfo:nil];

        [[NSNotificationCenter  defaultCenter] postNotification:notification];
    }
    return message;
}

- (void)notificationClickedJump:(ZZSystemMessage *)message{
    ZZSystemDetailMessageVC *messageVC = [[ZZSystemDetailMessageVC alloc]init];
    messageVC.systemMessage =message;
    ZZNAViewController *navi = [[ZZNAViewController  alloc]initWithRootViewController:messageVC];
    [self.window.rootViewController  presentViewController:navi animated:NO completion:nil];
}
/**
 *  接受到内存警告，停止加载所有图片，并清除内存缓存
 */
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager*  webImageMan = [SDWebImageManager  sharedManager];
    [webImageMan   cancelAll];
    [webImageMan.imageCache  clearMemory];
}

@end
