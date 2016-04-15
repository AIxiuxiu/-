//
//  ZZSystemDetailMessageVC.m
//  萌宝派
//
//  Created by zhizhen on 15/4/14.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZSystemDetailMessageVC.h"
#import "ZZSIzeFitButton.h"
@interface ZZSystemDetailMessageVC ()
@property(nonatomic,strong)UIScrollView*  backScrollView;

@end

@implementation ZZSystemDetailMessageVC
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView  alloc]initWithFrame:CGRectMake(0, 64, [UIScreen  mainScreen].bounds.size.width, [UIScreen  mainScreen].bounds.size.height)];
        _backScrollView.backgroundColor = [UIColor  clearColor];
    }
    return _backScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送消息详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self  initScrollViewInterface];
     self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.98 blue:1 alpha:0.9];
    [self.view  addSubview:self.backScrollView];
    

        UIImage* img1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_button_40x40.png" ofType:nil]];
        UIBarButtonItem * leftBar = [[UIBarButtonItem  alloc]initWithImage:img1 style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        
        [leftBar  setBackButtonBackgroundVerticalPositionAdjustment:-20 forBarMetrics:UIBarMetricsDefault];
        leftBar.imageInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        leftBar.tintColor = [UIColor  whiteColor];
        
        [self.navigationItem  setLeftBarButtonItem:leftBar animated:YES];
 
   
    // Do any additional setup after loading the view.
}

- (void)goBack{
    if ([self.navigationController  popViewControllerAnimated:YES]) {
  
    }else{
        [self  dismissViewControllerAnimated:NO completion:nil];
    }
    
    
}
-(void)initScrollViewInterface{
    //背景
    UIView*  detailView = [[UIView alloc]init];
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.layer.cornerRadius = 5;
    detailView.layer.shadowColor = [UIColor blackColor].CGColor;
    detailView.layer.shadowRadius = 1;
    detailView.layer.shadowOffset = CGSizeMake(0, 1);
    detailView.layer.shadowOpacity = 0.3;
    //
    UIImageView *imageView = [[UIImageView  alloc]initWithFrame:CGRectMake((ScreenWidth -130)/2, 10, 120, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage  imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"萌宝派512x512.png" ofType:nil]];
    
    [detailView  addSubview:imageView];
//    UILabel* labelTitle = [[UILabel alloc]init];
//    labelTitle.font = [UIFont boldSystemFontOfSize:18];
//    labelTitle.numberOfLines = 0;
//    labelTitle.textColor = [UIColor colorWithRed:0.45 green:0.8 blue:0.21 alpha:0.92];
//    labelTitle.text = self.systemMessage.sMessageTitle;
    CGSize size = CGSizeMake(ScreenWidth-40, MAXFLOAT);
//
//    CGSize labelTitleSize = [labelTitle.text boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelTitle.font} context:nil].size;
//    labelTitle.frame = CGRectMake(10, 10, ScreenWidth-40, labelTitleSize.height);
//    [detailView  addSubview:labelTitle];
   // WithFrame:CGRectMake(10, 10, 300, height)
   
    
    
    UILabel* labelContent = [[UILabel alloc]init];
    labelContent.font = [UIFont systemFontOfSize:14];
    labelContent.numberOfLines = 0;
    labelContent.textColor = ZZLightGrayColor;
    labelContent.text = self.systemMessage.sMessageContent;
    CGSize  labelContentSize =[labelContent.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:labelContent.font} context:nil].size;
    labelContent.frame = CGRectMake(15, CGRectGetMaxY(imageView.frame)+15, ScreenWidth-50, labelContentSize.height);

    [detailView addSubview:labelContent];
    //背景
    UILabel* replayBK = [[UILabel alloc]init];
    replayBK.alpha = 0.05;
    replayBK.layer.cornerRadius = 5;
    replayBK.layer.masksToBounds = YES;
    replayBK.backgroundColor = [UIColor blueColor];
    replayBK.frame = CGRectMake(10, CGRectGetMinY(labelContent.frame)-5, ScreenWidth-40, labelContentSize.height+10);
    [detailView addSubview:replayBK];
    
    
    ZZSIzeFitButton *timeButton = [[ZZSIzeFitButton  alloc]init];
    [timeButton  setImage:[UIImage imageNamed:@"clock_14x14"] forState:UIControlStateNormal];
    timeButton.userInteractionEnabled = NO;
    [timeButton setTitle:self.systemMessage.sMessageDate forState:UIControlStateNormal];
    timeButton.alpha = 0.5;
    timeButton.margin = 5;
    [timeButton  setTitleColor:ZZLightGrayColor forState:UIControlStateNormal];
    timeButton.titleLabel.font = ZZTimeFont;
    timeButton.y = CGRectGetMaxY(replayBK.frame)+5;
    timeButton.x =ScreenWidth-35 -timeButton.width;
    [detailView  addSubview:timeButton];

    CGFloat  height = CGRectGetMaxY(timeButton.frame)+10;
    detailView.frame = CGRectMake(10, 10, ScreenWidth-20, ScreenHeight - 84);
    self.backScrollView.contentSize = CGSizeMake(0,  height);
    [self.backScrollView addSubview:detailView];
    
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
