
//
//  ZZMengBaoPaiRequest.m
//  萌宝派
//
//  Created by zhizhen on 14-11-12.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZMengBaoPaiRequest.h"
#import "ZZHudView.h"
#import "ZZMyAlertView.h"

#import "AFNetworking.h"
#import "ZZUser.h"
#import "ZZJsonParse.h"
#import "ZZExpert.h"
#import "MBProgressHUD.h"
#import "ZZMessage.h"
#import "ZZHudView.h"
#import "AppDelegate.h"
#import "ZZImageAndDescribe.h"
#import "ZZBaby.h"
#import "ZZBabyDiaryInfo.h"
#import "ZZExpert.h"
#import "ZZMessage.h"
#import "ZZLoginSatus.h"
#import "ZZRongChat.h"
#import "ZZRongUserInfo.h"
#import "ZZLibCacheTool.h"
#import "AFNetworkActivityIndicatorManager.h"

static  ZZMengBaoPaiRequest *  singleMengBaoPaiRequest = nil;
static      ZZMyAlertView*  myAlertView = nil;
static  ZZHudView*  hudView = nil;
static  ZZHudView*  netHudView = nil;
static  MBProgressHUD*  netHud = nil;
/**
    张亮亮 0512 文字提示信息时间
 */
/*
static  const  NSTimeInterval  mrSuccessTime = 1;
static  const  NSTimeInterval  mrFailTime = 3;
static  const  NSTimeInterval  mrNoMoreTime = 3;
*/

@interface ZZMengBaoPaiRequest ()
@property(nonatomic,strong)AFHTTPRequestOperationManager*  manager;
@end
@implementation ZZMengBaoPaiRequest
-(void)networkActivityIndicator{
 // BOOL  uu =  self.manager.reachabilityManager.networkReachabilityStatus;
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}
#pragma mark ---------------------单例----------------------
+(ZZMengBaoPaiRequest*)shareMengBaoPaiRequest{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleMengBaoPaiRequest = [[self  alloc]init];
    singleMengBaoPaiRequest.baseUrl = @"http://mengbaopai.smart-kids.com/iosAndroid" ;
        myAlertView = [[ZZMyAlertView  alloc]initWithMessage:nil delegate:nil cancelButtonTitle:nil sureButtonTitle:@"确定"];
        NSURL *baseURL = [NSURL URLWithString:singleMengBaoPaiRequest.baseUrl];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseURL];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
       // manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
        singleMengBaoPaiRequest.token = @"";
        manager.requestSerializer.timeoutInterval = 60;//
        [manager.reachabilityManager setReachabilityStatusChangeBlock :^ (AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [netHudView  dismiss];
                    break ;
                case AFNetworkReachabilityStatusNotReachable:
                    [self  hudViewShowWithTipStr:@"没有网络" andTime:0];
                     break ;
                default:
                    break ;
            }
            
        }];
        singleMengBaoPaiRequest.token = @"";
        [manager.reachabilityManager  startMonitoring];
        
        singleMengBaoPaiRequest.manager = manager;
        netHud = [[MBProgressHUD  alloc]initWithMengBaoPaiWindow];
        netHud.labelText = @"加载中...";
        hudView = [[ZZHudView  alloc]init];
        
        netHudView = [[ZZHudView  alloc]init];
    });
    
    return singleMengBaoPaiRequest;
}

+(void)hudViewShowWithTipStr:(NSString*)str   andTime:(NSTimeInterval)time;{
    netHudView.contentLabel.text = str;
    if (time) {
        [netHudView  showWithTime:time];
    }else{
        [netHudView  showWithNOTimer];
    }
}

-(NSString *)token{
    if (!_token.length) {
        _token = [ZZLoginSatus sharedZZLoginSatus].token;
        if (!_token) {
            _token = @"";
        }
    }
    return _token;
}

//-(BOOL)netIsReachable{
//    BOOL   backBool = self.manager.reachabilityManager.networkReachabilityStatus;
//    if (backBool == 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [ZZMengBaoPaiRequest hudViewShowWithTipStr:@"没有网络" andTime:0 ];
//        });
//    }
//    NSLog(@",,,%d,,,%d,,,,,%d,,%@",self.manager.reachabilityManager.networkReachabilityStatus,self.manager.reachabilityManager.isReachable,self.manager.reachabilityManager.reachable,[NSThread  currentThread]);
//    return backBool;
//}
#pragma mark ---------------------网络请求返回结果提示----------------------
//请求错误，显示错误信息，调用alertView
-(void)showWaitAV:(NSString*)error{
    myAlertView.message = error;
    dispatch_async(dispatch_get_main_queue(), ^{
        [myAlertView show];
    });
}

-(void)hudViewShowWithStr:(NSString*)str   andTime:(NSTimeInterval)time;{
    hudView.contentLabel.text = str;
    if (time) {
        [hudView  showWithTime:time];
    }else{
        [hudView  showWithNOTimer];
    }
}

/*
 #pragma mark ios请求方式
 //ios自带的get请求方式
 -(void)getddByApiName:(NSString *)apiName andParams:(NSString *)params andCallBack:(CallBack)callback{
 //    显示正在加载
 // NSString *path = [NSString stringWithFormat:@"http://192.168.100.182:8080/smart/user/count?registerPhone=31312&password=32113&nick=fs"];
 
 
 
 NSString *path = nil;
 if (params.length) {
 path=  [NSString stringWithFormat:@"http://192.168.100.151:8080/smart/%@?%@",apiName,params];
 }else{
 path=  [NSString stringWithFormat:@"http://192.168.100.151:8080/smart/%@",apiName];
 }
 
 
 NSString*  pathStr = [path  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSURL *url = [NSURL URLWithString:pathStr];
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 
 NSURLSession *session = [NSURLSession sharedSession];
 NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 dispatch_async(dispatch_get_main_queue(), ^{
 
 
 id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
 
 
 if ([jsonData  isKindOfClass:[NSArray  class]]) {
 NSDictionary*  dic = jsonData[0];
 
 callback(dic);
 
 
 }else{
 callback(jsonData);
 }
 
 });
 
 
 }];
 //开始请求
 [task resume];
 }
 //ios自带的post请求方式
 -(void)postddByApiName:(NSString *)apiName andParams:(NSDictionary*)params andCallBack:(CallBack)callback{
 
 
 NSString *path = [NSString stringWithFormat:@"http://192.168.100.151:8080/smart/%@",apiName];
 NSURL *url = [NSURL URLWithString:path];
 
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [request setHTTPMethod:@"POST"];
 NSError*  error;
 
 if ([NSJSONSerialization isValidJSONObject:params]) {
 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
 [request  setHTTPBody:jsonData];
 
 
 NSURLSession *session = [NSURLSession sharedSession];
 NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 dispatch_async(dispatch_get_main_queue(), ^{
 NSString*  str = [[NSString   alloc]initWithData:data encoding:NSUTF8StringEncoding];
 ZZLog(@"..........%@",str);
 id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
 if ([jsonData  isKindOfClass:[NSArray  class]]) {
 NSDictionary*  dic = jsonData[0];
 
 callback(dic);
 
 
 }else{
 callback(jsonData);
 }
 });
 
 }];
 //开始请求
 [task resume];
 
 }
 }
 */
