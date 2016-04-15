//
//  ForgetVC.m
//  登录界面
//
//  Created by charles on 15/8/6.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//

#import "ForgetVC.h"
#import "ZZHudView.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZNewSecrectVC.h"
#import "ZZIQKeyBoard.h"
@interface ForgetVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *securityTF;
@property (weak, nonatomic) IBOutlet ZZSecurityButton *getSecrectButton;
@end

@implementation ForgetVC

#pragma mark - Life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  开启IQKeyBoard
     */
    [[ZZIQKeyBoard sharedZZIQKeyBoard] arrowSwitchIQKeyBoard];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /**
     *  关闭IQKeyBoard
     */
    [[ZZIQKeyBoard sharedZZIQKeyBoard] disOpenWithKeyBoard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUpBackIV];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"忘记密码";
    [self setNaviRightButton];
    [self setNaviLeftButton];
    
}
- (void) setUpBackIV{
    UIImageView *iv = [[UIImageView  alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    iv.userInteractionEnabled = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.image =  [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"渐变色3.jpg" ofType:nil]];
    [self.view  insertSubview:iv atIndex:0];
}
-(void)setNaviLeftButton{
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    [t setFrame:CGRectMake(0, 0, 40, 40)];
    [t setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"arrow_button_40x40.png" ofType:nil]] forState:UIControlStateNormal];
    [t setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:t];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator,leftBarButtonItem]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem: leftBarButtonItem animated:NO];
    }
    [t addTarget:self action:@selector(comeBackButton:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)comeBackButton:(UIButton*)btn{
    [self.phoneTF resignFirstResponder];
    [self.securityTF resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setNaviRightButton{
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    [t setFrame:CGRectMake(0, 0, 40, 40)];
    [t setTitle:@"提交" forState:UIControlStateNormal];
    t.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [t setBackgroundColor:[UIColor clearColor]];
    [t setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:t];
    [t addTarget:self action:@selector(commitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}
-(void)commitButton:(UIButton*)btn{
    if ([self.securityTF.text  isSecutityNumber] == NO) {
        [self.securityTF  shakeAnimation:0 duration:0 repeatCount:0];
        return;
    }
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postValidSecurityWithRegisterPhone:self.phoneTF.text andSecurity:self.securityTF.text andBack:^(id obj) {
        if (obj) {
            [self.getSecrectButton clearButton];
            ZZNewSecrectVC* NSVc = [[ZZNewSecrectVC alloc]initWithNibName:@"ZZNewSecrectVC" bundle:nil];
            NSVc.phoneNum = self.phoneTF.text;
            [self.navigationController pushViewController:NSVc animated:YES];
        }
    }];
    
    
}


- (IBAction)getKeyAction:(ZZSecurityButton *)sender {
    ZZLog(@"获取验证码");
    [self.phoneTF resignFirstResponder];
  
    if([self.phoneTF.text  isPhoneNumber] == NO ){
        [self.phoneTF  shakeAnimation];
        return;
    }
    [sender  startWithSecond:60];
      
        [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postSecurityWithPhoneNumber:self.phoneTF.text andBack:^(id obj) {
        
            if (obj) {
                self.securityTF.userInteractionEnabled = YES;
            }
           
        }];

}

-(void)dealloc{
   [self.getSecrectButton clearButton];
}
#pragma mark   private  methods
// 抖动动画



@end
