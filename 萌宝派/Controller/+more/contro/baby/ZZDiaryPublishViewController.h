//
//  ZZDiaryPublishViewController.h
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//
@class ZZDiaryPublishCell;
#import "ZZSecondViewController.h"
@class ZZBaby;
@class ZZPost;

@interface ZZDiaryPublishViewController : ZZSecondViewController
@property(nonatomic,strong)UITableView*  publishTableView;

@property(nonatomic,strong)NSMutableArray*  imagesMarray;

@property(nonatomic)NSUInteger  setectTag;
@property(nonatomic,strong)ZZBaby*  babyInfo;
@property(nonatomic,strong)ZZPost*  publishPost;
@property(nonatomic,strong)NSString*  publishString;

@end
