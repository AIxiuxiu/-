//
//  ZZDiaryTableViewCell.h
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBabyDiaryInfo.h"
@class ZZDiaryTableViewCell;
@protocol ZZDiaryTableViewCellDelegate <NSObject>

- (void)diaryTableViewCellDelebuttonClicked:(ZZDiaryTableViewCell *)diaryCell;

@end
@interface ZZDiaryTableViewCell : UITableViewCell
@property(nonatomic,strong)ZZBabyDiaryInfo* diaryInfo;

+ (ZZDiaryTableViewCell *)dequeueReusableCellWithTableView:(UITableView *)tableView  delegate:(id<ZZDiaryTableViewCellDelegate>)delgate;
@end
