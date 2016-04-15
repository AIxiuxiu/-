//
//  ZZPostView.h
//  萌宝派
//
//  Created by zhizhen on 15/7/22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZPost,ZZPostView;

@protocol ZZPostViewDelegate  <NSObject>
/**
 *  头像被点击
 *
 *  @param postView <#postView description#>
 */
-(void)postViewTapHeadImage:(ZZPostView*)postView;

/**
 *  点赞按钮
 *
 *  @param postView <#postView description#>
 */
-(void)postViewClickSpotButton:(ZZPostView*)postView;

@end
@interface ZZPostView : UIView
// 帖子
@property(nonatomic,strong)ZZPost *post;
//委托
@property(nonatomic,weak)id<ZZPostViewDelegate> delegate;
@end
