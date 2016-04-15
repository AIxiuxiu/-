//
//  UIViewController+Extension.h
//  萌宝派
//
//  Created by zhizhen on 15/7/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)
/**
 *  跳转到AppStore
 *  params  appID 对应的app的id  ，默认为萌宝派的id
 */
-(void)jumpToAppStoreWithAppID:(long)appID;
@end