#pragma mark ---------------------网络请求方式----------------------
#pragma mark 第三方请求方式
//第三方的get请求方式
-(void)getByApiName:(NSString *)apiName andParams:(id)params andCallBack:(CallBack)callback{
   
        [self.manager GET:apiName parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            callback(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            callback(nil);
            // [self  hudViewShowWithStr:@"网络连接错误，请重试" andTime:3];
        }];
 
}
//第三方的post请求方式
-(void)postByApiName:(NSString *)apiName andParams:(id)params andCallBack:(CallBack)callback{

        [self.manager POST:apiName parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            callback(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            callback(nil);
            // [self  hudViewShowWithStr:@"网络连接错误，请重试" andTime:3];
        }];

    
}
//第三方的post上传图片请求方式
-(void)postImageByApiName:(NSString *)apiName andParams:(id)params  andImagesArray:(NSArray*)images andImageName:(NSString*)imageName  andBack:(CallBack)callback{
   
        [self.manager POST:apiName parameters:params constructingBodyWithBlock:^(id formData) {
            for (int i = 0; i<images.count; i++) {
                NSData*  imageData = UIImageJPEGRepresentation([self  fixOrientation:images[i]], 0.8);
                NSString*     name = [NSString   stringWithFormat:@"%@%d",imageName,i];
                
                [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"image.jpg"] mimeType:@"image/jpeg"];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            callback(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            callback(nil);
            // [self  hudViewShowWithStr:@"网络连接错误，请重试" andTime:3];
        }];
}


-(void)postImageByApiName:(NSString *)apiName  andImageName:(NSString*)imageName  andParams:(id)params  andImage:(UIImage*)image andBack:(CallBack)callback{
    
        NSData*  imageData = UIImageJPEGRepresentation([self  fixOrientation:image], 0.8);
        [self.manager POST:apiName parameters:params constructingBodyWithBlock:^(id formData) {
            
            if (image) {
                [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"image.jpg"] mimeType:@"image/jpeg"];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            callback(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[self  hudViewShowWithStr:@"网络连接错误，请重试" andTime:3];
            callback(nil);
        }];
  
}

#pragma mark ---------------------注册登录----------------------
#pragma mark 验证手机号是否注册过-----
//验证手机号是否注册过，无则发送验证码，有则返回失败
-(void)postValidPhoneIsResignWithPhoneNumber:(NSString*)number andBack:(CallBack)callback{
    
    [netHud  hudShow];
    NSDictionary*  paramsDic = @{@"registerPhone":number};
    
    [self   postByApiName:@"login/validPhone" andParams:paramsDic andCallBack:^(id obj) {
        [netHud  hudHide];
        ZZLog(@"验证手机号:%@",obj);
        NSString*  code = [obj  objectForKey:@"code"];
        
        if ( code && [code  isEqualToString:@"1"]) {
            [self  hudViewShowWithStr:@"获取验证码成功" andTime:1];
            
            callback(@"");
        }else {
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                 tip = @"获取验证码失败";
            }
            [self    hudViewShowWithStr:tip andTime:3];
            callback(nil);
        }
    }];
}
#pragma mark 获取验证码
//获取验证码
-(void)postSecurityWithPhoneNumber:(NSString*)number andBack:(CallBack)callback{
    NSDictionary*  paramsDic = @{@"phone":number};
    [netHud  hudShow  ];
    [self  postByApiName:@"login/forgetPWD" andParams:paramsDic andCallBack:^(id obj) {
        
        [netHud  hudHide];
        ZZLog(@"获取验证码\n");
        ZZLog(@"\n%@\n",obj);
        
        NSString*  code = [obj  objectForKey:@"code"];
        if ([code  isEqualToString:@"1"]) {
            [self  hudViewShowWithStr:@"获取验证码成功" andTime:1];
            callback(@"");
        }else{
            /*
             张亮亮 0511 删除
            NSString*  tip = nil;
            NSDictionary*  context = [obj  objectForKey:@"context"];
            
            if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSString*  str = [context  objectForKey:@"presentation"];
                if ([str  isKindOfClass:[NSString  class]]&&str.length) {
                    tip = str;
                }else{
                    tip = @"获取验证码失败";
                }
            }else{
                 tip = @"获取验证码失败";
            }
           */
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"获取验证码失败";
            }
            
            
            [self    hudViewShowWithStr:tip andTime:3];
            callback(nil);
        }
        
    }];
    
}
#pragma mark 忘记密码
//忘记密码 获取验证码后提交
-(void)postValidSecurityWithRegisterPhone:(NSString*)phoneNumber andSecurity:(NSString*)security andBack:(CallBack)callback{
    [netHud hudShow];
    NSDictionary*  paramsDic = @{@"phone":phoneNumber,@"security":security};
    [self   postByApiName:@"login/submitPWD" andParams:paramsDic andCallBack:^(id obj) {
        
        [netHud  hudHide];
        if ([[obj  objectForKey:@"code"]integerValue]==1) {
            callback(obj);
            [self  hudViewShowWithStr:@"验证成功，输入新密码" andTime:1];
        }else{
            
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"验证失败";
            }

            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
    
    
}

#pragma mark 更新密码
//忘记密码  更新密码
-(void)postUpdatePWDWithRegisterPhone:(NSString*)phoneNumber  andNewPassword:(NSString*)password  andBack:(CallBack)callback{
    [netHud  hudShow];
    NSDictionary*  paramsDic = @{@"phone":phoneNumber,@"password":password};
    [self   postByApiName:@"login/updatePWD" andParams:paramsDic andCallBack:^(id obj) {
        
        [netHud  hudHide];
        if ([[obj  objectForKey:@"code"]integerValue]==1) {
            callback(obj);
            [self  hudViewShowWithStr:@"新密码设置成功" andTime:1];
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"新密码设置失败";
            }
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:3];
        }
    }];
}
#pragma mark  手机号注册－－－－
-(void)postAddUserWithPhoneNumber:(NSString*)number   andPassword:(NSString*)password  andSecurity:(NSString*)security   andNick:(NSString*)nick   andBack:(CallBack)callback{
    
    [netHud  hudShow];
    NSDictionary*  paramsDic = @{@"registerPhone":number,@"registerPassword":password,@"nick":nick,@"security":security};
    
    [self   postByApiName:@"login/register" andParams:paramsDic andCallBack:^(id obj) {
        ZZLog(@"注册用户\n");
        ZZLog(@"\n%@\n",obj);
        
        NSString*  code = [obj  objectForKey:@"code"];
        NSDictionary*  context = [obj objectForKey:@"context"];
        [netHud  hudHide];
        if ([code  isEqualToString:@"1"]) {
            [self  hudViewShowWithStr:@"用户注册成功" andTime:1];
          //  NSString*  token = [context  objectForKey:@"token"];
           // [self updateLogeStatusWithToken:token];
            [self  updateLogeStatusWithContext:context ];
            callback(@"");
        }else{
            
            /*
            NSString*  tip = nil;
            NSString*  str = [context  objectForKey:@"presentation"];
            if ([str  isKindOfClass:[NSString  class]]&&str.length) {
                tip = str;
            }else{
                tip = @"用户注册失败";
            }
           */
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"用户注册失败";
            }
            
            
            [self    hudViewShowWithStr:tip andTime:3];
            callback(nil);
        }
        
    }];
    
}

#pragma mark 手机号登录-----
-(void)postLoginUserWithPhoneNumber:(NSString*)number   andPassword:(NSString*)password  andToken:(NSString*)token andBack:(CallBack)callback{
    if (!token) {
        [netHud  hudShow];
    }
    
    NSDictionary*  paramsDic =nil;
    if (token) {
        paramsDic = @{@"token":token};
    }else{
        
        paramsDic=    @{@"registerPhone":number,@"registerPassword":password};
    }
    
    
    [self   postByApiName:@"login/logins" andParams:paramsDic andCallBack:^(id obj) {
        ZZLog(@"登录%@",obj);
        /*
         测试登陆问题
         */
        [netHud   hudHide];
        NSDictionary*  context = [obj objectForKey:@"context"];
        if ([[obj  objectForKey:@"code"] integerValue] ==0) {
            /*
            NSString*  str = nil;
            if ([context isKindOfClass:[NSDictionary  class]]) {
                str = [context objectForKey:@"presentation"];
            }
            NSString*  tip = nil;
            if ([str  isKindOfClass:[NSString class]]&&str.length) {
                tip = str;
            }else{
                tip = @"登录失败";
            }
             */
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"登录失败";
            }
            
            
            if (!token) {
                [self    hudViewShowWithStr:tip andTime:3];
            }
            
            callback(nil);
        }else{
           // self.token = [context  objectForKey:@"token"];
            /*
             张亮亮  0513  优化登录流程
             */
//            if (number&&password) {
//                NSString*  token = [context  objectForKey:@"token"];
//                [self updateLogeStatusWithToken:token];
//            }
            [self  updateLogeStatusWithContext:context];
            NSString* userStatus = [context  objectForKey:@"userStatus"];
            callback(userStatus);
        }
    }];
}

#pragma mark 选择用户状态-----
-(void)postAddIndentityWtihInt:(NSUInteger)index andBack:(CallBack)callback{
    [netHud  hudShow];
    NSDictionary*  paramsDic = @{@"status":@(index),@"token":self.token};
    
    [self   postByApiName:@"login/chooseStatus" andParams:paramsDic andCallBack:^(id obj) {
        ZZLog(@"增加用户身份\n");
        ZZLog(@"\n%@\n",obj);
        NSString*  code = [obj  objectForKey:@"code"];
        [netHud  hudHide];
        if ([code  isEqualToString:@"1"]) {
            [self     updateLogeStatusLogSuccess];
            callback(@"");
        }else{
            /*
            NSDictionary*  context = [obj  objectForKey:@"context"];
            NSString*  str = [context   objectForKey:@"presentation"];
            NSString*  tip = nil;
            if ( [str  isKindOfClass:[NSString  class]]&&  str.length) {
                tip = str;
            }else{
                tip = @"添加用户身份失败";
            }
             */
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"添加用户身份失败";
            }
            
            [self    hudViewShowWithStr:tip andTime:3];
            callback(nil);
        }
    }];
}


#pragma mark 三方注册登录－－－－－－－

//三方注册注册用户 --新版
-(void)postAddUserByThirdWithUserOpenId:(NSString*)userOpenId   andNick:(NSString*)nick   andBack:(CallBack)callback{
    
    [netHud  hudShow];
    if (userOpenId == nil||nick == nil) {
        callback(nil);
        return;
    }
    NSDictionary*  paramsDic = @{@"openId":userOpenId,@"nick":nick};
    [self   postByApiName:@"login/logins" andParams:paramsDic andCallBack:^(id obj) {
        ZZLog(@"注册用户\n");
        ZZLog(@"\n%@\n",obj);
        NSString*  code = [obj  objectForKey:@"code"];
         NSDictionary*  context = [obj objectForKey:@"context"];
        [netHud  hudHide];
        if ([code  intValue]) {
            [self  hudViewShowWithStr:@"用户登录成功" andTime:1];
            /*
             张亮亮  0513  优化登录流程
             */
//           NSString*  token = [context  objectForKey:@"token"];
//            [self updateLogeStatusWithToken:token];
            [self  updateLogeStatusWithContext:context];
            NSString* userStatus = [context  objectForKey:@"userStatus"];
           
            callback(userStatus);
        }else{
            /*
            NSString*  tip = nil;
            NSString*  str = [context  objectForKey:@"presentation"];
            if ([str  isKindOfClass:[NSString  class]]&&str.length) {
                tip = str;
            }else{
                tip = @"用户登录失败";
            }
             */
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"用户登录失败,请重试";
            }
            [self    hudViewShowWithStr:tip andTime:3];
            callback(nil);
        }
    }];
}
#pragma mark ---------------------个人----------------------
#pragma mark 查询登录用户信息－－－－－－－
-(void)postQueryUserInfoWithTokenAndBack:(CallBack)callback{
    [self   postByApiName:@"user/findUserBasic" andParams:@{@"token":self.token} andCallBack:^(id obj) {
        ZZLog(@"用户信息:%@",obj);
        NSInteger  code = [[obj  objectForKey:@"code"]integerValue];
        if (code ==1) {
            NSDictionary*  context = [obj  objectForKey:@"context"];
            [ZZJsonParse  parseLoginUserInfoByDic:context];
            callback(@"");
        }else{
            callback(nil);
           // [self  hudViewShowWithStr:@"查询失败" andTime:3];
        }
    }];
}
#pragma mark 更新个人信息

