//
//  LoginVC.m
//  myProject
//
//  Created by Apple on 15/5/31.
//  Copyright (c) 2015年 王涛. All rights reserved.
//

#import "LoginVC.h"
#import "registerVC.h"
#import "ForgetVC.h"
#import "ZZNAViewController.h"
#import "ZZMyAlertView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ZZJsonParse.h"
#import "ZZUser.h"
#import "ZZHudView.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZIQKeyBoard.h"
/**
 *  自己封装的友盟三方
 */
#import "ZZUMSdk.h"

@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (strong, nonatomic) IBOutlet UITextField *keyBoardTF;
@property (strong, nonatomic) IBOutlet UIView *userAgreeView;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property (weak, nonatomic) IBOutlet UIButton *resignButon;
@property(nonatomic,strong )ZZHudView*  hudView;
@end

@implementation LoginVC

#pragma mark - Life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  开启IQKeyBoard
     */
    [[ZZIQKeyBoard sharedZZIQKeyBoard] openWithKeyBoard];
    self.navigationController.navigationBarHidden = YES;
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
 [self theThirdAgree];
    [self  setUpButtonExclusiveTouch];
    self.contentTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.contentTextView.layer.masksToBounds = YES;
    self.contentTextView.layer.borderWidth = .5;
    
 //   self.phoneNumTF.background = [UIImage imageWithStretchableName:@"operationbox_text"];
    UIImageView* phoneIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
    phoneIV.contentMode = UIViewContentModeLeft;
    [self.phoneNumTF setLeftView:phoneIV];
     self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
   // self.keyBoardTF.background = [UIImage imageWithStretchableName:@"operationbox_text"];
    UIImageView* keyIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"key"]];
    keyIV.contentMode = UIViewContentModeLeft;
    [self.keyBoardTF setLeftView:keyIV];
    self.keyBoardTF.leftViewMode = UITextFieldViewModeAlways;
    
    NSError*  readError ;
    self.contentTextView.text = [NSString  stringWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"萌宝派使用协议" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&readError];

}
- (void) setUpBackIV{
    UIImageView *iv = [[UIImageView  alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    iv.userInteractionEnabled = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.image =  [UIImage  imageWithContentsOfFile:[[NSBundle  mainBundle]pathForResource:@"渐变色3.jpg" ofType:nil]];
    [self.view  insertSubview:iv atIndex:0];
}
- (void) setUpButtonExclusiveTouch{
    self.loginButton.exclusiveTouch = YES;
    self.resignButon.exclusiveTouch = YES;
    self.forgetButton.exclusiveTouch = YES;
}

#pragma ButtonEvent
/**
 *  登录事件
 */
- (IBAction)enterInApp:(UIButton *)sender {
    ZZLog(@"登录");
    //[self   tap:nil];
    [self.view  endEditing:YES];
    if ([self.phoneNumTF.text  isPhoneNumber] == NO) {
        [self.phoneNumTF  shakeAnimation];
        return;
    }
    if ([self.keyBoardTF.text isPassWordWithMin:ZZMiMaMinLenth max:ZZMiMaMaxLenth] == NO) {
        [self.keyBoardTF  shakeAnimation];
        return;
    }
    
    
    AppDelegate* app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest] postLoginUserWithPhoneNumber:self.phoneNumTF.text andPassword:self.keyBoardTF.text andToken:nil andBack:^(id obj) {
        
        if (obj) {
           
                [app  gotoBWindowAndController:2];

        }
    
    }];
}

/**
 *  注册界面事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)registerButton:(UIButton *)sender {
    ZZLog(@"注册");
    [self.view  endEditing:YES];
    self.userAgreeView.center = self.view.center;
    [self.view addSubview:self.userAgreeView];
}
/**
 *  忘记密码界面事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)forgetButton:(UIButton *)sender {
    ZZLog(@"忘记密码");
    ForgetVC *forVc = [[ForgetVC alloc]initWithNibName:@"ForgetVC" bundle:nil];
    [self.navigationController pushViewController:forVc animated:YES];
}
/**
 *  注册返回界面按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)backback:(UIButton *)sender {
    [self.userAgreeView removeFromSuperview];
}
/**
 *  注册同意按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)toNextView:(UIButton *)sender {
    
    registerVC *regVc = [[registerVC alloc]initWithNibName:@"registerVC" bundle:nil];
    [self.navigationController pushViewController:regVc animated:YES];
    [self.userAgreeView removeFromSuperview];
}

#pragma mark   private  methods


#pragma ThirdButtonEvent
//三方授权
-(void)theThirdAgree{
    
    NSArray*  array = [ZZUMSdk  sharedZZUMSdk].enterArray;
    CGFloat   benWidth = 90;
    CGFloat  left = (ScreenWidth - array.count*benWidth)/2+20;
    
    for (int  i = 0; i<array.count; i++) {
        NSDictionary*  buttonDic = array[i];
        if ([buttonDic  isKindOfClass:[NSDictionary  class]]) {
            NSString*  imageName = [buttonDic  objectForKey:@"imageName"];
            UIButton* loginButton = [[UIButton alloc]initWithFrame:CGRectMake(i*benWidth+left, ScreenHeight-50-25, 50, 50)];
            loginButton.exclusiveTouch = YES;
            [loginButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:@"png"]] forState:UIControlStateNormal];
            [loginButton  addTarget:self action:@selector(thirdLoginButtonAction:) forControlEvents: UIControlEventTouchUpInside];
            loginButton.tag = [[buttonDic  objectForKey:@"loginType"]integerValue];
            
            [self.view addSubview:loginButton];
        }
        
    }
}
#pragma mark – event response
/**
 *  三方事件
 *
 *  @param btn <#btn description#>
 */
-(void)thirdLoginButtonAction:(UIButton*)btn{
    [self  hudViewShowWithTip:@"授权开始"];
    /**
     *  0605 王雷修改的三方登录 友盟
     *
     *  @param obj <#obj description#>
     *
     *  @return <#return value description#>
     */
    
    [[ZZUMSdk sharedZZUMSdk] umThirdEnterWithController:self andUmSdkShare:btn.tag andBack:^(id obj) {
        if (obj) {
            if (obj&&[obj  isKindOfClass:[NSDictionary  class]]) {//确定返回的字典
                [self  hudViewShowWithTip:@"授权成功"];
                AppDelegate* app =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postAddUserByThirdWithUserOpenId:[obj  objectForKey:@"thirdToken"] andNick:[obj  objectForKey:@"thirdNickName"] andBack:^(id obj) {
                    if (obj) {
                       
                            [app  gotoBWindowAndController:2];
                    
                    }else{
                        [self  hudViewShowWithTip:@"请重试"];
                    }
                    
                    
                }];
            }else{
                if ([obj  isKindOfClass:[NSString  class]]) {
                    [self  hudViewShowWithTip:obj];
                }else{
                    [self  hudViewShowWithTip:@"授权失败"];
                }
                
            }
            
        }else{
            [self  hudViewShowWithTip:@"授权失败"];
            
        }
    }];
    
}

//授权提示
-(void)hudViewShowWithTip:(NSString*)tip{
    self.hudView.contentLabel.text = tip;
    [self.hudView  showWithTime:1];
}

-(ZZHudView *)hudView{
    if (!_hudView) {
        _hudView = [[ZZHudView  alloc]init];
    }
    return _hudView;
}


@end
