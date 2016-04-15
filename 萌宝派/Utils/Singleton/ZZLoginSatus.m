//
//  ZZLoginSatus.m
//  萌宝派
//
//  Created by zhizhen on 15/4/23.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZLoginSatus.h"
#define LoginToken @"Token"
#define LoginStatusKey @"LoginStatus"

@implementation ZZLoginSatus
singleton_implementation(ZZLoginSatus)

-(NSString *)domin{
    return domain;
}
-(void)saveUserInfoToSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.token forKey:LoginToken];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults synchronize];
}

-(void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults objectForKey:LoginToken];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];

}

-(NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",self.token,domain];
}
@end
