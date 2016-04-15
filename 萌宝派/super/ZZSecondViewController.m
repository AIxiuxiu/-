//
//  ZZSecondViewController.m
//  萌宝派
//
//  Created by charles on 15/3/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSecondViewController.h"
#import "ZZTabBarViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
@interface ZZSecondViewController ()

@end

@implementation ZZSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate;
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;
    if ([menuController  isKindOfClass:[DDMenuController  class]]) {
        [menuController  setEnableGesture:NO];
    }
    
    
    
    UIImage* img1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_button_40x40.png" ofType:nil]];
    UIBarButtonItem * leftBar = [[UIBarButtonItem  alloc]initWithImage:img1 style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    [leftBar  setBackButtonBackgroundVerticalPositionAdjustment:-20 forBarMetrics:UIBarMetricsDefault];
    leftBar.imageInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    leftBar.tintColor = [UIColor  whiteColor];
    
    [self.navigationItem  setLeftBarButtonItem:leftBar animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//移除内容前后的空格和回车
-(NSString*)removeWhitespaceAndNewlineCharacterWithOrignString:(NSString*)string{
    return [string   stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}


- (void)shakeAnimationForView:(UIView *) view

{
    
    // 获取到当前的View
    
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    
    CGPoint x = CGPointMake(position.x + 10, position.y);
    
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    
    [animation setAutoreverses:YES];
    
    // 设置时间
    
    [animation setDuration:.06];
    
    // 设置次数
    
    [animation setRepeatCount:3];
    
    // 添加上动画
    
    [viewLayer addAnimation:animation forKey:nil];
}


@end
