//
//  ZZBabyViewController.h
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSecondViewController.h"
#import "ZZPlateTypeInfo.h"
@interface ZZBabyViewController : ZZSecondViewController
@property(nonatomic,strong)ZZPlateTypeInfo*  babyPlate;
@property(nonatomic,strong)UITableView*  babyTableView;
-(void)babyInfoJumpToNewControllerWithType:(NSInteger)type  andRow:(NSIndexPath*)indexPath;
-(void)publishSuccessRefreshWith:(NSDictionary*)dic;

@end
