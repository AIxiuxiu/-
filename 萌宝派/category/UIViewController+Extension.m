//
//  UIViewController+Extension.m
//  萌宝派
//
//  Created by zhizhen on 15/7/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "UIViewController+Extension.h"
#define mengID (954281556)
@implementation UIViewController (Extension)
-(void)jumpToAppStoreWithAppID:(long)appID{
    
    if(appID <= 0){
        appID = mengID;
    }
    NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",@(appID)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}
@end
