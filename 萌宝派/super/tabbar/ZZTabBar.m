//
//  ZZTabBar.m
//  萌宝派
//
//  Created by zhizhen on 15/8/3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTabBar.h"

@interface ZZTabBar ()

@property (nonatomic, weak) UIButton *plusButton;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, weak) UIButton *selectedButton;

@end
@implementation ZZTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self plusButton];
    }
    return self;
}


- (UIButton *)plusButton
{
    if (_plusButton == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar_home_open_42x42"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_home_open_42x42"] forState:UIControlStateHighlighted];
//        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        
        // 默认按钮的尺寸跟背景图片一样大
        // sizeToFit:默认会根据按钮的背景图片或者image和文字计算出按钮的最合适的尺寸
      //  [btn sizeToFit];
        
        // 监听按钮的点击
        [btn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        
        _plusButton = btn;
        
        [self addSubview:_plusButton];
        
    }
    return _plusButton;
}

// 点击加号按钮的时候调用
- (void)plusClick
{
    // modal出控制器
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.tabBarDelegate tabBarDidClickPlusButton:self];
    }
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
      CGFloat tabbarButtonW = self.width / 5;
    // 1.设置加号按钮的位置
    self.plusButton.height = self.height;
    self.plusButton.width =  tabbarButtonW;
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
    // 2.设置其他tabbarButton的位置和尺寸
  
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            child.height -=5;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
      
        }
    }
//    // 设置plusButton的frame
//    [self setupPlusButtonFrame];
//    
//    // 设置所有tabbarButton的frame
//    [self setupAllTabBarButtonsFrame];
}


@end
