//
//  ZZDiaryPublishCell.h
//  萌宝派
//
//  Created by zhizhen on 15-3-13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTextView.h"
#import "ZZDiaryPublishViewController.h"
@class ZZDiaryPublishCell;
@protocol ZZDiaryPublishCellDelegate <NSObject>
/**
 *  图片点击响应事件
 *
 *  @param diaryPC <#diaryPC description#>
 */
-(void)diaryPublishCellTapImageAction:(ZZDiaryPublishCell*)diaryPC;

@end

@interface ZZDiaryPublishCell : UITableViewCell
@property(nonatomic,strong)UIImageView*  addImageView;
@property(nonatomic,strong)ZZTextView*   inputTextView;
@property(nonatomic,weak)id<ZZDiaryPublishCellDelegate>  delegate;
@end
