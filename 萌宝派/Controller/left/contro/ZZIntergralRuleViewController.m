//
//  ZZIntergralRuleViewController.m
//  萌宝派
//
//  Created by zhizhen on 15-3-10.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZIntergralRuleViewController.h"
#import "ZZGoldListViewController.h"
@interface ZZIntergralRuleViewController ()

@end

@implementation ZZIntergralRuleViewController
#pragma mark  life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZZViewBackColor;
    
      if (self.number == 1) {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStyleDone target:self action:@selector(sureButtonAction)];
        rightBar.tintColor = [UIColor  whiteColor];
        //  rightBar.width = 10;
        [self.navigationItem  setRightBarButtonItem:rightBar animated:YES];
    }
    
    [self  initUI];
}

-(void)initUI{
    
    CGFloat margin = 10;
    // scrow frame
    CGFloat  sX = margin;
    CGFloat  sY = ZZNaviHeight +10;
    CGFloat sW = ScreenWidth - 2 * margin;
    CGFloat sH = ScreenHeight - ZZNaviHeight - 2 * margin;
    
    //image frme
    CGFloat imageW = 300;
    CGFloat  imageH = 0;
    if (self.number == 1) {
        imageH = 275;
    }else{
        imageH = 480;
    }
    CGFloat  imageX = (sW - imageW)/2;
    CGFloat imageY = 0;
    UIScrollView *scrView=[[UIScrollView alloc]initWithFrame:CGRectMake(sX, sY, sW,sH)];
    scrView.contentSize=CGSizeMake(300,imageH);
    scrView.bounces = YES;
    [self.view addSubview:scrView];

    UIImageView* contentView = [[UIImageView alloc]init];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]CGColor];
    contentView.layer.borderWidth = 0.5;
    contentView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    if (self.number == 1) {
        
        contentView.image=[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"gold_rules_300x275.jpg" ofType:nil]];
        self.title = @"金币说明";
    }else{
       
        contentView.image=[UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"integral_rules_300x480.jpg" ofType:nil]];
        self.title = @"等级说明";
    }
    
    [scrView addSubview:contentView];
    
    
}
#pragma event response
-(void)sureButtonAction{
  
    ZZGoldListViewController* goldList = [[ZZGoldListViewController alloc]init];
    [self.navigationController pushViewController:goldList animated:YES];
}




@end