-(void)postUpdateUserinfoWithNick:(NSString*)nick  andStatus:(NSInteger)status  andImage:(UIImage*)image  andBack:(CallBack)callback{
    [netHud  hudShow];
    NSMutableDictionary*  paramsDic = [NSMutableDictionary  dictionary];
    [paramsDic  setObject:self.token forKey:@"token"];
    if (nick.length) {
        [paramsDic  setObject:nick forKey:@"nike"];
    }
    if (status) {
        [paramsDic  setObject:@(status) forKey:@"userStatus"];
    }
        [self  postImageByApiName:@"user/updateUserBasic" andImageName:@"image" andParams:paramsDic andImage:image andBack:^(id obj) {
            [netHud  hudHide];
            ZZLog(@"修改个人信息:%@",obj);
            if ([[obj  objectForKey:@"code"]integerValue]==1) {
                [self  hudViewShowWithStr:@"修改个人信息成功" andTime:1];
                NSDictionary*  context = [obj  objectForKey:@"context"];
                if ([context  isKindOfClass:[NSDictionary class]]&&context.count) {
                    [ZZJsonParse  parseUpdateLoginUserInfoByDic:context];
                    callback(@"");
                }else{
                    callback(@"");
                }
            }else{
                    NSDictionary*  context = [obj  objectForKey:@"context"];

                NSString*  str = nil;
                if ([context   isKindOfClass:[NSDictionary  class]]) {
                    str = [context  objectForKey:@"flag"];
                }
                NSString*  tip = nil;
          
                if ([str  isKindOfClass:[NSString  class]]&&str.length) {
                    tip = str;
                }else{
                    tip = @"修改个人信息失败";
                }
                [self  hudViewShowWithStr:tip andTime:3];
                callback(nil);
            }
        }];
//    }else{
//        [self  postByApiName:@"user/updateUserBasic" andParams:paramsDic andCallBack:^(id obj) {
//            [netHud  hudHide];
//            ZZLog(@".....o%@",obj);
//            if ([[obj  objectForKey:@"code"]integerValue]==1) {
//                [self  hudViewShowWithStr:@"修改个人信息成功" andTime:1];
//                NSDictionary*  context = [obj  objectForKey:@"context"];
//                if ([context  isKindOfClass:[NSDictionary class]]&&context.count) {
//                    [ZZJsonParse  parseUpdateLoginUserInfoByDic:context];
//                    callback(@"");
//                }else{
//                    callback(nil);
//                }
//            }else{
//                [self  hudViewShowWithStr:@"修改个人信息失败" andTime:1];
//                callback(nil);
//            }
//        }];
//    }
    
}
#pragma mark ---------------------通用方法----------------------
#pragma mark  按区域查询所有板块------
-(void)postFindALLPlatesByAreaType:(NSString*)area  andBack:(CallBack)callback{

    [self  postByApiName:@"plate/findByAreaTypeFromPlate" andParams:@{@"token":self.token,@"areaType":area} andCallBack:^(id obj) {
        ZZLog(@"同龄板块查询:%@",obj);
  
        NSInteger  code = [[obj  objectForKey:@"code"]integerValue];
        if (code ==1) {
            NSArray*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  mArray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary*  dic in context) {
                    ZZPlateTypeInfo*  platetypeInfo = [ZZJsonParse   parsePlateTypeInfoByDic:dic];
                    platetypeInfo.areaType = [area   copy] ;
                    if (platetypeInfo) {
                        [mArray  addObject:platetypeInfo];
                    }
                }
                    callback(mArray);
            }else{
                callback(nil);
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip = @"查询失败";
            }
            callback(nil);
             [self  hudViewShowWithStr:tip andTime:3];
        }
    }];
}


#pragma mark 添加或删除关注，人或板块    yes  添加   no为删除
-(void)postUpdateAttentionUserOrPlateWithCode:(NSString*)code   andPlatedId:(NSUInteger)plateId  andUserId:(NSUInteger)userId  andAddOrDelete:(BOOL)yesOrNo  andCallback:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:4];
    [params  setObject:code forKey:@"code"];
    [params   setObject:@(userId) forKey:@"userId"];
    [params  setObject:self.token forKey:@"token"];
    if (plateId) {
        [params  setObject:@(plateId) forKey:@"plateId"];
    }
    NSString*  apiName = nil;
    if (yesOrNo) {
        apiName = @"attention/addAttention";
    }else{
        apiName = @"attention/deleteAttention";
    }
    [self  postByApiName:apiName andParams:params andCallBack:^(id obj) {
        ZZLog(@"添加或删除关注 :%@",obj);
        
        if ([[obj  objectForKey:@"code"]boolValue]) {
            if ([code  isEqualToString:@"user"]) {
                [ZZUser  updateConnectPerson];
            }else{
                [ZZUser  updateAttentionPlate:plateId  add:yesOrNo];
            }
            
            NSString* str = nil;
            if (yesOrNo) {
                str= @"关注成功";

            }else{
                str= @"删除关注成功";
            }
           
            [self  hudViewShowWithStr:str andTime:1];
            callback(@"");
        }else{
          
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                if (yesOrNo) {
                    tip= @"关注失败";
                }else{
                    tip= @"删除关注失败";
                }
            }
            
            [self  hudViewShowWithStr:tip andTime:1];
            callback(nil);
        }
    }];
}
#pragma mark   添加 或删除 收藏
-(void)postUpdateStoreUpPostWithPostId:(NSUInteger)postId  andPlateType:(ZZPlateTypeInfo*)plateType andAddOrDelete:(BOOL)yesOrNo    andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params  setObject:@(postId) forKey:@"postId"];
    if ([plateType.areaType  isEqualToString:@"HELP"]) {
        [params  setObject:@"HELP" forKey:@"postType"];
    }else{
        [params  setObject:plateType.type forKey:@"postType"];
    }
    
    [params   setObject:self.token forKey:@"token"];
    
    NSString*  apiName = nil;
    if (yesOrNo) {
        apiName = @"storeUp/addStoreUp";
        [params  setObject:plateType.areaType forKey:@"postAreaType"];
    }else{
        apiName = @"storeUp/deleteStoreUp";
    }
    [self  postByApiName:apiName andParams:params andCallBack:^(id obj) {
        ZZLog(@"添加或删除收藏:%@",obj);
        
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSString* resultStr = nil;
            if (yesOrNo) {
                resultStr = @"收藏成功";
            }else{
                resultStr = @"删除收藏成功";
            }
            callback(@"");
            [ZZUser  updateStorePost:postId areaType:plateType.areaType add:yesOrNo];
            [self  hudViewShowWithStr:resultStr andTime:1];
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  resultStr = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!resultStr.length){
                if (yesOrNo) {
                    resultStr = @"收藏失败";
                }else{
                    resultStr = @"删除收藏失败";
                }
            }
            
            /*
            NSString* resultStr = nil;
            if (yesOrNo) {
                resultStr = @"收藏失败";
            }else{
                resultStr = @"删除收藏失败";
            }
             */
            callback(nil);
            [self  hudViewShowWithStr:resultStr andTime:1];
        }
    }];
}

#pragma mark  所有板块点赞或取消点赞
-(void)postUpdateSpotPostWithPlate:(ZZPlateTypeInfo*)plate  andPostId:(NSUInteger)postId andAddOrDelete:(BOOL)yesOrNo andBack:(CallBack)callback{
    NSDictionary*  params = @{@"token":self.token,@"areaType":plate.areaType,@"type":plate.type,@"relationId":@(postId)};
    NSString*  apiName = nil;
    if (yesOrNo) {
        apiName = [NSString  stringWithFormat:@"%@AddSpot",plate.interface];
    }else{
        apiName = [NSString  stringWithFormat:@"%@DeleteSpot",plate.interface];
    }
    
    [self  postByApiName:apiName andParams:params andCallBack:^(id obj) {
        ZZLog(@"点赞或者取消点赞:%@",obj);
        if ([[obj  objectForKey:@"code"]integerValue]) {
            callback(obj);
        }else{
//            NSString*  resultStr = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
//            if(!resultStr.length){
//                if (yesOrNo) {
//                    resultStr = @"点赞失败";
//                }else{
//                    resultStr = @"删除点赞失败";
//                }
//            }
            
            /*
             NSString* resultStr = nil;
             if (yesOrNo) {
             resultStr = @"收藏失败";
             }else{
             resultStr = @"删除收藏失败";
             }
             */
            callback(nil);
           // [self  hudViewShowWithStr:resultStr andTime:1];
        }
    }];
}

