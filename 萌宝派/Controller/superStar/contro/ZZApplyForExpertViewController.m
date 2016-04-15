//
//  ZZApplyForExpertViewController.m
//  萌宝派
//
//  Created by charles on 15/4/13.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZApplyForExpertViewController.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZPlateTypeInfo.h"
#import "ZZMyAlertView.h"
@interface ZZApplyForExpertViewController ()<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIView* backgroundViewView;//背景
@property(nonatomic,strong)UITextField* starTextField;
@property(nonatomic,strong)UIPickerView* pickView;//达人分类选择

@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)UITextView* reasonTextView;
@property(nonatomic,strong)UITextField* phoneTextField;
@property(nonatomic,strong)UITextField* weChatTextField;
@property(nonatomic,strong)UITextField* QQTextField;
@property(nonatomic)  NSInteger keyBoardHeight;
@property(nonatomic,strong)UIView* enterButtonView;
@property(nonatomic,strong)UIButton* enterButton;

@end

@implementation ZZApplyForExpertViewController



#pragma mark – *****************  NSNotification  *****************
//通知里的方法
-(void)keyboardAppear:(NSNotification *)notification{
    //获取键盘的高度
    NSDictionary* userInfo = notification.userInfo;
    NSValue* value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    self.keyBoardHeight = keyboardFrame.size.height;
    //计算scrollView的frame
    CGRect inputFrame = self.scrollView.frame;
    inputFrame.size.height = (ScreenHeight) - keyboardFrame.size.height+64;
    //计算buttonView
//    CGRect buttonFrame = self.enterButtonView.frame;
//    buttonFrame.origin.y = self.view.bounds.size.height - keyboardFrame.size.height- self.enterButtonView.frame.size.height;
    
    //3.设置动画
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    
    [UIView animateWithDuration:duration delay:0  options:options animations:^{
         self.scrollView.frame = inputFrame;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardDisappear:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect inputFrame = self.scrollView.frame;
    inputFrame.size.height = ScreenHeight;

    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    
    [UIView  animateWithDuration:duration delay:0 options:options animations:^{
        self.scrollView.frame = inputFrame;
        //self.enterButtonView.frame = buttonFrame;
    }completion:^(BOOL finished) {
        
        
    }];
    
}

#pragma mark  lazy load


-(UIView *)enterButtonView{
    if (!_enterButtonView) {
        _enterButtonView = [[UIView alloc]initWithFrame:CGRectMake(-1, (ScreenHeight), (ScreenWidth)+2, 30)];
        _enterButtonView.layer.borderWidth = .5;
        _enterButtonView.layer.borderColor = [UIColor colorWithRed:.78 green:.78 blue:.78 alpha:1].CGColor;
        _enterButtonView.backgroundColor = [UIColor colorWithRed:.89 green:.89 blue:.89 alpha:1];
    }
    return _enterButtonView;
}
-(UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, (ScreenHeight), ScreenWidth, 216)];
        _pickView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.showsSelectionIndicator = YES;
        _pickView.backgroundColor = [UIColor colorWithRed:.89 green:.89 blue:.89 alpha:1];
    }
    return _pickView;
}
-(UIView *)backgroundViewView{
    if (!_backgroundViewView) {
        _backgroundViewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, (ScreenHeight))];
        _backgroundViewView.userInteractionEnabled = YES;
        _backgroundViewView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterButtonAction)];
        [_backgroundViewView addGestureRecognizer:tap];
    }
    return _backgroundViewView;
}
//-(UIButton *)enterButton{
//    if (!_enterButton) {
//        _enterButton = [[UIButton alloc]initWithFrame:CGRectMake1(250, 5, 80, 20)];
//        [_enterButton setTitle:@"确定" forState:UIControlStateNormal];
//        [_enterButton setTitleColor:[UIColor  colorWithRed:0.35 green:0.75 blue:0.99 alpha:1] forState:UIControlStateNormal];
//        _enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:15*(AutoSizeScaley)];
//        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _enterButton;
//}
#pragma mark  life  cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"达人申请";
    //navigation左右按钮
    [self  setUpNavigationItem];
    //创建界面
    [self  setUpChilds];
}
 //navigation左右按钮
