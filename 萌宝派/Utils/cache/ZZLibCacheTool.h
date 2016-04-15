//
//  ZZLibCacheTool.h
//  萌宝派
//
//  Created by zhizhen on 15/6/25.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZLibCacheTool : NSObject

/**
 *  存储微博数据到沙盒中
 *
 *  @param statuses 需要存储的微博数据
 */
+ (void)saveCacheData:(NSDictionary*)cache  libName:(NSString*)libName;

/**
 *  读取数据
 *
 *  @param libName 界面名称
 *
 *  @return 返回数据
 */
+ (NSDictionary*)selectHomeNetDataWithLibName:(NSString*)libName;

@end