#pragma mark  帖子或回复举报
-(void)postReportPostOrPostReplyWithPlate:(ZZPlateTypeInfo*)plate  andPostId:(NSUInteger)postId  andReply:(NSUInteger)replyId  andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:4];
    [params  setObject:self.token forKey:@"token"];
    [params  setObject:plate.areaType forKey:@"areaType"];
    [params  setObject:plate.type forKey:@"type"];
    if (replyId) {
        [params  setObject:@(replyId) forKey:@"replysRelationId"];
    }else if(postId){
        [params  setObject:@(postId) forKey:@"publishRelationId"];
    
    }
    [self  postByApiName:@"report/addReport" andParams:params andCallBack:^(id obj) {
        ZZLog(@"举报:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            callback(@"");
            [self  hudViewShowWithStr:@"举报成功" andTime:1];
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
               tip =@"举报失败";
            }
            
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}
#pragma mark ---------------------宝宝----------------------
#pragma mark   添加宝宝，或者更新宝宝信息
-(void)postAddBabyOrUpdateBabyInfoWithImage:(UIImage*)image  andBirthday:(NSString*)birthday  andNick:(NSString*)nick  andSex:(NSInteger)sex  andBabyId:(NSUInteger)babyId  andback:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    if (babyId) {
        [params  setObject:@(babyId) forKey:@"id"];
    }
    if (birthday.length) {
        [params  setObject:birthday forKey:@"brithday"];
    }
    if (nick.length) {
         [params  setObject:nick forKey:@"babyNick"];
    }
    if (sex) {
        [params  setObject:@(sex) forKey:@"babySex"];
    }
    
    [params  setObject:self.token forKey:@"token"];
     [netHud  hudShow];
    [self  postImageByApiName:@"baby/addOrUpdateBaby" andImageName:@"image" andParams:params andImage:image andBack:^(id obj) {
        ZZLog(@"创建宝宝:%@",obj);
        [netHud   hudHide];
        if ([[obj objectForKey:@"code"]boolValue] == 1) {
            NSDictionary* context = [obj objectForKey:@"context"];
            if ([context isKindOfClass:[NSDictionary class]]&&context.count) {
                NSString* attention = [context objectForKey:@"attention"];
                NSString* babyCount = [context objectForKey:@"babyCount"];
                NSArray* list = [context objectForKey:@"list"];
                NSMutableDictionary* backDic = [NSMutableDictionary  dictionaryWithCapacity:3];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZBaby*  post = [ZZJsonParse  parseBabyInfoByDic:dic];
                        if (post) {
                            [array  addObject:post];
                        }
                    }
                    [backDic  setObject:array forKey:@"list"];
                }
                if (attention) {
                    [backDic  setObject:attention forKey:@"attention"];
                }
                if (babyCount) {
                    [backDic  setObject:babyCount forKey:@"babyCount"];
                }
                
                callback(backDic);
                
            }else{
                callback(nil);
            }
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}
#pragma mark   删除宝宝
-(void)postDeleteBabyWithBabyId:(NSUInteger)babyId  andBack:(CallBack)callback{
    [netHud  hudShow  ];
    NSDictionary*  params = @{@"token":self.token,@"id":@(babyId)};
    [self  postByApiName:@"baby/deleteBaby" andParams:params andCallBack:^(id obj) {
        ZZLog(@"删除宝宝:%@",obj);
        [netHud  hudHide];
        if ([[obj  objectForKey:@"code"]boolValue]) {
            callback(@"");
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"删除失败";
            }
            
            callback(nil);
             [self  hudViewShowWithStr:tip andTime:1];
        }
        
    }];
}
#pragma mark   查找宝宝详情
-(void)postFindBabyDetailInfoWithBabyId:(NSUInteger)babyId   andBack:(CallBack)callback{
    NSDictionary*  params = @{@"token":self.token,@"id":@(babyId)};
    [self  postByApiName:@"baby/findByBabyId" andParams:params andCallBack:^(id obj) {
        ZZLog(@"查找宝宝详情:%@",obj);
    }];
}
#pragma mark   查询宝宝板块信息
-(void)postFindBabyPlateInfoAndBack:(CallBack)callback{
    NSDictionary*  params = @{@"token":self.token};
    [netHud  hudShow];
    [self  postByApiName:@"baby/findByBaby" andParams:params andCallBack:^(id obj) {
        ZZLog(@"查询宝宝板块信息:%@",obj);
        [netHud  hudHide];
        if ([[obj objectForKey:@"code"]boolValue] == 1) {
            NSDictionary* context = [obj objectForKey:@"context"];
            if ([context isKindOfClass:[NSDictionary class]]&&context.count) {
                NSString* attention = [context objectForKey:@"attention"];
                NSString* babyCount = [context objectForKey:@"babyCount"];
                NSArray* list = [context objectForKey:@"list"];
                NSMutableDictionary* backDic = [NSMutableDictionary  dictionaryWithCapacity:3];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZBaby*  post = [ZZJsonParse  parseBabyInfoByDic:dic];
                        if (post) {
                            [array  addObject:post];
                        }
                    }
                    [backDic  setObject:array forKey:@"list"];
                }
                if (attention) {
                    [backDic  setObject:attention forKey:@"attention"];
                }
                if (babyCount) {
                    [backDic  setObject:babyCount forKey:@"babyCount"];
                }
                
                callback(backDic);
                
            }else{
                callback(nil);
                 [self  hudViewShowWithStr:@"没有更多内容" andTime:3];
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}


#pragma mark   添加宝宝日志
-(void)postAddBabyGrowingLogWithBabyId:(NSUInteger)babyId   andImageArray:(NSArray*)images  andBack:(CallBack)callback{
    [netHud  hudShow];
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params  setObject:@(babyId) forKey:@"babyRelationId"];
    [params  setObject:self.token forKey:@"token"];
    [params  setObject:@(images.count) forKey:@"imageCount"];
    NSMutableArray*  marray = [NSMutableArray  arrayWithCapacity:images.count];
    for (int i = 0 ; i<images.count; i++) {
        ZZImageAndDescribe*  iad = images[i];
        if(!iad.decribeStr){
            iad.decribeStr =@"";
        }
        [params  setObject:iad.decribeStr forKey:[NSString  stringWithFormat:@"context%d",i]];
        [marray  addObject:iad.showImage];
    }
   
    [self  postImageByApiName:@"babyGrowing/addBabyGrowing" andParams:params andImagesArray:marray andImageName:@"image" andBack:^(id obj) {
        ZZLog(@"添加宝宝日志:%@",obj);
     [netHud  hudHide];
        if ([[obj objectForKey:@"code"]boolValue] == 1) {
            
            NSArray* context = [obj objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZBabyDiaryInfo* diaryInfo = [ZZJsonParse parseBabyDiaryByDic:dic];
                    if (diaryInfo) {
                        [array  addObject:diaryInfo];
                    }
                }
                
                callback(array);
            }else{
                callback(nil);
            }
  
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
     
    }];
}
#pragma mark  删除宝宝日志
-(void)postDeleteBabyGrowingLogWithBabyId:(NSUInteger)babyId  andDiaryId:(NSUInteger)diaryId  andBack:(CallBack)callback{
    
    if(babyId <= 0 && diaryId <= 0){
        callback(nil);
        [self  hudViewShowWithStr:@"删除失败，请稍后重试" andTime:1];
        return;
    }
    NSDictionary*  params = @{@"babyRelationId":@(babyId),@"id":@(diaryId),@"token":self.token};
    [self  postByApiName:@"babyGrowing/deleteBabyGrowing" andParams:params andCallBack:^(id obj) {
        ZZLog(@"删除宝宝日志:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            callback(@"");
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"删除失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
        
    }];
}
#pragma mark  宝宝成长日志列表
-(void)postFindBabyGrowingLogListWithBabyId:(NSUInteger)babyId  andDiaryId:(NSUInteger)diaryId  andUpDown:(NSUInteger)upDown  andBack:(CallBack)callback{
    
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params  setObject:@(babyId) forKey:@"babyRelationId"];
    [params  setObject:self.token forKey:@"token"];
    if (diaryId&&upDown) {
        [params  setObject:@(diaryId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    
    [self  postByApiName:@"babyGrowing/findByBabyGrowing" andParams:params andCallBack:^(id obj) {
        ZZLog(@"宝宝成长日志列表:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue] == 1) {
            NSArray* context = [obj objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZBabyDiaryInfo* babyBirthdayInfo = [ZZJsonParse parseBabyDiaryByDic:dic];
                    if (babyBirthdayInfo) {
                        [array  addObject:babyBirthdayInfo];
                    }
                }
    
                callback(array);
            }else{
                callback([NSArray  array]);
                if (upDown&&diaryId) {
                         [self  hudViewShowWithStr:@"没有更多内容" andTime:3];
                }
            
            }
           
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
              
        
    }];
}
#pragma mark ---------------------同龄----------------------


#pragma mark 同龄板块按类型查找竖版
-(void)postFindStarConstellationPostListsWithPlate:(ZZPlateTypeInfo*)plate andPostId:(NSInteger)postId  andUpDown:(NSUInteger)upDown  andBack:(CallBack)callback{
    
    NSString*  childApiName = nil;
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3 ];
    [params  setObject:plate.type forKey:@"type"];
    [params  setObject:self.token forKey:@"token"];
  
    [params  setObject:@(plate.plateId) forKey:@"plateId"];
    if ([plate.areaType  isEqualToString:@"WONDERFUL"]) {
        childApiName = @"FindPublish";
    }else{
         childApiName = @"FindStar";
          [params  setObject:plate.areaType forKey:@"areaType"];
    }
    if (postId&&upDown) {
        [params  setObject:@(postId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self  postByApiName:[NSString   stringWithFormat:@"%@%@",plate.interface,childApiName]   andParams:params andCallBack:^(id obj) {
      
        ZZLog(@"同龄查找帖子列表:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]==1) {
            NSDictionary* context = [obj  objectForKey:@"context"];
            
            if ([context isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSString*  attention = [context  objectForKey:@"attention"];
                NSString*  count = [context  objectForKey:@"count"];
                NSArray* list = [context  objectForKey:@"list"];
     
                NSMutableDictionary* backDic = [NSMutableDictionary  dictionaryWithCapacity:3];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZPost*  post = [ZZJsonParse  parseSameAgeVerticalVersionPostInfoByDic:dic];
                        if (post) {
                            [array  addObject:post];
                        }
                    }
                    [backDic  setObject:array forKey:@"list"];
                }
                if (attention) {
                    [backDic  setObject:attention forKey:@"attention"];
                }
                if (count) {
                    [backDic  setObject:count forKey:@"count"];
                }
             
               
                   callback(backDic);

            }else{
                callback([NSArray  array]);
                if (postId&&upDown) {
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:1];

                }
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
    
}
#pragma mark   同龄板块添加帖子
-(void)postAddNewStarPostWithPlate:(ZZPlateTypeInfo*)plate  andTitle:(NSString*)title  andContent:(NSString*)content   andImageArray:(NSArray*)imageArray andBack:(CallBack)callback{
     NSString*  childApiName = nil;
    NSMutableDictionary*  params =[NSMutableDictionary  dictionaryWithCapacity:6];
    [params  setObject:self.token forKey:@"token"];
    [params  setObject:plate.type forKey:@"type"];
    [params  setObject:title forKey:@"title"];
    [params  setObject:@(imageArray.count) forKey:@"count"];
   [params  setObject:@(plate.plateId) forKey:@"plateId"];
    if (content.length) {
        [params  setObject:content forKey:@"context"];
    }
    
 // @{@"token":self.token,@"type":plate.type,@"title":title,@"context":content,@"count":@(imageArray.count),@"areaType":plate.areaType,@"plateId":@(plate.plateId)};
     NSMutableArray*  mimagesArray = [NSMutableArray  arrayWithCapacity:imageArray.count];
    if ([plate.areaType  isEqualToString:@"WONDERFUL"]) {
        childApiName = @"AddPublish";
        for (int i = 0; i<imageArray.count; i++) {
            ZZImageAndDescribe*  imageAD = imageArray[i];
            if (!imageAD.decribeStr) {
                imageAD.decribeStr = @"";
            }
            [params  setObject:imageAD.decribeStr forKey:[NSString  stringWithFormat:@"context%d",i]];
            [mimagesArray  addObject:imageAD.showImage];
        }

    }else{
        childApiName = @"AddStar";
        [params  setObject:plate.areaType forKey:@"areaType"];
        //[params  setObject:content forKey:@"context"];
        mimagesArray = [imageArray copy];
    }
   
  [netHud  hudShow];
    [self  postImageByApiName:[NSString   stringWithFormat:@"%@%@",plate.interface,childApiName] andParams:params andImagesArray:mimagesArray  andImageName:@"image"  andBack:^(id obj) {
        ZZLog(@" 发布新帖子:%@",obj);
        [netHud  hudHide];
        if ([[obj  objectForKey:@"code"]boolValue]==1) {
            NSDictionary* context = [obj  objectForKey:@"context"];
            [self  hudViewShowWithStr:@"发布成功" andTime:1];
            if ([context isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSString*  attention = [context  objectForKey:@"attention"];
                NSString*  count = [context  objectForKey:@"count"];
                NSArray* list = [context  objectForKey:@"list"];
   
                NSMutableDictionary* backDic = [NSMutableDictionary  dictionaryWithCapacity:3];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZPost*  post = [ZZJsonParse  parseSameAgeVerticalVersionPostInfoByDic:dic];
                        if (post) {
                            [array  addObject:post];
                        }
                    }
                    [backDic  setObject:array forKey:@"list"];
                }
                if (attention) {
                    [backDic  setObject:attention forKey:@"attention"];
                }
                if (count) {
                    [backDic  setObject:count forKey:@"count"];
                }
            
               callback(backDic);
                
            }else{
                callback(nil);
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}

#pragma mark   查询帖子详情
-(void)postFindStarConstellationPostDetialInfoWithPlate:(ZZPlateTypeInfo*)plate     andPostId:(NSUInteger)postId  andUserId:(NSUInteger)userId  andBack:(CallBack)callback{
    NSString*  childApiName = nil;
    NSMutableDictionary*  params =[NSMutableDictionary  dictionaryWithCapacity:4];
    [params  setObject:@(postId) forKey:@"id"];
    [params  setObject:@(userId) forKey:@"userId"];
    [params  setObject:self.token forKey:@"token"];
    if ([plate.areaType  isEqualToString:@"WONDERFUL"]) {
        childApiName = @"FindWonderfulDetails";
         [params  setObject:plate.type forKey:@"type"];
    }else if([plate.areaType  isEqualToString:@"HELP"]){
        childApiName = @"FindByCaseId";
      //  [params  setObject:plate.areaType forKey:@"areaType"];
    }else{
        childApiName = @"FindStarDetails";
         [params  setObject:plate.type forKey:@"type"];
        [params  setObject:plate.areaType forKey:@"areaType"];
    }

    [self  postByApiName:[NSString   stringWithFormat:@"%@%@",plate.interface,childApiName] andParams:params andCallBack:^(id obj) {
        ZZLog(@"帖子详情:%@",obj);
        
        if ([[obj  objectForKey:@"code"]boolValue]==1) {
            NSDictionary*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
                ZZPost* post = nil;
                if([plate.areaType  isEqualToString:@"HELP"]){
                    post = [ZZJsonParse  parseCaseListByDic:context];
                }else{
                    post = [ZZJsonParse  parseSameAgeVerticalVersionPostInfoByDic:context];
                }
                    callback(post);
            }else{
                callback(nil);
       
                /*
                 张亮亮 0513
                 */
                 [self  hudViewShowWithStr:@"此贴子已删除" andTime:1];
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            callback(nil);
             [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}

#pragma mark   添加回复
-(void)postAddStarConstellationPostReplyWithPlate:(ZZPlateTypeInfo* )plate  andPostId:(NSUInteger)postId  andReply:(ZZReplayInformation*)parentReply  andContent:(NSString*)content  andImage:(UIImage*)image andSort:(NSUInteger)sort   andBack:(CallBack)callback{
    
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:4];
    if ([plate.areaType  isEqualToString:@"HELP"]) {
        
    }else{
        [params  setObject:plate.areaType forKey:@"areaType"];
        [params  setObject:plate.type forKey:@"type"];
    }
    [params   setObject:self.token forKey:@"token"];
    [params  setObject:@(postId) forKey:@"id"];
    //if (sort == 1) {
        [params  setObject:@(sort) forKey:@"sort"];
   // }
    if (content.length) {
        [params   setObject:content forKey:@"context"];
    }
    if(parentReply){
        [params  setObject:@(parentReply.replayId) forKey:@"parentReplyId"];
//        [params  setObject:@(parentReply.user.userId) forKey:@"userId"];
    }
    [netHud  hudShow];
    [self  postImageByApiName:[NSString   stringWithFormat:@"%@AddReplys",plate.interface] andImageName:@"image" andParams:params andImage:image andBack:^(id obj) {
        ZZLog(@"添加回复:%@",obj);
        [netHud  hudHide];
        if ([[obj  objectForKey:@"code"]boolValue]) {
            [self  hudViewShowWithStr:@"回复成功" andTime:1];
            NSArray*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  marray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary*  dic in context) {
                    ZZReplayInformation*  reply = [ZZJsonParse  parseSameAgePostReplyInfoByDic:dic];
                    if (reply) {
                        [marray  addObject:reply];
                    }
                }
                callback(marray);
            }else{
                callback(nil);
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"添加回复失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
    
}

#pragma mark 查询回复
-(void)postFindStarConstellationPostReplyWithPlate:(ZZPlateTypeInfo*)plate  andPostId:(NSUInteger)postId  andUpdown:(NSUInteger)upDown  andReplyId:(NSUInteger)replyId  andSort:(NSUInteger)sort   andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:4];
    
    [params   setObject:self.token forKey:@"token"];
    [params  setObject:@(postId) forKey:@"id"];
  
    [params  setObject:@(sort) forKey:@"sort"];
    //是否是案例
    if ([plate.areaType  isEqualToString:@"HELP"]) {
        
    }else{
        [params  setObject:plate.areaType forKey:@"areaType"];
        [params  setObject:plate.type forKey:@"type"];
    }
    if (replyId&&upDown) {
        [params   setObject:@(replyId) forKey:@"replyId"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
  
    [self  postByApiName:[NSString   stringWithFormat:@"%@FindReplys",plate.interface] andParams:params andCallBack:^(id obj) {
        
        ZZLog(@"查询回复:%@",obj);
       
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSArray*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  marray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary*  dic in context) {
                    ZZReplayInformation*  reply = [ZZJsonParse  parseSameAgePostReplyInfoByDic:dic];
                    if (reply) {
                        [marray  addObject:reply];
                    }
                }
                    callback(marray);
                
            }else{
                callback([NSArray  array]);
                if (upDown&&replyId) {
                    [self  hudViewShowWithStr:@"没有更多回复" andTime:1];
                }
            }
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"查询回复失败";
            }
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];

}

#pragma mark   删除回复
-(void)postDeleteStarConstellationPostReplyWithPlate:(ZZPlateTypeInfo*)plate   andReplyId:(NSUInteger)replyId  andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params   setObject:self.token forKey:@"token"];
    [params   setObject:@(replyId) forKey:@"replyId"];
    //是否是案例
    if ([plate.areaType  isEqualToString:@"HELP"]) {
        
    }else{
        [params  setObject:plate.areaType forKey:@"areaType"];
        [params  setObject:plate.type forKey:@"type"];
    }
    [self  postByApiName:[NSString  stringWithFormat:@"%@DeleteReplys",plate.interface] andParams:params andCallBack:^(id obj) {
        if ([[obj  objectForKey:@"code"]boolValue]) {
            [self  hudViewShowWithStr:@"回复删除成功" andTime:1];
            callback(@"");
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"回复删除失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:3];
        }
        ZZLog(@"删除回复:%@",obj);
    }];
}

#pragma mark  删除帖子
-(void)postDeleteStarConstellationPostWithPlate:(ZZPlateTypeInfo*)plate    PostId:(NSUInteger)postId  andBack:(CallBack)callback{
    
    NSString*  childApiName = nil;
    NSMutableDictionary*  params =[NSMutableDictionary  dictionaryWithCapacity:3];
    
    [params  setObject:@(postId) forKey:@"id"];

    [params  setObject:self.token forKey:@"token"];
    [params  setObject:plate.type forKey:@"type"];
    
    if ([plate.areaType  isEqualToString:@"WONDERFUL"]) {
        childApiName = @"DeleteWonderful";
    }else{
        childApiName = @"DeleteStar";
        [params  setObject:plate.areaType forKey:@"areaType"];
    }
//    NSDictionary*  params = @{@"type":plate.type,@"areaType":plate.areaType,@"id":@(postId),@"token":self.token};
    [self  postByApiName:[NSString   stringWithFormat:@"%@%@",plate.interface,childApiName] andParams:params andCallBack:^(id obj) {
        ZZLog(@"删除帖子:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            
            callback(@"");
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"删除失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:3];
        }
    }];
}
#pragma mark -----------------------关注 收藏----------------------
#pragma mark 这个用户是否关注
- (void)postFindThisUserAttention:(NSUInteger)userId andBack:(CallBack)callback{
    NSDictionary *params = @{@"userId":@(userId),@"token":self.token};
    [self  postByApiName:@"user/findCurrentUser" andParams:params andCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSDictionary *dic = [obj objectForKey:@"context"];
            callback(dic);
        }else{
            callback(nil);
        }
        ZZLog(@",,,%@",obj);
    }];
}
#pragma mark   关注人发布更多
-(void)postFindAttentionUserMorePublishListWithUserId:(NSUInteger)userId andPostId:(NSUInteger)postId andUpDOwn:(NSUInteger)upDown andTypeNumber:(NSUInteger)typeNumber andBack:(CallBack)callback{
    
    NSString*  apiName = nil;
    switch (typeNumber) {
        case 0:
            apiName = @"publish/findByWonderfulPublish";
            break;
        case 1:
            apiName = @"publish/findByOtherStarPublish";
            break;
        
        case 2:
            apiName = @"publish/findByCityPublish";
            break;
            
    }
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:4];
    [params  setObject:self.token forKey:@"token"];
    if (userId) {
        [params  setObject:@(userId) forKey:@"userId"];
    }else{
        [params  setObject:@(1) forKey:@"code"];
    }
    if (upDown&&postId) {
        [params  setObject:@(postId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }

    [self  postByApiName:apiName andParams:params andCallBack:^(id obj) {
        ZZLog(@"发布更多:%@",obj);

        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSDictionary*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSArray*  list = [context  objectForKey:@"list"];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  backArray = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZPost*  post = [ZZJsonParse  parseSameAgeVerticalVersionPostInfoByDic:dic];
                        if (post) {
                            [backArray addObject:post];
                        }
                        
                    }
                    
                    callback(backArray);
                }else{
                    callback([NSArray  array]);
                    if (upDown&&postId) {
                        [self  hudViewShowWithStr:@"没有更多内容" andTime:3];
                    }
                    
                }
            }else{
                callback(nil);
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }

    }];
}
#pragma mark   我的收藏
-(void)postFindMyStorePostTithPostId:(NSUInteger)postId  andUpDown:(int)upDown andTypeNumber:(NSUInteger)typeNumber andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params  setObject:self.token forKey:@"token"];
    if (postId&&upDown) {
        [params  setObject:@(postId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    NSString*  apiName = nil;
    switch (typeNumber) {
        case 0:
            apiName = @"storeUp/findMyWonderfulStore";
            break;
        case 1:
            apiName = @"storeUp/findByMyStarStore";
            break;
            
        case 2:
            apiName = @"storeUp/findByMyCityStore";
            break;
        case 3:
            apiName = @"storeUp/findByMyOtherCaseStore";
            break;
        default:
            apiName = @"publish/findByCityPublish";
            break;
    }
    
    [self  postByApiName:apiName andParams:params andCallBack:^(id obj) {
        ZZLog(@"收藏更多:%@",obj);
        

 
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSDictionary*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSArray*  list = [context  objectForKey:@"list"];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  backArray = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZPost*  post;
                        if (typeNumber==3) {
                            post = [ZZJsonParse  parseCaseListByDic:dic];
                            
                        }else{
                            post= [ZZJsonParse  parseSameAgeVerticalVersionPostInfoByDic:dic];
                        }
                        if (post) {
                            [backArray addObject:post];
                        }
                        
                    }
                    callback(backArray);
                }else{
                    callback([NSArray  array]);
                    if (upDown&&postId) {
                        [self  hudViewShowWithStr:@"没有更多内容" andTime:2];
                    }
                }
            }else{
                callback(nil);
             
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }

    }];
}
#pragma mark  我的关注
-(void)postFindMyAttentionByUserId:(NSUInteger)userId  andUpDown:(int)upDown  andBack:(CallBack)callback{
    NSMutableDictionary*  params  = [NSMutableDictionary   dictionaryWithCapacity:1];
    [params  setObject:self.token forKey:@"token"];
    if (upDown&&userId) {
        [params  setObject:@(userId) forKey:@"userId"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self  postByApiName:@"attention/findAttentionUser" andParams:params andCallBack:^(id obj) {
        ZZLog(@"我的关注人列表:%@",obj);
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//                           [NSThread sleepForTimeInterval:5];
//                    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSArray*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  backArray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary*   dic in context) {
                    ZZUser*  user = [ZZJsonParse  parseAttentionUserByDic:dic];
                    if (user) {
                         [ZZRongUserInfo  uploadUserInfoWithUserId:user.uToken andNick:user.nick andImageurl:user.mbpImageinfo.smallImagePath];
                        [backArray  addObject:user];
                    }
                }
                callback(backArray);
            }else{
                callback([NSArray array]);
                if (upDown&&userId) {
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:2];
                }
                
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
//                    });
//                });

    }];
}

#pragma mark ---------------------专家 达人----------------------
#pragma mark 专家(名医)
-(void)postFindExpertByUserId:(NSInteger)userId andUpDown:(int)upDown andType:(int)type  andCity:(int)city andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(city) forKey:@"city"];
    if (userId&&upDown) {
        [params   setObject:@(userId) forKey:@"userId"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self postByApiName:@"expert/findExpert" andParams:params andCallBack:^(id obj) {
            ZZLog(@"专家列表:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
            
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                NSMutableArray*  marray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZExpert* expertInfo = [ZZJsonParse parseExpertListByDic:dic];
                    if (expertInfo) {
                        [marray addObject:expertInfo];
                    }
                }
                callBack(marray);
            }else{
                callBack(nil);
                if (upDown&&userId) {
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:2];
                }
            }
       
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callBack(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
    
}

#pragma mark 已关注和推荐专家列表
-(void)postFindRecommendExpertByUserId:(NSInteger)userId andRecommend:(int)recommend andUpDown:(int)upDown andCity:(int)city andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(recommend) forKey:@"recommend"];
    [params setObject:@(city) forKey:@"city"];
    if (userId&&upDown) {
        [params   setObject:@(userId) forKey:@"userId"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self postByApiName:@"expert/findAttentionExpert" andParams:params andCallBack:^(id obj) {
        ZZLog(@"已关注和推荐专家列表:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
           
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                 NSMutableArray*  marray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZExpert* expertInfo = [ZZJsonParse parseExpertListByDic:dic];
                    if (expertInfo) {
                        [marray addObject:expertInfo];
                    }
                }
                        callBack(marray);
            }else{
                callBack([NSArray  array]);
                if(upDown&&userId){
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:3];
                }
                
            }

        }else{
            callBack(nil);
        }
    }];
}

