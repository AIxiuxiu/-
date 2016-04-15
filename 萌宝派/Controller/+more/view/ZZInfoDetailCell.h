//
//  ZZInfoDetailCell.h
//  萌宝派
//
//  Created by charles on 15/3/27.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZPost,ZZInfoDetailCell;

@protocol ZZInfoDetailCellDelegate <NSObject>

-(void)infoDetailCellClickedDeleteButton:(ZZInfoDetailCell *)infoCell;

@end
@interface ZZInfoDetailCell : UITableViewCell

@property(nonatomic,strong)UILabel* lineLabel;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* postType;
@property(nonatomic,strong)UILabel* timeLabel;
//@property(nonatomic,strong)UILabel* likeLabel;//收藏
@property(nonatomic,strong)UILabel* replayLabel;
@property(nonatomic,strong)UIImageView* image;
@property(nonatomic,strong)UIImageView*  darenLevelIV;
@property(nonatomic,strong)UIImageView* readImage;
@property(nonatomic,strong)UIImageView* clockImage;

@property (nonatomic, strong)ZZPost *post;

/**
 *  可重复cell 利用方法
 *
 *  @param tableView <#tableView description#>
 *  @param delete    是否有删除按钮，有删除按钮、没有头像
 *
 *  @return <#return value description#>
 */
+ (ZZInfoDetailCell *)dequeueReusableCellWithTableView:(UITableView *)tableView  deleteButton:(BOOL) canDelete  delegate:(id<ZZInfoDetailCellDelegate>) delegate;
@end
