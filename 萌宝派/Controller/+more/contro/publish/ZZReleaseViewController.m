//
//  ZZReleaseViewController.m
//  萌宝派
//
//  Created by charles on 15/3/22.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZReleaseViewController.h"
#import "ZZReleaseSecondViewController.h"
#import "ZZMessageImageViewController.h"
#import "ZZTextView.h"
#import "ZZMyAlertView.h"
#import "ZZAPPPublishRuleVC.h"
@interface ZZReleaseViewController ()<UITextViewDelegate,ZZMyAlertViewDelgate>

@property(nonatomic,strong)ZZTextView* titleView;

@property(nonatomic,strong)UILabel* otherLabel;

@property(nonatomic,strong)ZZPost*  publishPost;

@property(nonatomic,strong)UILabel* ruleLabel;
@end

@implementation ZZReleaseViewController
#pragma mark  lazy load
-(ZZPost *)publishPost{
    if(!_publishPost){
        _publishPost = [[ZZPost  alloc]init];
    }
    return _publishPost;
}

-(UILabel *)otherLabel{
    if (!_otherLabel) {
        _otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 179, 300, 20)];
        _otherLabel.textAlignment = NSTextAlignmentLeft;
        _otherLabel.font = ZZContentFont;
        
        _otherLabel.textColor = ZZLightGrayColor;
        _otherLabel.text = @"标题起的好，大家都知道！！";
    }
    return _otherLabel;
}

-(UILabel *)ruleLabel{
    if (!_ruleLabel) {
        _ruleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 179+30, 300, 20)];
        _ruleLabel.textAlignment = NSTextAlignmentLeft;
        _ruleLabel.font = ZZContentFont;
     
        _ruleLabel.textColor = ZZLightGrayColor;
        _ruleLabel.text = @"发布时敬请遵守《萌宝派发帖规则》";
    }
    return _ruleLabel;
}
#pragma mark life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建标题";
    //标题
  self.automaticallyAdjustsScrollViewInsets = NO;
    [self  setTxetView];
//    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-110, 220, 100, 30)];
//    button.layer.cornerRadius = 5;
//    [button setBackgroundColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1]];
//    [button setTitle:@"下一步" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem  alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction)];
    rightBar.tintColor = [UIColor  whiteColor];
    
    [self.navigationItem setRightBarButtonItem:rightBar animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
//    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
//    [btn1  setTitle:@"下一步" forState:UIControlStateNormal];
//    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [btn1 addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn1];
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSeperator.width = -16;//此处修改到边界的距离，请自行测试
//        [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightBarButtonItem]];
//    }
//    else
//    {
//        [self.navigationItem setRightBarButtonItem: rightBarButtonItem animated:NO];
//    }
    //加载提示label
    [self.view addSubview:self.otherLabel];
    [self.view  addSubview:self.ruleLabel];
    //点击button
    [self  setRuleButton];
    //textview内容变化响应时间
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(textViewContentChange:) name:UITextViewTextDidChangeNotification object:self.titleView];

}

-(void)viewDidAppear:(BOOL)animated{
    [super  viewDidAppear:animated];
    if (self.titleView.text.length == 0) {
        [self.titleView  becomeFirstResponder];
    }
}
//textview
-(void)setTxetView{
    self.titleView = [[ZZTextView alloc]initWithFrame:CGRectMake(10, 74, ScreenWidth-20, 100)];
   
    self.titleView.font = ZZContentFont;

    self.titleView.textContentLength = 100;
 
    self.titleView.placeholder = @" 标题，1-50字。(必填)";
    [self.view addSubview:self.titleView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view  endEditing:YES];
}
/**
 *规则按钮
 */
-(void)setRuleButton{
    UIButton*  blueButton = [[UIButton  alloc]initWithFrame:CGRectMake(ScreenWidth-70, self.ruleLabel.frame.origin.y, 60, self.ruleLabel.frame.size.height)];
    blueButton.layer.cornerRadius = 5.0f;
    blueButton.layer.masksToBounds = YES;
    blueButton.titleLabel.font = ZZTimeFont;
    blueButton.backgroundColor = ZZGreenColor;
    [blueButton  addTarget:self action:@selector(jumpToRuleVC) forControlEvents:UIControlEventTouchUpInside];
    [blueButton  setTitle:@"查看详情" forState:UIControlStateNormal];
    //  blueButton.titleLabel.text = @"点击查看规则详情";
    [self.view  addSubview:blueButton];
}
#pragma mark event  noticion
-(void)textViewContentChange:(NSNotification*)notification{
    self.navigationItem.rightBarButtonItem.enabled = self.titleView.hasText;
}
#pragma mark event  response
-(void)nextAction{
    
    if ([self  removeWhitespaceAndNewlineCharacterWithOrignString:self.titleView.text].length) {
        
    }else{
        ZZMyAlertView*  alertView = [[ZZMyAlertView  alloc]initWithMessage:@"你还没有填写标题" delegate:nil cancelButtonTitle:@"确定" sureButtonTitle:nil];
        [alertView  show];
        return;
    }

    [self.titleView  resignFirstResponder];

    self.publishPost.postTitle = [self  removeWhitespaceAndNewlineCharacterWithOrignString:self.titleView.text];
    self.publishPost.postPlateType = self.plateType;
    if ([self.plateType.areaType isEqualToString:@"WONDERFUL"]) {
        //图文图文发布板式
        ZZReleaseSecondViewController* releaseSecondView = [[ZZReleaseSecondViewController alloc]init];
        releaseSecondView.publishPost = self.publishPost;
        [self.navigationController pushViewController:releaseSecondView animated:YES];
    }else{
        //文图图图发布板式
        ZZMessageImageViewController* messageImageView = [[ZZMessageImageViewController alloc]init];
        messageImageView.publishPost = self.publishPost;
        [self.navigationController pushViewController:messageImageView animated:YES];
    }
    
}

-(void)jumpToRuleVC{
    [self.titleView  resignFirstResponder];
    ZZAPPPublishRuleVC*  apppublishVC = [[ZZAPPPublishRuleVC  alloc]init];
    [self.navigationController  pushViewController:apppublishVC animated:YES];
}
#pragma  mark  private methods
-(void)goBack{
    if (self.publishPost.postContent.length||self.publishPost.postImagesArray.count||self.titleView.text.length) {
        self.view.backgroundColor = [UIColor  whiteColor];
//        UIAlertView*  alert = [[UIAlertView  alloc]initWithTitle:@"dddd" message:@"ddddddd" delegate:nil cancelButtonTitle:@"dddd" otherButtonTitles:@"dddd", nil];
//        [alert show];
        ZZMyAlertView*  myAlertView = [[ZZMyAlertView  alloc]initWithMessage:@"你还有内容未发布，你确定要返回嘛" delegate:self cancelButtonTitle:@"取消" sureButtonTitle:@"确定"];
        myAlertView.tag = 999;
        [myAlertView  show];
        
    }else{
        [self.navigationController  popViewControllerAnimated:YES];
    }
    
}

#pragma mark  ZZMyAlertViewDelegate
-(void)alertView:(ZZMyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 999&& buttonIndex) {
        [self.navigationController  popViewControllerAnimated:YES];
    }
}

#pragma mark   UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text  isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

-(void)dealloc{
 
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self.titleView];
}
@end