//#pragma mark ---------------------专家id查询专家信息----------------------
//-(void)postFindExpertInformationByuserId:(NSInteger)userId andBack:(CallBack)callBack{
//    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
//    [params setObject:self.token forKey:@"token"];
//    [params   setObject:@(userId) forKey:@"userId"];
//    [self postByApiName:@"expert/findByIdFromExpert" andParams:params andCallBack:^(id obj) {
//        ZZLog(@"专家id查询专家信息:%@",obj);
//    }];
//}

#pragma mark 专家行程
-(void)postExpertJourneyByuserId:(NSInteger)userId andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params setObject:self.token forKey:@"token"];
    [params   setObject:@(userId) forKey:@"userId"];
    [self postByApiName:@"expert/expertScheduling" andParams:params andCallBack:^(id obj) {
        ZZLog(@"专家行程:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSDictionary* context = [obj objectForKey:@"context"];
            NSString* string = [context objectForKey:@"context"];
            callBack(string);
        }else{
            callBack(nil);
        }
        
    }];
}


#pragma mark 更新专家是否在线
-(void)postExpertOnLineByUserId:(NSInteger)userId andOnLine:(int)online andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params setObject:self.token forKey:@"token"];
    [params   setObject:@(userId) forKey:@"userId"];
    [params   setObject:@(online) forKey:@"online"];
    [self postByApiName:@"expert/updateExpert" andParams:params andCallBack:^(id obj) {
        ZZLog(@"更新专家是否在线:%@",obj);
    }];
}


