//
//  ZZAboutAppViewController.m
//  萌宝派
//
//  Created by charles on 14-11-24.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZAboutAppViewController.h"

@interface ZZAboutAppViewController ()

@end

@implementation ZZAboutAppViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于萌宝派";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self grayBackGround];
    self.view.backgroundColor = ZZViewBackColor;
}

//灰色背景
-(void)grayBackGround{
    CGFloat margin = 10;
    
    CGFloat imageW = 300;
    CGFloat  imageH = 428;
    
    if (imageW > ScreenHeight -ZZNaviHeight) {
        margin = 0;
    }
    // scrow frame
    CGFloat  sX = margin;
    CGFloat  sY = ZZNaviHeight +10;
    CGFloat sW = ScreenWidth - 2 * margin;
    CGFloat sH = ScreenHeight - ZZNaviHeight - 2 * margin;
    
    //image frme
  
    CGFloat  imageX = (sW - imageW)/2;
    CGFloat imageY = 0;
    UIImageView*  imageView=  [[UIImageView  alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"aboutApp" ofType:@"jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    UIScrollView* grayBK = [[UIScrollView alloc]initWithFrame:CGRectMake(sX, sY, sW,sH)];
    grayBK.backgroundColor = [UIColor whiteColor];
    grayBK.showsVerticalScrollIndicator = NO;
    grayBK.layer.cornerRadius = 5;
    grayBK.layer.shadowColor = [UIColor blackColor].CGColor;
    grayBK.layer.shadowRadius = 1;
    grayBK.layer.shadowOffset = CGSizeMake(0, 1);
    grayBK.layer.shadowOpacity = 0.3;
    [self.view addSubview:grayBK];
    [grayBK  addSubview:imageView];
    grayBK.contentSize = CGSizeMake(imageW, imageH);

    //当前版本Label
    UILabel*  versionLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 161, CGRectGetWidth(grayBK.frame), 30)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont  boldSystemFontOfSize:20];
    versionLabel.textColor = ZZVersionColor;
    versionLabel.text = [NSString  stringWithFormat:@"当前版本   %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]  ];
    versionLabel.backgroundColor  = [UIColor  clearColor];
    [grayBK  addSubview:versionLabel];
}

@end
