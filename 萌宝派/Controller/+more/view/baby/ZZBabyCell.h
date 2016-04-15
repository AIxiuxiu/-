//
//  ZZBabyCell.h
//  萌宝派
//
//  Created by zhizhen on 15-3-12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZBaby.h"
@class ZZBabyCell;
@protocol ZZBabyCellDelegate <NSObject>

/**
 *  cell不同行的点击效果
 *
 *  @param babyCell <#babyCell description#>
 */
- (void)babyCellSectionClicked:(ZZBabyCell *)babyCell type:(NSUInteger)type ;

/**
 *  删除按钮点中
 *
 *  @param babyCell <#babyCell description#>
 */
- (void)babyCellDeleteButtonClicked:(ZZBabyCell *)babyCell;
@end

@interface ZZBabyCell : UITableViewCell
@property(nonatomic,strong)UIImageView*  babyHeadImageView;//baby 头像
@property(nonatomic,strong)UILabel*  babyNickLabel;//baby 昵称
@property(nonatomic,strong)UILabel*  babyBirthdayLabel;//baby 生日
@property(nonatomic,strong)UILabel*  babySexLabel;//baby 性别
@property(nonatomic,strong)UILabel*  babyDiaryCountLabel;//baby 成长日记数量
@property(nonatomic,strong)UILabel*  babyPeersCountLabel;//baby 同龄宝宝数量
@property(nonatomic,strong)UIView*   babyView;
@property(nonatomic,strong)UIView*   diaryView;
@property(nonatomic,strong)UIView*    peersView;

@property(nonatomic,strong)ZZBaby* babyInfo;
@property (nonatomic, weak)id<ZZBabyCellDelegate> delegate;
//
@property(nonatomic,strong)UIButton*   deleteButton;


+ (ZZBabyCell *)dequeueReusableCellWithTableView:(UITableView *)tableView;
@end