#pragma mark 达人类型
-(void)postFindSuperStarTypeByType:(int)type andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [self postByApiName:@"eredar/eredarFindType" andParams:params andCallBack:^(id obj) {
        ZZLog(@"达人类型:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
          
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                  NSMutableArray* marray = [NSMutableArray arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZPlateTypeInfo* plateInfo = [ZZJsonParse parseSuperStarAndExpertTypeByDic:dic];
                    if (plateInfo) {
                        [marray addObject:plateInfo];
                    }
               
                }
                     callBack(marray);
            }else{
                callBack(nil);
            }
        }else{
            callBack(nil);
        }
    }];
}

#pragma mark 关注和推荐达人用户
-(void)postFindEreDarAttentionByRecommend:(int)recommend andUserId:(NSInteger)userId andUpDown:(int)upDown andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(recommend) forKey:@"recommend"];
    if (userId&&upDown) {
        [params   setObject:@(userId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self postByApiName:@"eredar/eredarFindAttentionUser" andParams:params andCallBack:^(id obj) {
        ZZLog(@"关注和推荐达人用户:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
            NSMutableArray* marray = [NSMutableArray arrayWithCapacity:context.count];
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                for (NSDictionary* dic in context) {
                    ZZUser* userInfo = [ZZJsonParse parseSuperStarListByDic:dic];
                    if (userInfo) {
                        [marray addObject:userInfo];
                    }
                    
                }
                callBack(marray);
            }else{
                callBack([NSArray  array]);
                if (upDown&&userId) {
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:2];
                }
                
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callBack(nil);
            [self  hudViewShowWithStr:tip andTime:2];
        }
    }];
}

#pragma mark 按类型查达人
-(void)postFindSuperStarByType:(int)type anduserId:(NSInteger)userId andUpDown:(int)upDown andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    if (userId&&upDown) {
        [params   setObject:@(userId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self postByApiName:@"eredar/eredarFindByTypeUser" andParams:params andCallBack:^(id obj) {
        ZZLog(@"按类型查达人:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
         
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                   NSMutableArray* marray = [NSMutableArray arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZUser* userInfo = [ZZJsonParse parseSuperStarListByDic:dic];
                    if (userInfo) {
                        [marray addObject:userInfo];
                    }
                    
                }
              callBack(marray);
            }else{
                callBack([NSArray  array]);
                if (upDown&&userId) {
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:2];
                }
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"请求失败";
            }
            
            callBack(nil);
            [self  hudViewShowWithStr:tip andTime:2];
        }
    }];
}

#pragma mark 达人申请
-(void)postFindSuperStarByType:(int)type andContext:(NSString*)context andPhone:(NSString*)phone andWeiXin:(NSString*)weixin andQq:(NSString*)qq andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:context forKey:@"context"];
    [params setObject:phone forKey:@"phone"];
    if(weixin.length){
        [params setObject:weixin forKey:@"weixin"];
    }
    if (qq.length) {
           [params setObject:qq forKey:@"qq"];
    }
    
 
    [self postByApiName:@"eredar/eredarAddEredar" andParams:params andCallBack:^(id obj) {
        ZZLog(@"达人申请:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            BOOL succeed = [[obj objectForKey:@"code"]boolValue];
            callBack(@(succeed));
            [self  hudViewShowWithStr:@"提交申请成功" andTime:2];
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"提交申请失败";
            }
            
            callBack(nil);
            [self  hudViewShowWithStr:tip andTime:2];
        }
            
    }];
}

#pragma mark----------------------搜索---------------------------