- (void)setUpNavigationItem{
    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn1  setTitle:@"提交" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn1 addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*  rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -5;//此处修改到边界的距离，请自行测试
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator,rightBarButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem: rightBarButtonItem animated:NO];
    }
}
//创建界面
- (void)setUpChilds{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(0,ScreenHeight);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.backgroundViewView];
    
    UIView* intrduceView = [[UIView alloc]initWithFrame:CGRectMake(-1, 5, ScreenWidth+2, 110)];
    intrduceView.backgroundColor = [UIColor whiteColor];
    intrduceView.layer.borderWidth = 1.5;
    intrduceView.layer.borderColor = [UIColor colorWithRed:.89 green:.89 blue:.89 alpha:1].CGColor;
    UILabel* intrduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth-30, 80)];
    intrduceLabel.text = @"“达人是萌宝派用户中一群具有较高活跃度，同时在某一领域具有自己独特见解，且乐于与人分享高质量内容的人，如果你觉得你满足以上特质，欢迎加入萌宝派达人。”";
    intrduceLabel.textColor = [UIColor colorWithRed:242.0/255 green:184.0/255 blue:124.0/255 alpha:1];
    intrduceLabel.font = [UIFont boldSystemFontOfSize:15];
    intrduceLabel.numberOfLines = 0;
    [self.backgroundViewView addSubview:intrduceView];
    [intrduceView addSubview:intrduceLabel];
    
    //必填
    UILabel* biLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 200, 20)];
    biLabel.text = @"(*为必填)";
    biLabel.font = [UIFont boldSystemFontOfSize:13];
    biLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    [self.backgroundViewView addSubview:biLabel];
    
    //选择达人分类
    UILabel* starLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 204-69+10, 110, 20)];
    starLabel.text = @"*选择达人分类：";
    starLabel.font = [UIFont boldSystemFontOfSize:14];
    starLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    [self.backgroundViewView addSubview:starLabel];
    self.starTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 200-69+10, ScreenWidth-140, 30)];
    self.starTextField.userInteractionEnabled = YES;
    self.starTextField.delegate = self;
    self.starTextField.backgroundColor = [UIColor whiteColor];
    self.starTextField.font = [UIFont boldSystemFontOfSize:14];
    self.starTextField.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
    [self.starTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.backgroundViewView addSubview:self.starTextField];
    
    
    //申请达人理由
    UILabel* reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 249-69+10, 110, 20)];
    reasonLabel.text = @"*申请达人理由：";
    reasonLabel.font = [UIFont boldSystemFontOfSize:14];
    reasonLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    [self.backgroundViewView addSubview:reasonLabel];
    self.reasonTextView = [[UITextView alloc]initWithFrame:CGRectMake(120, 245-69+10, ScreenWidth-140, 80)];
    self.reasonTextView.delegate = self;
    self.reasonTextView.backgroundColor = [UIColor whiteColor];
    self.reasonTextView.font = [UIFont boldSystemFontOfSize:14];
    self.reasonTextView.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
    self.reasonTextView.layer.cornerRadius = 5;
    self.reasonTextView.layer.borderWidth = .5;
    self.reasonTextView.layer.borderColor = [UIColor colorWithRed:.78 green:.78 blue:.78 alpha:1].CGColor;
    [self.backgroundViewView addSubview:self.reasonTextView];
    
    
    //手机
    UILabel* phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 344-69+10, 100, 20)];
    phoneLabel.text = @"*手机：";
    phoneLabel.font = [UIFont boldSystemFontOfSize:14];
    phoneLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    [self.backgroundViewView addSubview:phoneLabel];
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 340-69+10, ScreenWidth-140, 30)];
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.font = [UIFont boldSystemFontOfSize:14];
    self.phoneTextField.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
    [self.phoneTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.backgroundViewView addSubview:self.phoneTextField];
    
    //微信
    UILabel* weChatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 389-69+10, 100, 20)];
    weChatLabel.text = @"微信：";
    weChatLabel.font = [UIFont boldSystemFontOfSize:14];
    weChatLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    [self.backgroundViewView addSubview:weChatLabel];
    self.weChatTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 385-69+10, ScreenWidth-140, 30)];
    self.weChatTextField.backgroundColor = [UIColor whiteColor];
    self.weChatTextField.font = [UIFont boldSystemFontOfSize:14];
    self.weChatTextField.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
    [self.weChatTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.backgroundViewView addSubview:self.weChatTextField];
    
    //QQ
    UILabel* QQLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 434-69+10, 100, 20)];
    QQLabel.text = @"QQ：";
    QQLabel.font = [UIFont boldSystemFontOfSize:14];
    QQLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1];
    [self.backgroundViewView addSubview:QQLabel];
    self.QQTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 430-69+10, ScreenWidth-140, 30)];
    self.QQTextField.backgroundColor = [UIColor whiteColor];
    self.QQTextField.font = [UIFont boldSystemFontOfSize:14];
    self.QQTextField.textColor = [UIColor colorWithRed:.34 green:.34 blue:.34 alpha:1];
    [self.QQTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.backgroundViewView addSubview:self.QQTextField];
    
    [self.view addSubview:self.enterButtonView];
    [self.enterButtonView addSubview:self.enterButton];
    
    [self.view addSubview:self.pickView];
    ZZPlateTypeInfo* plate = self.superTypes[0];
    self.starTextField.text = plate.title;
}

