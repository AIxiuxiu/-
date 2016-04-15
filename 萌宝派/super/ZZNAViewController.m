//
//  ZZNAViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZNAViewController.h"
#import "ZZNaviTabberViewController.h"
@interface ZZNAViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) id popDelegate;
@end

@implementation ZZNAViewController
+ (void)initialize
{
      [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.35 green:0.75 blue:0.99 alpha:1]];
    //[[UIBarButtonItem appearance]setTintColor:[UIColor whiteColor]];
  
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 设置导航条按钮的文字颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
    // 注意导航条上按钮不可能，用模型的文字属性设置是不好使
    //    // 设置不可用
        titleAttr = [NSMutableDictionary dictionary];
        titleAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
        [item setTitleTextAttributes:titleAttr forState:UIControlStateDisabled];
    
    //UINavigationBar
    UINavigationBar *appearanceBar = [UINavigationBar  appearance];
//    [appearanceBar  setBarStyle:UIBarStyleBlackTranslucent];
//    [appearanceBar  setTranslucent:NO];
    appearanceBar.tintColor = [UIColor  whiteColor];
   [appearanceBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   
    
    if (self.childViewControllers.count) { // 不是根控制器
      viewController.hidesBottomBarWhenPushed = YES;
        //
        //        UIBarButtonItem *left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_back"] highImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(popToPre) forControlEvents:UIControlEventTouchUpInside];
        //        // 设置导航条的按钮
        //        viewController.navigationItem.leftBarButtonItem = left;
        //
        //        UIBarButtonItem *right = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_more"] highImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(popToRoot) forControlEvents:UIControlEventTouchUpInside];
        //        viewController.navigationItem.rightBarButtonItem = right;
    }
    
  [super pushViewController:viewController animated:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[ZZNaviTabberViewController class]]) { // 是根控制器
               self.interactivePopGestureRecognizer.delegate = _popDelegate;
        
        
    }else{ // 非根控制器
 self.interactivePopGestureRecognizer.delegate = nil;
        
    }
}
@end
