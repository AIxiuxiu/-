//
//  ZZFunctionOb.h
//  萌宝派
//贴子详情里面 功能按钮  文字、图片、类型
//  Created by zhizhen on 15/5/18.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZPost.h"
typedef enum  {
    ZZFunctionObTypeCollection = 1,
    ZZFunctionObTypeShare,
    ZZFunctionObTypeReport,
    ZZFunctionObTypeOrder
    
} ZZFunctionObType;

@interface ZZFunctionOb : NSObject
/**
 *图片名字
 */
@property(nonatomic,strong)NSString*  fImageNameStr;
/**
 *对应文字
 */
@property(nonatomic,strong)NSString*  fNameStr;
/**
 *对应类型
 */
@property(nonatomic)ZZFunctionObType  functionObType;
/**
 *传进来要定义那个帖子的功能按钮：收藏、举报、分享、正序、
 *案例帖子隐藏举报，自己发的帖子隐藏收藏
 */
+(NSMutableArray*)getPostDetailFunctionArrayWithPost:(ZZPost*)post;
@end
