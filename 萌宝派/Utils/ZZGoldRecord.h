//
//  ZZGoldRecord.h
//  萌宝派
//
//  Created by zhizhen on 15/4/17.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZGoldRecord : NSObject
//金币记录添加的属性
@property(nonatomic,strong)NSString* goldContext;//金币使用情况
@property(nonatomic,strong)NSString* goldDate;//金币使用时间
@property(nonatomic)NSInteger goldNum;//金币使用多少
@property(nonatomic)NSInteger goldId;//金币使用Id
@property(nonatomic,strong)NSString* goldTitle;//金币使用标题
@end