#pragma mark 搜索
-(void)postSearchByType:(int)type andSearchContent:(NSString*)str  andId:(NSUInteger)searchId  andUpDown:(int)upDown  andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params  setObject:self.token forKey:@"token"];
    [params  setObject:@(type) forKey:@"type"];
    [params  setObject:str forKey:@"name"];
    if (upDown&&searchId) {
        [params  setObject:@(searchId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    
    [self  postByApiName:@"search/searchByName" andParams:params andCallBack:^(id obj) {
        ZZLog(@"搜索:%@",obj);
        if ([[obj   objectForKey:@"code"]boolValue]) {
            NSArray*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  backArray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary * dic in context) {
                    if (type ==1) {
                        ZZUser *  user = [ZZJsonParse  parseAttentionUserByDic:dic];
                        if (user) {
                            [backArray  addObject:user];
                        }
                    }else if(type==2){
                        ZZPost*  post = [ZZJsonParse   parseSameAgeVerticalVersionPostInfoByDic:dic];
                        if (post) {
                            [backArray  addObject:post];
                        }
                    }else{
                        ZZPost*   casePost = [ZZJsonParse   parseCaseListByDic:dic];
                        if (casePost) {
                            [backArray  addObject:casePost];
                        }
                    }
                }
                
               callback(backArray);
            }else
            {
                callback([NSArray  array]);
                if(upDown&&searchId){
                     [self  hudViewShowWithStr:@"没有更多内容" andTime:1];
                }
               
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"查找失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}
#pragma mark----------------------------案例--------------------------
#pragma mark 案例列表
-(void)postFindCaseByCaseId:(NSInteger)caseId  andPlateType:(ZZPlateTypeInfo*)plateType andUpDown:(int)upDown andBack:(CallBack)callBack{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:3];
    [params setObject:self.token forKey:@"token"];
    [params setObject:plateType.type forKey:@"caseType"];
    if (caseId&&upDown) {
        [params   setObject:@(caseId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self postByApiName:@"caseThroughTrain/caseThroughTrainFindCaseList" andParams:params andCallBack:^(id obj) {
        ZZLog(@"案例列表:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
            
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                NSMutableArray* marray = [NSMutableArray arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZPost* caseInfo = [ZZJsonParse parseCaseListByDic:dic];
                    caseInfo.postPlateType = plateType;
                    if (caseInfo) {
                        [marray addObject:caseInfo];
                    }
                }
                callBack(marray);
            }else{
                callBack([NSArray  array]);
                if(upDown&&caseId){
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:1];
                }
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"案例查找失败";
            }
            
            callBack(nil);
             [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}
#pragma mark 案例类型
-(void)postFindCaseTypeBack:(CallBack)callBack{
    [self postByApiName:@"caseThroughTrain/caseThroughTrainFindCaseType" andParams:nil andCallBack:^(id obj) {
        ZZLog(@"案例类型:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
            
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                NSMutableArray*  marray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary* dic in context) {
                    ZZPlateTypeInfo* caseTypeInfo = [ZZJsonParse parseCaseTypeByDic:dic];
                    if (caseTypeInfo) {
                        [marray addObject:caseTypeInfo];
                        //[marray  addObject:caseTypeInfo];
                        
                    }
                }
        
              callBack(marray);
     
            }else {
                callBack(nil);
    
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"查询失败";
            }
            
            callBack(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}

/*
#pragma mark ---------------------精彩专区----------------------

#pragma mark   精彩专区添加帖子
-(void)postAddNewWonderfulPostWithPlate:(ZZPlateTypeInfo*)plate  andTitle:(NSString*)title andImageArray:(NSArray*)imageArray andBack:(CallBack)callback{
    
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:6];
    [params  setObject:self.token forKey:@"token"];
    [params  setObject:title forKey:@"title"];
    [params  setObject:@(imageArray.count) forKey:@"count"];
    [params  setObject:plate.type forKey:@"type"];
    [params setObject:@(plate.plateId) forKey:@"plateId"];
   
    NSMutableArray*  mimagesArray = [NSMutableArray  arrayWithCapacity:imageArray.count];
    for (int i = 0; i<imageArray.count; i++) {
        ZZImageAndDescribe*  imageAD = imageArray[i];
        if (!imageAD.decribeStr) {
            imageAD.decribeStr = @"";
        }
        [params  setObject:imageAD.decribeStr forKey:[NSString  stringWithFormat:@"context%d",i]];
        [mimagesArray  addObject:imageAD.showImage];
    }
    
    [self  postImageByApiName:[NSString   stringWithFormat:@"%@AddPublish",plate.interface] andParams:params andImagesArray:mimagesArray  andImageName:@"image"  andBack:^(id obj) {
        ZZLog(@" 精彩专区发布新帖子:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]==1) {
            NSDictionary* context = [obj  objectForKey:@"context"];
            
            if ([context isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSString*  attention = [context  objectForKey:@"attention"];
                NSString*  count = [context  objectForKey:@"count"];
                NSArray* list = [context  objectForKey:@"list"];
                ZZLog(@",,,,%@",count);
                NSMutableDictionary* backDic = [NSMutableDictionary  dictionaryWithCapacity:3];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZPost*  post = [ZZJsonParse  parseWonderFulPostInfoByDic:dic];
                        if (post) {
                            [array  addObject:post];
                        }
                    }
                    [backDic  setObject:array forKey:@"list"];
                }
                if (attention) {
                    [backDic  setObject:attention forKey:@"attention"];
                }
                if (count) {
                    [backDic  setObject:count forKey:@"count"];
                }
                
                callback(backDic);
                
            }else{
                callback(nil);
            }
        }else{
            callback(nil);
            [self  hudViewShowWithStr:@"请求失败" andTime:1];
        }
    }];
}

#pragma mark   精彩专区查询帖子列表
-(void)postFindWonderFulPostWithPlate:(ZZPlateTypeInfo*)plate andPostId:(NSInteger)postId  andUpDown:(NSUInteger)upDown  andBack:(CallBack)callback{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params setObject:self.token forKey:@"token"];
    [params setObject:@(plate.plateId) forKey:@"plateId"];
    [params setObject:plate.type forKey:@"type"];
    if (postId&&upDown) {
        [params  setObject:@(postId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    
    [self postByApiName:[NSString stringWithFormat:@"%@FindPublish",plate.interface] andParams:params andCallBack:^(id obj) {
        ZZLog(@"精彩专区查找帖子列表:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]==1) {
            NSDictionary* context = [obj  objectForKey:@"context"];
            
            if ([context isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSString*  attention = [context  objectForKey:@"attention"];
                NSString*  count = [context  objectForKey:@"count"];
                NSArray* list = [context  objectForKey:@"list"];
                ZZLog(@",,,,%@",count);
                NSMutableDictionary* backDic = [NSMutableDictionary  dictionaryWithCapacity:3];
                if ([list  isKindOfClass:[NSArray  class]]&&list.count) {
                    NSMutableArray*  array = [NSMutableArray  arrayWithCapacity:list.count];
                    for (NSDictionary*  dic in list) {
                        ZZPost*  post = [ZZJsonParse  parseWonderFulPostInfoByDic:dic];
                        if (post) {
                            [array  addObject:post];
                        }
                    }
                    [backDic  setObject:array forKey:@"list"];
                }
                if (attention) {
                    [backDic  setObject:attention forKey:@"attention"];
                }
                if (count) {
                    [backDic  setObject:count forKey:@"count"];
                }
                
                callback(backDic);
                
            }else{
                callback(nil);
            }
        }else{
            callback(nil);
            [self  hudViewShowWithStr:@"请求失败" andTime:1];
        }
    }];
}
#pragma mark   精彩专区查询帖子详情
-(void)postFindWonderFulPostDetialInfoWithPlate:(ZZPlateTypeInfo*)plate andPostId:(NSUInteger)postId  andUserId:(NSUInteger)userId  andBack:(CallBack)callback{
    NSDictionary* params = @{@"token":self.token,@"id":@(postId),@"type":plate.type,@"userId":@(userId)};
    [self postByApiName:[NSString stringWithFormat:@"%@FindWonderfulDetails",plate.interface] andParams:params andCallBack:^(id obj) {
        ZZLog(@"精彩专区查找帖子详情:%@",obj);
    }];
}
#pragma mark  精彩删帖
-(void)postDeleteWonderFulrConstellationPostWithPlate:(ZZPlateTypeInfo*)plate PostId:(NSUInteger)postId  andBack:(CallBack)callback{
    NSDictionary* params = @{@"token":self.token,@"id":@(postId),@"type":plate.type};
    [self postByApiName:[NSString stringWithFormat:@"%@DeleteWonderful",plate.interface]  andParams:params andCallBack:^(id obj) {
        
        ZZLog(@"精彩专区删除帖子:%@",obj);
    }];
}
 */
#pragma mark----------------------------其他--------------------------

#pragma mark 消息
-(void)postFindMessageByMessageId:(NSInteger)messageId andUpDown:(int)upDown  andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:2];
    [params  setObject:self.token forKey:@"token"];
    if (messageId&&upDown) {
        [params   setObject:@(messageId) forKey:@"id"];
        [params  setObject:@(upDown) forKey:@"upDown"];
    }
    [self postByApiName:@"message/findMessage" andParams:params andCallBack:^(id obj) {
        ZZLog(@"消息列表:%@",obj);
        if ([[obj objectForKey:@"code"]boolValue]) {
            NSArray* context = [obj objectForKey:@"context"];
            if ([context isKindOfClass:[NSArray class]]&&context.count) {
                NSMutableArray* marray = [NSMutableArray arrayWithCapacity:2];
                for (NSDictionary* dic in context) {
                    ZZMessage* messageInfo = [ZZJsonParse parseMessageListByDic:dic];
                    [marray addObject:messageInfo];
                }
                callback(marray);
            }else{
                callback([NSArray  array]);
                if(upDown&&messageId){
                    [self  hudViewShowWithStr:@"没有更多内容" andTime:1];
                }
            }
                
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"消息查询失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
            
        }
    }];
}

#pragma mark 反馈
//提交意见
-(void)postAddFeedBackAndContent:(NSString*)content   andBack:(CallBack)callback{
    [self  postByApiName:@"feedBack/addFeedBack" andParams:@{@"token":self.token,@"context":content} andCallBack:^(id obj) {
        if ([[obj  objectForKey:@"code"]boolValue]) {
            callback(@"");
            [self  hudViewShowWithStr:@"提交成功" andTime:1];
        }else{
            
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"提交失败";
            }
            
            callback(nil);
            [self  hudViewShowWithStr:tip andTime:1];
        }
    }];
}
#pragma mark 金币纪录
-(void)postFindGoldListWithId:(NSUInteger)goldRecordId  andUpDown:(int)upDown  andBack:(CallBack)callback{
    NSMutableDictionary*  params = [NSMutableDictionary  dictionaryWithCapacity:1];
    [params  setObject:self.token forKey:@"token"];
    if (upDown&&goldRecordId) {
        [params  setObject:@(upDown) forKey:@"upDown"];
        [params   setObject:@(goldRecordId) forKey:@"id"];
    }
    [self  postByApiName:@"gold/goldFindRecord" andParams:params andCallBack:^(id obj) {
        ZZLog(@"金币纪录:%@",obj);

                if ([[obj objectForKey:@"code"]boolValue]) {
                    NSArray* context = [obj objectForKey:@"context"];
                    if ([context isKindOfClass:[NSArray class]]&&context.count) {
                        NSMutableArray* marray = [NSMutableArray arrayWithCapacity:3];
                        for (NSDictionary* dic in context) {
                            ZZGoldRecord* goldUser = [ZZJsonParse parseGoldListByDic:dic];
                            [marray addObject:goldUser];
                        }

                       callback(marray);
                    }else{
                        callback([NSArray  array]);
                        if (upDown&&goldRecordId) {
                            [self  hudViewShowWithStr:@"没有更多内容" andTime:2];
                        }
                    }
                }else{
                    
                    /*
                     张亮亮 0511 修改
                     */
                    NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
                    if(!tip.length){
                        tip =@"金币记录查询失败" ;
                    }
                    
                    callback(nil);
                        [self  hudViewShowWithStr:tip andTime:1];
                }
    }];
}
#pragma mark 注销
-(void)postLoginOutAndEnterBackGround:(BOOL)enterBack     AndBack:(CallBack)callback{
    if (self.token.length==0) {
        return;
    }
    if (enterBack) {
        [netHud  hudShow];
    }
    
    [self   getByApiName:@"login/loginOut" andParams:@{@"token":self.token} andCallBack:^(id obj) {
        [netHud  hudHide];
        //确保下次token为0
    
        [self updateLoginOutLogStatus];
      
      
        ZZLog(@"注销：%@",obj);
        if ([[obj  objectForKey:@"code"]integerValue]==1) {
            callback(@"");
        }else{
            //[self    hudViewShowWithStr:@"注销失败" andTime:3];
            callback(nil);
        }
    }];
}
#pragma mark  在线专家和小编
-(void)postfindOnLineAndCallBack:(CallBack)callback{
    [self  postByApiName:@"expert/expertFindExpertChat" andParams:@{@"token":self.token} andCallBack:^(id obj) {
        ZZLog(@"在线小编和专家:%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSDictionary*  context = [obj  objectForKey:@"context"];
            //context是否是字典类型
            if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
                NSMutableDictionary*  backDic = [NSMutableDictionary  dictionaryWithCapacity:context.count];
                NSArray*  expertList = [context objectForKey:@"expertList"];
                if ([expertList  isKindOfClass:[NSArray  class]]&&expertList.count) {
                    NSMutableArray*  backExpertArray = [NSMutableArray  arrayWithCapacity:expertList.count];
                    for (NSDictionary*  dic in expertList) {
                        ZZExpert*  expert = [ZZJsonParse  parseOnLineExpetByDic:dic];
                        if (expert) {
                            [backExpertArray addObject:expert];
                        }
                    }
                    [backDic  setObject:backExpertArray forKey:@"expertList"];
                }
                NSArray*  servelist = [context  objectForKey:@"serveList"];
                if ([servelist   isKindOfClass:[NSArray  class]]&&servelist.count) {
                    NSMutableArray*  backServeArray = [NSMutableArray  arrayWithCapacity:servelist.count];
                    for (NSDictionary*  dic in servelist) {
                        ZZExpert*  expert = [ZZJsonParse  parseOnLineExpetByDic:dic];
                        if (expert) {
                            if (expert.uToken.length) {
                                [ZZRongUserInfo  uploadUserInfoWithUserId:expert.uToken andNick:expert.nick andImageurl:expert.mbpImageinfo.smallImagePath];
                            }
                            [backServeArray addObject:expert];
                        }
                    }
                    [backDic  setObject:backServeArray forKey:@"serveList"];
                }
                callback(backDic);
            }else{
                callback(nil);
            }
        }else{
            callback(nil);
        }
    }];
}
#pragma mark  版本号
-(void)postFindVersionAndBack:(CallBack)callback{
    [self  postByApiName:@"login/findVersion" andParams:nil andCallBack:^(id obj) {
                ZZLog(@",,,%@",obj);
        if([obj isKindOfClass:[NSDictionary  class]]){
            callback(obj);
        }else{
            callback(nil);
        }
    }];
}
#pragma mark --------------------首页--------------------
#pragma mark 广场

-(void)postFindHomePageAndCallBack:(CallBack)callback{
    //[netHud  hudShow];
    [self  postByApiName:@"home/findHomePage" andParams:@{@"token":self.token} andCallBack:^(id obj) {
     //   [netHud  hudHide];
        
        ZZLog(@"广场%@",obj);
        if ([[obj  objectForKey:@"code"]boolValue]) {
            NSDictionary*  context = [ obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSDictionary  class]]&&context.count) {
                //保存首页请求数据
                [ZZLibCacheTool  saveCacheData:context libName:@"home/findHomePage"];
                
                NSMutableDictionary*  backDic = [NSMutableDictionary  dictionaryWithCapacity:context.count];
                NSArray*  eredarList = [context  objectForKey:@"eredarList"];
                if ([eredarList isKindOfClass:[NSArray  class]]&&eredarList.count) {
                    NSMutableArray*  backEredarArray = [NSMutableArray arrayWithCapacity:eredarList.count];
                    for (NSDictionary*  dic in eredarList) {
                        ZZUser*  eredar = [ZZJsonParse  parseSuperStarListByDic:dic];
                        if (eredar) {
                            [backEredarArray  addObject:eredar];
                        }
                    }
                    [backDic  setObject:backEredarArray forKey:@"eredarList"];
                }
                NSArray*  homeImgList = [context  objectForKey:@"homeImgList"];
                if ([homeImgList isKindOfClass:[NSArray  class]]&&homeImgList.count) {
                    NSMutableArray*   backImgArray = [NSMutableArray  arrayWithCapacity:homeImgList.count];
                    for (NSDictionary* dic in homeImgList) {
                        ZZPost*  mbpImage = [ZZJsonParse  parseImageInfoByDic:dic];
                        if (mbpImage) {
                            [backImgArray  addObject:mbpImage];
                        }
                        
                    }
                    [backDic  setObject:backImgArray forKey:@"homeImgList"];
                }
                
                NSArray*  plateList = [context  objectForKey:@"plateList"];
                if ([plateList  isKindOfClass:[NSArray  class]]&&plateList.count) {
                    NSMutableArray*  backPlateArray = [NSMutableArray  arrayWithCapacity:plateList.count];
                    for (NSDictionary*  dic in plateList) {
                        ZZPlateTypeInfo*  platetype = [ZZJsonParse  parsePlateTypeInfoByDic:dic];
                        if (platetype) {
                            [backPlateArray  addObject:platetype];
                        }
                    }
                    [backDic  setObject:backPlateArray forKey:@"plateList"];
                }
     
                     callback(backDic);
         
            }else{
                callback(nil);
               
                [self  hudViewShowWithStr:@"网络不给力请稍候再试" andTime:5];
            }
        }else{
            /*
             张亮亮 0511 修改
             */
            NSString*  tip = [ZZJsonParse  parseNetGetFailInfoByDic:[obj  objectForKey:@"context"]];
            if(!tip.length){
                tip =@"网络不给力请稍候再试" ;
            }
            
            callback(nil);
            
            [self  hudViewShowWithStr:tip andTime:3];
        }
      
    }];
}
#pragma mark  关注
-(void)postFindHomePageAttentionLastId:(NSUInteger)lastId andUpDown:(NSInteger)upDown  CallBack:(CallBack)callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = self.token;
    if (lastId&&upDown) {
        params[@"id"] = @(lastId);
        params[@"upDown"] = @(upDown);
    }
    [self  postByApiName:@"home/findHomePageAttentionPlate" andParams:params andCallBack:^(id obj) {
         ZZLog(@"关注%@",obj);
        if([[obj  objectForKey:@"code"]boolValue]){
            NSArray*  context = [obj  objectForKey:@"context"];
            if ([context  isKindOfClass:[NSArray  class]]&&context.count) {
                NSMutableArray*  backArray = [NSMutableArray  arrayWithCapacity:context.count];
                for (NSDictionary*  dic in context) {
                    ZZPlateTypeInfo*  plateType = [ZZJsonParse  parsePlateTypeInfoByDic:dic];
                    if (plateType) {
                        [backArray  addObject:plateType];
                    }
                }
                callback(backArray);
                
            }else{
                callback([NSArray  array]);
            }
        }else{
            callback(nil);
        }
    }];
}



#pragma mark 图片处理
//对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark  更新登陆状态  登录成功后
-(void)updateLogeStatusWithContext:(NSDictionary*)context{
    if ([context  isKindOfClass:[NSDictionary  class]]) {
        [ZZLoginSatus  sharedZZLoginSatus].token = [context  objectForKey:@"token"];
        [ZZLoginSatus sharedZZLoginSatus].rongToken = [context  objectForKey:@"rongyunToken"];
              [ZZLoginSatus  sharedZZLoginSatus].loginStatus = YES;
        [[ZZLoginSatus  sharedZZLoginSatus] saveUserInfoToSanbox];
    }

}
#pragma mark  更新登陆状态  登录成功后
-(void)updateLogeStatusLogSuccess {

    [ZZLoginSatus  sharedZZLoginSatus].loginStatus = YES;
    [[ZZLoginSatus  sharedZZLoginSatus] saveUserInfoToSanbox];
}
#pragma mark  更新登陆状态  注销后
-(void)updateLoginOutLogStatus{
    //清空，下重新赋值，避免串号
    self.token = nil;
    [ZZLoginSatus  sharedZZLoginSatus].rongToken = nil;
    if ([ZZLoginSatus  sharedZZLoginSatus].activeStatus) {//进入后台时注销不改变登陆状态
        [ZZLoginSatus  sharedZZLoginSatus].loginStatus = NO;
        [[ZZLoginSatus  sharedZZLoginSatus] saveUserInfoToSanbox];
    }
 
   
}
#pragma mark  根据token获取用户昵称头像
-(void)postFindUserNickWithToken:(NSString*)uToken   andCallBack:(CallBack)callback{
    if (uToken.length&&self.token.length) {
        NSDictionary*   params = @{@"token":self.token,@"userToken":uToken};
        [self  postByApiName:@"user/findUserInfo" andParams:params andCallBack:^(id obj) {
            ZZLog(@"用户昵称:%@",obj);
            if ([[obj  objectForKey:@"code"]boolValue]) {
                ZZUser* user = [ZZJsonParse  parseUserNickAndImageUrlByDic:[obj  objectForKey:@"context"]];
                if (user.nick.length) {
                    [ZZRongUserInfo  uploadUserInfoWithUserId:uToken andNick:user.nick andImageurl:user.mbpImageinfo.smallImagePath];
                }
            }
            callback(nil);
        }];
    }else{
        callback(nil);
    }

}

@end
