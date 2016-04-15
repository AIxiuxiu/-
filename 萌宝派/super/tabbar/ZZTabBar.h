//
//  ZZTabBar.h
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTabBar;

@protocol ZZTabBarDelegate <UITabBarDelegate>

@optional

/**
 *  点击加号按钮的时候调用
 */
- (void)tabBarDidClickPlusButton:(ZZTabBar *)tabBar;
@end
@interface ZZTabBar : UITabBar
@property (nonatomic, weak) id<ZZTabBarDelegate> tabBarDelegate;
@end
