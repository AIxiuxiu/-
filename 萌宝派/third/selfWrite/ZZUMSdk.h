//
//  ZZUMSdk.h
//  友盟SDK
//
//  Created by charles on 15/6/3.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
typedef enum {
    ZZUMSdkShareQQ,//qq登陆
    ZZUMSdkShareSina,//新浪登陆
    ZZUMSdkShareWeChat//微信登陆
    
}ZZUMSdkShare;
/**
 *  声明回调方法
 */
typedef void (^UMSdkCallBack)(id obj);

@interface ZZUMSdk : NSObject
@property(nonatomic,strong)NSMutableArray* enterArray;
@property(nonatomic,strong)NSMutableArray* shareArray;
/**
 *  单例
 */
singleton_interface(ZZUMSdk);

/**
 *  友盟分享注册实例方法
 */
-(void)umSdkShareInit;
/**
 *  友盟第三方登录
 *
 *  @param umSdkShare 判断是哪个三方登入
 */
-(void)umThirdEnterWithController:(UIViewController*)controller andUmSdkShare:(ZZUMSdkShare)umSdkShare andBack:(UMSdkCallBack)umSdkBack;
/**
 *  退出友盟三方授权
 *
 *  @param umSdkShare 判断是哪个三方登入
 */
-(void)umThirdShareCancel;


@end
