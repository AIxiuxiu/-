//
//  ZZChildVCViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-3.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZChildVCViewController.h"
#import "ZZTabBarViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
@interface ZZChildVCViewController ()

@end

@implementation ZZChildVCViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* img1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_button_40x40.png" ofType:nil]];

    
//
//

   
    
//    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(-20, 0, 40, 40)];
//    [btn setBackgroundImage:img1 forState:UIControlStateNormal];
//       [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//        [btn setBackgroundImage:img1 forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//      UIBarButtonItem*  leftBar=[[UIBarButtonItem alloc]initWithCustomView:btn];
     UIBarButtonItem * leftBar = [[UIBarButtonItem  alloc]initWithImage:img1 style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    leftBar.imageInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    leftBar.tintColor = [UIColor  whiteColor];
    [self.navigationItem  setLeftBarButtonItem:leftBar animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [btn setBackgroundImage:img1 forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*  leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSeperator.width = -16;//此处修改到边界的距离，请自行测试
//        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator,leftBarButtonItem]];
//    }
//    else
//    {
       // leftBarButtonItem.width = 20;
      //  [self.navigationItem setLeftBarButtonItem: leftBarButtonItem animated:NO];
   // }
    
//    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    
//    [btn1  setTitle:@"提交" forState:UIControlStateNormal];
//        btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [btn1 addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn1];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSeperator.width = -5;//此处修改到边界的距离，请自行测试
//        [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightBarButtonItem]];
//    }
//    else
//    {
//        [self.navigationItem setRightBarButtonItem: rightBarButtonItem animated:NO];
//    }
    //self.rightButton.opaque = YES;
//    self.rightButton = btn1;

    
}
-(void)goBack{
    //if(self.number == 2){
        [self.navigationController  popViewControllerAnimated:YES];
        
//    }else{
//        [self  dismissViewControllerAnimated:NO completion:nil];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//去除字符串 头尾的空格与回车
-(NSString*)strLengthWith:(NSString*)str{
    return  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
