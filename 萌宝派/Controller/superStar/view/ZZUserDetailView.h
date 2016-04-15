//
//  ZZUserDetailView.h
//  萌宝派
//
//  Created by charles on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUser.h"
@class ZZUserDetailView;
@protocol ZZUserDetailViewDelegate <NSObject>
/**
 *  关注点击事件
 */
-(void)userDetailViewToAttention:(ZZUserDetailView*)userDetailView;
/**
 *  segmentd点击切换事件
 */
-(void)userDetailViewToSegment:(ZZUserDetailView*)userDetailView andItem:(NSUInteger)item;

@end

@interface ZZUserDetailView : UIView
@property(nonatomic,strong)ZZUser*  user;
/**
 *  委托的协议创建
 */
@property(nonatomic,weak)id<ZZUserDetailViewDelegate>delegate;

/**
 *  关注按钮默认不加到视图中
 */
- (void)showAttentionBUtton;
@end
