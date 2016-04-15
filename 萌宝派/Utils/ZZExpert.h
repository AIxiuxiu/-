//
//  ZZExpert.h
//  BaoBao康_登入界面
//
//  Created by zhizhen on 14-9-12.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZUser.h"
@interface ZZExpert : ZZUser

//专家的属性
@property(nonatomic,strong)NSString*   hospital;//医院
@property(nonatomic,strong)NSString*  introduction;//简介
@property(nonatomic)int city;//城市编码
@property(nonatomic,strong)NSString* job;//职位
@property(nonatomic,strong)NSString*  skill;//擅长
@property(nonatomic)NSInteger caseCount;//案例数量
@property(nonatomic)NSInteger chatCount;//聊天数量
@property(nonatomic)NSInteger helpCount;//帮助数量
@property(nonatomic)BOOL online;//专家是否在线
@property(nonatomic)NSInteger expertType;//专家类型

@property(nonatomic,strong)NSString*  token;
@end
