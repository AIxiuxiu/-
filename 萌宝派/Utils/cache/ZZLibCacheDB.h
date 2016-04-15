//
//  ZZLibCacheDB.h
//  萌宝派
//
//  Created by zhizhen on 15/6/25.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ZZLibCacheDBDataTypeDicArray  //界面数据，解析返回字典，字典中数组
}ZZLibCacheDBDataType;

@interface ZZLibCacheDB : NSObject

/**
 *  更新或添加一个界面数据的缓存
 *
 *  @param cache   要缓存的数据
 *  @param libName 缓存的数据的界面名称
 *
 *  @return 是否成功
 */
+(BOOL)updateOrAddCacheData:(NSDictionary*)cache  libName:(NSString*)libName;


/**
 *   是否有这个界面的数据缓存
 *
 *  @param libName 这个界面的名称
 *
 *  @return YES存在
 */
+(BOOL)whetherExistWithLibName:(NSString*)libName;

/**
 *  获取首页的数据缓存
 *
 *  @return 字典
 */
+(NSDictionary*)selectHomeNetDataWithLibName:(NSString*)libName;
@end
