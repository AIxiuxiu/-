//
//  ZZUMSdk.m
//  友盟SDK
//
//  Created by charles on 15/6/3.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//

#import "ZZUMSdk.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "MobClick.h"
@interface ZZUMSdk ()<UMSocialUIDelegate>

@end

@implementation ZZUMSdk
/**
 *  实现单例的类方法
 */
singleton_implementation(ZZUMSdk);

-(NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _shareArray;
}
-(NSMutableArray *)enterArray{
    if (!_enterArray) {
        _enterArray =[NSMutableArray arrayWithCapacity:3];
    }
    return _enterArray;
}

/**
 *  友盟分享注册实例方法
 */
-(void)umSdkShareInit{
    [UMSocialData setAppKey:@"556e722967e58e98be002ba7"];
    
    //使用友盟统计
    [MobClick startWithAppkey:@"556e722967e58e98be002ba7" reportPolicy:BATCH   channelId:@"App Store"];

    /**
     *  QQ分享入口
     */
    if ([TencentOAuth iphoneQQSupportSSOLogin]) {
        [UMSocialQQHandler setQQWithAppId:@"1104000906" appKey:@"T73NH4Tz75dWsPdy" url:@"http://www.umeng.com/social"];
        [self.shareArray addObject:UMShareToQQ];
        [self.shareArray addObject:UMShareToQzone];
        
        NSDictionary*  qqDic = @{@"imageName":@"QQ_50x50",@"loginType":@(ZZUMSdkShareQQ)};
        [self.enterArray addObject:qqDic];
    }

    /**
     *  微信分享入口
     */
    if ([WXApi isWXAppSupportApi]){
        [UMSocialWechatHandler setWXAppId:@"wx766b807ef51aa8da" appSecret:@"139fc6ccddba72262d94688368082312" url:nil];
        [self.shareArray addObject:UMShareToWechatSession];
        [self.shareArray addObject:UMShareToWechatTimeline];
        
        
        NSDictionary*  weChatDic = @{@"imageName":@"Wechat_50x50",@"loginType":@(ZZUMSdkShareWeChat)};
        [self.enterArray addObject:weChatDic];
    }
    
    /**
     *  新浪分享入口
     */
    [UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    [self.shareArray addObject:UMShareToSina];

    NSDictionary*  sinaDic = @{@"imageName":@"weibo_50x50",@"loginType":@(ZZUMSdkShareSina)};
    
    [self.enterArray  addObject:sinaDic];
    
    
}

-(void)umThirdEnterWithController:(UIViewController*)controller andUmSdkShare:(ZZUMSdkShare)umSdkShare andBack:(UMSdkCallBack)umSdkBack{

    NSString* thirdName = nil;
    
    switch (umSdkShare) {
        case 0:
            thirdName = UMShareToQQ;
            break;
        case 1:
            thirdName = UMShareToSina;
            break;
            
        case 2:
            thirdName = UMShareToWechatSession;
            break;

    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:thirdName];
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:thirdName];
            
            ZZLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.openId);
            NSMutableDictionary*  backDic = [NSMutableDictionary  dictionary];
            if (snsAccount.userName.length) {
                [backDic setObject:snsAccount.userName forKey:@"thirdNickName"];
            }else{
                umSdkBack(nil);
            }
            if (snsAccount.usid.length) {
                [backDic setObject:snsAccount.usid forKey:@"thirdToken"];
            }else{
                umSdkBack(nil);
            }
            umSdkBack(backDic);
        }else{
            
            umSdkBack(nil);
        }
    });
}
/**
 *  退出三方登入
 *
 *  @param umSdkShare <#umSdkShare description#>
 */
-(void)umThirdShareCancel{
//    NSString* thirdName = nil;
//    
//    switch (umSdkShare) {
//        case 0:
//            thirdName = UMShareToQQ;
//            break;
//        case 1:
//            thirdName = UMShareToSina;
//            break;
//            
//        case 2:
//            thirdName = UMShareToWechatSession;
//            break;
//            
//        default:
//            break;
//    }
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
      
    }];
    
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
      
    }];
    
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
       
    }];
}


@end
