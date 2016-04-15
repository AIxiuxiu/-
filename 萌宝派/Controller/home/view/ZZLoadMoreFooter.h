//
//  ZZLoadMoreFooter.h
//  萌宝派
//
//  Created by zhizhen on 15/8/4.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZLoadMoreFooter;
@protocol ZZLoadMoreFooterDelegate <NSObject>

- (void)loadMoreFaileClickedRequestAgain:(ZZLoadMoreFooter *)footer;

@end

@interface ZZLoadMoreFooter : UIView
+ (instancetype)footer;

- (void)beginRefreshing;
- (void)endRefreshing;


@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;
//没有更多内容不能再刷新
@property (nonatomic, assign) BOOL canRefresh;

@property (nonatomic, weak)id<ZZLoadMoreFooterDelegate> delegate;

- (void)requestFailed;
@end
