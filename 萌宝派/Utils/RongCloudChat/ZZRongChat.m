//
//  ZZRongChat.m
//  萌宝派
//
//  Created by zhizhen on 15/5/26.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZRongChat.h"
#import "ZZRongUserInfo.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZLoginSatus.h"
#define RONGCLOUD_IM_APPKEY @"x4vkb1qpvr83k" //online key  生产
//#define RONGCLOUD_IM_APPKEY @"x18ywvqf8harc" //online key  测试

#define kDeviceToken @"RongCloud_SDK_DeviceToken"

@interface ZZRongChat ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate>
@property(nonatomic,strong)NSArray*  conversationTypeList;

@end
@implementation ZZRongChat

-(NSArray *)conversationTypeList{
    if (!_conversationTypeList) {
        _conversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_CHATROOM), @(ConversationType_CUSTOMERSERVICE), @(ConversationType_SYSTEM)];
    }
    return _conversationTypeList;
}

singleton_implementation(ZZRongChat)
-(void)rongChatGetDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
   
}

-(void)rongChatInit{
    //融云 注册
//    NSString *_deviceTokenCache = [[NSUserDefaults standardUserDefaults]objectForKey:kDeviceToken];
    [[RCIM  sharedRCIM]initWithAppKey:RONGCLOUD_IM_APPKEY ];
    [RCIM  sharedRCIM].userInfoDataSource=self;
    [RCIM  sharedRCIM].receiveMessageDelegate = self;
    [RCIM  sharedRCIM].connectionStatusDelegate = self;
   // [[RCIMClient  sharedClient]init:RONGCLOUD_IM_APPKEY deviceToken:_deviceTokenCache];
}

-(void)rongChatConnectServerWithToken:(NSString*)token    andCallback:(RongChatCallBack)rongBack{
    if (!token.length) {
        return;
    }
   // token=  @"bDWSVICckvdnqgdTdsBgbLf0L9LS6aJPJVlG3NHhYncC/UFWn/0UudBIrnrvw4gAvVAzU7PYjAOtlf7J7oP11Sgw6WosmMXyJfUb8PD04W8dmwQKJS0KUVkKJJYY9NccPgiYUKyjAi4=";
    [self  rongChatDisConnectServer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[RCIM sharedRCIM]connectWithToken:token success:^(NSString *userId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.rongConnetSuccess = YES;
                rongBack(@"");
            });
        } error:^(RCConnectErrorCode status) {
            self.rongConnetSuccess = NO;
            rongBack(nil);
        } tokenIncorrect:^{
            self.rongConnetSuccess = NO;
            [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postLoginUserWithPhoneNumber:nil andPassword:nil andToken:[ZZLoginSatus  sharedZZLoginSatus].token andBack:^(id obj) {
                
            }];
        }];

    });
    

}
-(void)rongChatDisConnectServer{
      self.rongConnetSuccess = NO;
    [[RCIM  sharedRCIM]disconnect];
    
}
#pragma mark RCIMUserInfoFetcherDelegagte
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    if ([ZZRongUserInfo  selectDataWithRongUserInfoUserId:userId]) {
        RCUserInfo*  userInfo = [ZZRongUserInfo  readuserInfoWithPushid:userId];
         return completion(userInfo);
    }else{
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindUserNickWithToken:userId andCallBack:^(id obj) {
            
        }];
        return completion(nil);
    }
}
#pragma mark RCIMReceiveMessageDelegate
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
         [[NSNotificationCenter  defaultCenter]postNotificationName:ZZUpdateRongYunNewMessageInfoNotification object:nil];
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    switch (status) {
        case 0:
        case 3:
        case 4:
        case 5:
        case 7:
            self.rongConnetSuccess = YES;
            break;
            
        default:
            self.rongConnetSuccess = NO;
            break;
    }
}
#pragma mark  other
-(NSArray*)rongGetConversationListWithSelfConversation{
    return  [[RCIMClient sharedRCIMClient]getConversationList:self.conversationTypeList];
}
-(int)rongGetUnreadMessageCountWithSelfConversation{
    return [[RCIMClient  sharedRCIMClient]getUnreadCount:self.conversationTypeList];
}
-(void)rongClearMessagesUnreadStatus:(RCConversationType)conversationType andTargetId:(NSString *)targetId{
    [[RCIMClient  sharedRCIMClient]clearMessagesUnreadStatus:conversationType targetId:targetId];
}
-(RCUserInfo *)getZZUserInfoWithUserId:(NSString *)userId {
    
    if ([ZZRongUserInfo  selectDataWithRongUserInfoUserId:userId]) {
        RCUserInfo*  userInfo = [ZZRongUserInfo  readuserInfoWithPushid:userId];
        return userInfo;
    }else{
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postFindUserNickWithToken:userId andCallBack:^(id obj) {
        }];
        return nil;
    }
}

-(void)rongMessageCountChangeNoti{
    [self  onRCIMReceiveMessage:nil left:0];
}
@end
