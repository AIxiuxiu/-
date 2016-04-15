//
//  ZZCase.h
//  萌宝派
//
//  Created by charles on 15/4/9.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZMengBaoPaiImageInfo.h"
#import "ZZUser.h"
@interface ZZCase : NSObject
@property(nonatomic,strong)NSString*  caseTypeName;//案例类型名字
@property(nonatomic)NSInteger caseType;//案例类型
//@property(nonatomic)long caseId;//案例Id
//@property(nonatomic,strong)NSString* caseTitle;//案例标题
//@property(nonatomic,strong)ZZMengBaoPaiImageInfo* caseImageInfo;//案例图片
//@property(nonatomic,strong)NSString* caseQuestion;//案例问题
//@property(nonatomic,strong)NSString* caseContent;//案例内容
//@property(nonatomic,strong)NSString*  caseDateStr;// 案例发布时间
//@property(nonatomic,strong)ZZUser* caseUser;//案例发布人名字
//@property(nonatomic)NSUInteger   caseReplyCount;// 帖子回复数
@end