//键盘根据高度调整
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //通知
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
//取消通知
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 1;     //这个picker里的组键数
    
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return self.superTypes.count;  //数组个数
    
}


// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}
//改变pickview的字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    ZZPlateTypeInfo* plate = self.superTypes[row];
    myView.text = [NSString stringWithFormat:@"%@",plate.title];
    
    myView.font = [UIFont systemFontOfSize:15];
    
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    ZZPlateTypeInfo* plate = self.superTypes[row];
    self.starTextField.text = plate.title;
    self.starTextField.tag = [plate.type  integerValue];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [self.reasonTextView resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.weChatTextField resignFirstResponder];
    [self.QQTextField resignFirstResponder];
    [UIView animateWithDuration:.2 animations:^{
        self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, (ScreenHeight)-216);
        self.pickView.frame = CGRectMake(0, (ScreenHeight)-216, ScreenWidth, 216);
    }];
    return NO;
}

#pragma mark   UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self scrollViewDidScroll:self.scrollView];
    return YES;
}
#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [UIView animateWithDuration:.3 animations:^{
        scrollView.contentOffset  = CGPointMake(0, 100);
    }];
    //scrollView.contentOffset.x //获取横向滑动的距离
    
}
#pragma mark event response
//提交
-(void)sureButtonAction{
    
    self.pickView.frame = CGRectMake(0, (ScreenHeight), ScreenWidth, 216);

    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, (ScreenHeight)+50);
    [self.view  endEditing:YES];
    /*
     
     */
    if (self.starTextField.text.length&&self.reasonTextView.text.length&&self.phoneTextField.text.length) {
        
        
        [[ZZMengBaoPaiRequest shareMengBaoPaiRequest]postFindSuperStarByType:(int)self.starTextField.tag andContext:self.reasonTextView.text andPhone:self.phoneTextField.text andWeiXin:self.weChatTextField.text andQq:self.QQTextField.text andBack:^(id obj) {
            if (obj) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        ZZMyAlertView* alertView = [[ZZMyAlertView  alloc]initWithMessage:@"信息未完全，请补全信息！" delegate:nil cancelButtonTitle:nil sureButtonTitle:@"确定"];
        [alertView  show];
    }
    
}

//消除按钮
-(void)enterButtonAction{
    [self.reasonTextView resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.weChatTextField resignFirstResponder];
    [self.QQTextField resignFirstResponder];
    self.pickView.frame = CGRectMake(0, (ScreenHeight), ScreenWidth, 216);
    //self.enterButtonView.frame = CGRectMake1(-1, (AutoSizey), (AutoSizex)+2, 30);
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, (ScreenHeight)+50);
}

-(void)dealloc{
    self.scrollView.delegate = nil;
}

@end
