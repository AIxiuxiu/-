//
//  ZZDiaryViewController.h
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSecondViewController.h"
#import "ZZBaby.h"
@interface ZZDiaryViewController : ZZSecondViewController
//发布成功后调用
-(void)publishSuccessRefreshWith:(NSArray*)array;
@property(nonatomic,strong)ZZBaby*  babyInfo;
@end
