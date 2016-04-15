//
//  ZZNaviTabberViewController.m
//  萌宝派
//
//  Created by charles on 15/3/11.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZNaviTabberViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "ZZTabBarViewController.h"
#import "ZZPushMessageFmdb.h"
#import "UIButton+WebCache.h"
#import "ZZUser.h"
#import "ZZSearchViewController.h"
#import "ZZNAViewController.h"
@interface ZZNaviTabberViewController ()
@property(nonatomic,strong)UIButton*  leftButton;//navi左按钮
@property (nonatomic, strong)UIView *leftView;
@end

@implementation ZZNaviTabberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZZViewBackColor;
    [self showNavigationItem];
}


- (void)showNavigationItem{
    //请求用户头像
    UIView *backView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    backView.backgroundColor = [UIColor  clearColor];
    self.leftView = backView;
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    btn.imageView.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds  = YES;
    self.leftButton = btn;
    [backView addSubview:btn];
    [self  userHeadImageChanged];
    
    [btn addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -5;//此处修改到边界的距离，请自行测试
        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator,leftBarButtonItem]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem: leftBarButtonItem animated:NO];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMessage) name:ZZReceiveMessageNotification object:nil];
    [self  receiveNewMessage];
    
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(userHeadImageChanged) name:ZZChangeUserHeadImageNotification object:nil];
    //右侧按钮
    
    UIButton* rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 25,25)];
    [rightBtn  setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"search_40x40" ofType:@"png"]] forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.clipsToBounds = YES;
    [rightBtn addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -5;//此处修改到边界的距离，请自行测试
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightBarButtonItem]];
}
//首页左按钮 响应事件
-(void)showLeft{
    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate ;
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;
    [menuController  showLeftController:YES];
    
    UIView*  view = [self.leftView  viewWithTag:999];
    if (view) {
        [view  removeFromSuperview];
    }
    
}
//右按钮  响应事件
-(void)showRight{
    AppDelegate*  app = (AppDelegate*)[UIApplication  sharedApplication].delegate ;
    DDMenuController*  menuController = (DDMenuController*)app.window.rootViewController;
    ZZTabBarViewController*  tabBarVC = (ZZTabBarViewController*)menuController.rootViewController;
    ZZSearchViewController*  searchViewC = [[ZZSearchViewController  alloc]init];
    
    [(UINavigationController*)tabBarVC.selectedViewController  pushViewController:searchViewC animated:YES];
   // [menuController  presentViewController:[[ZZNAViewController  alloc]initWithRootViewController:searchViewC ] animated:YES completion:nil];
}
//接受到新消息
-(void)receiveNewMessage{
    UIView*  view = [self.leftButton  viewWithTag:999];
    NSUInteger count =[ZZPushMessageFmdb  selectDataWithFlag:1];

    if (count) {
        if (!view) {
            UILabel*  label = [[UILabel  alloc]initWithFrame:CGRectMake(27, -3, 6, 6)];
            label.backgroundColor = [UIColor  colorWithRed:0.8 green:0 blue:0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 3;
            label.layer.masksToBounds = YES;
            label.tag = 999;
            [self.leftView addSubview:label];
        }
        
    }else{
        [view  removeFromSuperview];
    }
}

//用户头像改变
-(void)userHeadImageChanged{
    
       [self.leftButton  sd_setImageWithURL:[NSURL  URLWithString:[ZZUser  shareSingleUser].mbpImageinfo.smallImagePath] forState:UIControlStateNormal placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"head_portrait_55x55.jpg" ofType:nil]]];
    //[self.leftButton  sd_setImageWithURL:[NSURL  URLWithString:[ZZUser  shareSingleUser].mbpImageinfo.smallImagePath]   forState:UIControlStateNormal];
}
-(void)dealloc{
    //2.0.4 隐藏
   // [[NSNotificationCenter  defaultCenter]removeObserver:self name:ZZReceiveMessageNotification object:nil];
    [[NSNotificationCenter  defaultCenter]removeObserver:self ];
}


@end
