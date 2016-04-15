//
//  ZZTabBarViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-2.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZTabBarViewController.h"
#import "ZZVCViewController.h"
#import "ZZNAViewController.h"
#import "ZZHomeViewController.h"
//动态
#import "ZZDynamicViewController.h"
#import "ZZHelpViewController.h"
//收藏
#import "ZZExpertViewController.h"
//
#import "ZZSecondViewController.h"
//
#import "ZZAllAreaViewController.h"
#import "AppDelegate.h"
//rongyun
#import "ZZRongChat.h"
#import "ZZTabBar.h"
#import "ZZBadgeView.h"
@interface ZZTabBarViewController ()<ZZTabBarDelegate>

@property (nonatomic, strong)ZZBadgeView *badgeView;
@end

@implementation ZZTabBarViewController
-(ZZBadgeView *)badgeView{
    if (_badgeView == nil) {
        _badgeView = [[ZZBadgeView  alloc]initWithFrame:CGRectMake(ScreenWidth/5 *2-24, 3, 20, 20)];
        [self.tabBar addSubview:_badgeView];
    }
    return _badgeView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setUpAllChildViewController];
    
    // 自定义tabBar
    [self setUpTabBar];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewChatMessageUpdateTipsContent) name:ZZUpdateRongYunNewMessageInfoNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self  receiveNewChatMessageUpdateTipsContent];
}

#pragma mark - 设置tabBar
- (void)setUpTabBar
{
    // 自定义tabBar
    ZZTabBar *tabBar = [[ZZTabBar alloc] initWithFrame:self.tabBar.frame];
   // tabBar.backgroundColor = [UIColor whiteColor];
    // 设置代理
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];

}


#pragma mark - 当点击tabBar上的按钮调用

// 点击加号按钮的时候调用
- (void)tabBarDidClickPlusButton:(ZZTabBar *)tabBar
{
    // 创建发送微博控制器
//    CZComposeViewController *composeVc = [[CZComposeViewController alloc] init];
//    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:composeVc];
//    
//    [self presentViewController:nav animated:YES completion:nil];
    ZZAllAreaViewController*  vc = [[ZZAllAreaViewController  alloc]init];
    
    ZZNAViewController*  navi = (ZZNAViewController*)self.selectedViewController;
    [navi  pushViewController:vc animated:YES ];
}


#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    // 首页
    ZZHomeViewController *home = [[ZZHomeViewController alloc] init];
    [self setUpOneChildViewController:home image:[UIImage imageNamed:@"tabbar_one_close_30x30"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_one_open_30x30"] title:@"首页"];
    
    // 动态
    ZZDynamicViewController *message = [[ZZDynamicViewController alloc] init];
    [self setUpOneChildViewController:message image:[UIImage imageNamed:@"tabbar_two_close_30x30"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_two_open_30x30"] title:@"动态"];

    
    // 专家
    ZZExpertViewController *expet = [[ZZExpertViewController alloc] init];
    [self setUpOneChildViewController:expet image:[UIImage imageNamed:@"tabbar_four_close_30x30"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_four_open_30x30"] title:@"达人"];
    
    // 我
    ZZHelpViewController *tool = [[ZZHelpViewController alloc] init];
    [self setUpOneChildViewController:tool image:[UIImage imageNamed:@"tabbar_five_close_30x30"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_five_open_30x30"] title:@"工具"];

}
// navigationItem决定导航条上的内容
// 导航条上的内容由栈顶控制器的navigationItem决定

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.title = title;

    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = ZZGreenColor;
    [vc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    ZZNAViewController *nav = [[ZZNAViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

//动态小红点
-(void)receiveNewChatMessageUpdateTipsContent{
 
          dispatch_async(dispatch_get_main_queue(), ^{
    NSUInteger receiveNewMessageCount = [[ZZRongChat  sharedZZRongChat]rongGetUnreadMessageCountWithSelfConversation];
    if(receiveNewMessageCount){
        self.badgeView.hidden = NO;
        if (receiveNewMessageCount<100) {
            self.badgeView.badgeValue = [NSString  stringWithFormat:@"%ld",receiveNewMessageCount];
        }else{
             self.badgeView.badgeValue = @"99+";
        }
    }else{
        self.badgeView.hidden = YES;
    }
          });
//    UILabel*  redTipLabel = [self.tabbarView  viewWithTag:989];
//    if (![redTipLabel  isKindOfClass:[UILabel  class]]) {
//      redTipLabel = [[UILabel  alloc]initWithFrame:CGRectMake1(108, 12, 8*AutoSizeScaley/AutoSizeScalex, 8)];
//        redTipLabel.layer.cornerRadius = 8*AutoSizeScaley/2;
//        redTipLabel.layer.masksToBounds = YES;
//        redTipLabel.backgroundColor = [UIColor  colorWithRed:1 green:0.1 blue:0.2 alpha:1];
//        redTipLabel.tag=989;
//        [self.tabbarView  addSubview:redTipLabel];
//    }
//    if (receiveNewMessageCount) {
//        redTipLabel.hidden = NO;
//    }else{
//        redTipLabel.hidden = YES;
//    }
//
//           dispatch_async(dispatch_get_main_queue(), ^{
//           int receiveNewMessageCount = [[ZZRongChat  sharedZZRongChat]rongGetUnreadMessageCountWithSelfConversation];
//           UILabel*  redTipLabel = [self.tabbarView  viewWithTag:989];
//           if (![redTipLabel  isKindOfClass:[UILabel  class]]) {
//               redTipLabel = [[UILabel  alloc]initWithFrame:CGRectMake1(108, 12, 8*AutoSizeScaley/AutoSizeScalex, 8)];
//               redTipLabel.layer.cornerRadius = 8*AutoSizeScaley/2;
//               redTipLabel.layer.masksToBounds = YES;
//               redTipLabel.backgroundColor = [UIColor  colorWithRed:1 green:0.1 blue:0.2 alpha:1];
//               
//               redTipLabel.tag=989;
//               [self.tabbarView  addSubview:redTipLabel];
//           }
//           if (receiveNewMessageCount) {
//               redTipLabel.hidden = NO;
//           }else{
//               redTipLabel.hidden = YES;
//           }
//       });
   
    
}
-(void)dealloc{
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:ZZUpdateRongYunNewMessageInfoNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
