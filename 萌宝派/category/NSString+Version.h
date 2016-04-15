//
//  NSString+Version.h
//  萌宝派
//
//  Created by zhizhen on 15/7/16.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Version)
/**
 *  老版本比较
 *
 *  @param otherVersion 比较的版本号
 *
 *  @return yes：比otherVersion老
 */
-(BOOL) isOlderVersionThan:(NSString*)otherVersion;
/**
 *  新版本比较
 *
 *  @param otherVersion 比较的版本号
 *
 *  @return yes：比otherVersion新
 */
-(BOOL) isNewerVersionThan:(NSString*)otherVersion;
/**
 *  当前应用版本号
 *
 *  @return <#return value description#>
 */
+(NSString*)currentVersion;
@end
