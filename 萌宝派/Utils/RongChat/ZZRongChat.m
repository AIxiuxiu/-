//
//  ZZRongChat.m
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZRongChat.h"

#define RONGCLOUD_IM_APPKEY @"x18ywvqf8harc" //online key

#define kDeviceToken @"RongCloud_SDK_DeviceToken"

@interface ZZRongChat ()<RCIMUserInfoFetcherDelegagte>

@end
@implementation ZZRongChat
singleton_implementation(ZZRongChat)
-(void)rongChatGetDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[RCIMClient sharedClient] setDeviceToken:token];
   
}

-(void)rongChatInit{
    
    //融云 注册
    NSString *_deviceTokenCache = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    [[RCIM  sharedKit]initWithAppKey:RONGCLOUD_IM_APPKEY deviceToken:_deviceTokenCache];
    [[RCIM  sharedKit]setUserInfoFetcherDelegate:self];
   // [[RCIMClient  sharedClient]init:RONGCLOUD_IM_APPKEY deviceToken:_deviceTokenCache];
}

-(void)rongChatConnectServerWithToken:(NSString*)token  andRongChatBack:(RongChatCallBack)rongChatBack{
    [[RCIM  sharedKit]connectWithToken:@"bjwK5VSiJjsKGihcWMoIALjIGNu2I/qxvln9mkL28D5ov4SOa2kSRgAaRoOSN1/SAYIyHmfGQBerz7lWf3GBjvPDA+WE2wGAmm+u6KiArFhja8srRwNe43b2OcYvQ81B5TD+oB1sM3E=" success:^(NSString *userId) {
        NSLog(@"...success");
        
        rongChatBack(@"");
    } error:^(RCConnectErrorCode status) {
        NSLog(@"...error:%d",status);
         rongChatBack(@"");
    }];
    
//    [[RCIMClient  sharedClient]connectWithToken:@"bjwK5VSiJjsKGihcWMoIALjIGNu2I/qxvln9mkL28D5ov4SOa2kSRgAaRoOSN1/SAYIyHmfGQBerz7lWf3GBjvPDA+WE2wGAmm+u6KiArFhja8srRwNe43b2OcYvQ81B5TD+oB1sM3E=" success:^(NSString *userId) {
//        
//    } error:^(RCConnectErrorCode status) {
//        
//    }];
}

#pragma mark RCIMUserInfoFetcherDelegagte
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if ([@"73324a5571b34315b889be0da4c58d0a" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"73324a5571b34315b889be0da4c58d0a";
        user.name = @"我是黄河";
       // user.portraitUri = @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
        
        return completion(user);
    }
    if ([@"692e9a6cbbb94086b2b12992a050c63d" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"692e9a6cbbb94086b2b12992a050c63d";
        user.name = @"在线小编7";
        // user.portraitUri = @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
        
        return completion(user);
    }
    
}

-(RCUserInfo *)getZZUserInfoWithUserId:(NSString *)userId {
    if ([@"73324a5571b34315b889be0da4c58d0a" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"73324a5571b34315b889be0da4c58d0a";
        user.name = @"我是黄河";
        // user.portraitUri = @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
        
        return user;
    }
    if ([@"692e9a6cbbb94086b2b12992a050c63d" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"692e9a6cbbb94086b2b12992a050c63d";
        user.name = @"在线小编7";
        // user.portraitUri = @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
        
        return user;
    }else{
        return nil;
    }
}
@end
