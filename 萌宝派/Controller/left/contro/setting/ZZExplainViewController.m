//
//  ZZExplainViewController.m
//  萌宝派
//
//  Created by charles on 14-11-24.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "ZZExplainViewController.h"
#import "SDWebImageDownloader.h"

#import "ZZMengBaoPaiRequest.h"
#import "UIImageView+WebCache.h"
@interface ZZExplainViewController ()
@property(nonatomic,strong)UIScrollView*  scrollView;
@property(nonatomic,strong)UIImageView*   imageView;
@end

@implementation ZZExplainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用说明";
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ZZViewBackColor;
   
    [self  setUpImageView];

}

- (void)setUpImageView{
    CGFloat margin = 10;
    // scrow frame
    CGFloat  sX = margin;
    CGFloat  sY = ZZNaviHeight ;
    CGFloat sW = ScreenWidth - 2 * margin;
    CGFloat sH = ScreenHeight - ZZNaviHeight ;
    
    //image frme
    CGFloat imageW = 300;
    CGFloat  imageH = 4609;
    CGFloat  imageX = (sW - imageW)/2;
    CGFloat imageY = 0;
 
    UIScrollView*view=[[UIScrollView alloc]initWithFrame:CGRectMake(sX, sY, sW,sH)];
    view.backgroundColor = [UIColor  clearColor];
    self.scrollView = view;
    view.contentSize=CGSizeMake(imageW,imageH);
    view.showsHorizontalScrollIndicator=NO;
    view.showsVerticalScrollIndicator=NO;

    [self.view addSubview:view];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    
    imageView.backgroundColor = [UIColor  whiteColor];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"instructions_300x4609.jpg" ofType:nil]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
//    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    imageView.layer.shadowRadius = 1;
//    imageView.layer.shadowOffset = CGSizeMake(0, 1);
//    imageView.layer.shadowOpacity = 0.3;
    [self.scrollView addSubview:imageView];
}
-(void)clickAction:(UIButton*)button{
    switch (button.tag) {
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}



@end
