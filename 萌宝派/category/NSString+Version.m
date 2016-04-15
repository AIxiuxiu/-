//
//  NSString+Version.m
//  萌宝派
//
//  Created by zhizhen on 15/7/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "NSString+Version.h"

@implementation NSString (Version)
-(BOOL) isOlderVersionThan:(NSString*)otherVersion
{
    return ([self compare:otherVersion options:NSNumericSearch] == NSOrderedAscending);
}
-(BOOL) isNewerVersionThan:(NSString*)otherVersion
{
    return ([self compare:otherVersion options:NSNumericSearch] == NSOrderedDescending);
}
+(NSString*)currentVersion{
  return   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end
