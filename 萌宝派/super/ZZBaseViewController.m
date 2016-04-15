//
//  ZZBaseViewController.m
//  萌宝派
//
//  Created by zhizhen on 15/4/24.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZBaseViewController.h"
#import "MobClick.h"
@interface ZZBaseViewController ()

@end

@implementation ZZBaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"类名:%@",[NSString stringWithUTF8String:object_getClassName(self)]);
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 2, 120, 30)];
        _tipsLabel.text = @"没有更多内容";
        _tipsLabel.font = [UIFont systemFontOfSize:16];
        _tipsLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.backgroundColor = [UIColor  clearColor];
        UIActivityIndicatorView*  activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];//指定进度轮的大小
        
        //activity.backgroundColor = [UIColor  redColor];
        //  activity.color = [UIColor  blueColor];
        // [activity setCenter:CGPointMake(10*AutoSizeScalex, 15)];//指定进度轮中心点
        //    NSLog(@"%f....%f,,,,,%f",activity.frame.size.height,activity.frame.size.width,activity.frame.origin.y);
        activity.tag =998;
        [activity  setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        activity.hidesWhenStopped = YES;
        [ _tipsLabel addSubview:activity];
        [ _tipsLabel  bringSubviewToFront:activity];
   
      
    }
    return _tipsLabel;
}


-(void)netStartRefresh{
    
    self.tipsLabel.text = @"       数据加载中";
  
        UIActivityIndicatorView*  activityView = (UIActivityIndicatorView*)[self.tipsLabel  viewWithTag:998];
        if ([activityView  isKindOfClass:[UIActivityIndicatorView class]]) {
                       [activityView  startAnimating];
        }
}

-(void)netStopRefresh{
    self.tipsLabel.text = @"没有更多内容";
    UIActivityIndicatorView*  view = (UIActivityIndicatorView*)[self.tipsLabel  viewWithTag:998];
    if ([view  isKindOfClass:[UIActivityIndicatorView class]]) {
        
        [view  stopAnimating];

    }
}

-(void)netLoadLogoStartWithView:(UIView*)view{

      [MBProgressHUD  showNetActivityIndicatorViewWithText:@"加载中..." view:view];
}

-(void)netLoadLogoEndWithView:(UIView*)view{

    [MBProgressHUD  hideAllHUDsForView:view animated:NO];
}

-(void)netLoadFailWithText:(NSString*)text isBack:(BOOL)back{
    __weak  typeof(self)  baseVC = self;

 // [MBProgressHUD  showNetLoadFailWithText:text view:baseVC.view ];

[MBProgressHUD  showNetLoadFailWithText:text toView:baseVC.view target:baseVC action:@selector(action)  isBack:back];
   
}
-(void)netLoadFailWithText:(NSString*)text view:(UIView*)view isBack:(BOOL)back{
    __weak  typeof(self)  baseVC = self;
    [MBProgressHUD  showNetLoadFailWithText:text toView:view target:baseVC action:@selector(action)  isBack:back];
}


//-(void)action{
//    
//}

@end
