//
//  registerVC.m
//  登录界面
//
//  Created by charles on 15/8/5.
//  Copyright (c) 2015年 Charles_Wl. All rights reserved.
//

#import "registerVC.h"
#import "ZZHudView.h"
#import "ZZMengBaoPaiRequest.h"
#import "ZZIQKeyBoard.h"
@interface registerVC ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *securityTF;
@property (strong, nonatomic) IBOutlet UITextField *keyWordTF;
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet ZZSecurityButton *securityButton;

@end

@implementation registerVC
#pragma mark - Life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  开启IQKeyBoard
     */
    [[ZZIQKeyBoard sharedZZIQKeyBoard] openWithKeyBoard];
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
    self.navigationController.navigationBarHidden = NO;
    [self  setUpBackIV];
    self.title = @"欢迎注册";
    [self setNaviLeftButton];
    [self setNaviRightButton];

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
    [self.keyWordTF resignFirstResponder];
    [self.securityTF resignFirstResponder];
    [self.userNameTF resignFirstResponder];
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
    [self.view  endEditing:YES];
    NSString*  name = [self   strLengthWith:self.userNameTF.text] ;
    if ([self.phoneTF.text isPhoneNumber] == NO) {
        [self.phoneTF  shakeAnimation];
        return;
    }if ([self.securityTF.text  isSecutityNumber]== NO) {
        
        [self.securityTF  shakeAnimation];
        return;
    }if ([self.keyWordTF.text  isPassWordWithMin:ZZMiMaMinLenth max:ZZMiMaMaxLenth ] == NO) {
        [self.keyWordTF  shakeAnimation];
        return;
    }if (name.length<1  || [name unicodeLength] > ZZNickMaxLenth ) {
        [self.userNameTF  shakeAnimation];
        return;
    }
    
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postAddUserWithPhoneNumber:self.phoneTF.text andPassword:self.keyWordTF.text andSecurity:self.securityTF.text andNick:name   andBack:^(id obj) {
        
        if (obj) {
            [self.securityTF resignFirstResponder];
            [self.keyWordTF resignFirstResponder];
            [self.userNameTF resignFirstResponder];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}



- (IBAction)getsecurityAction:(UIButton *)sender {
    if ([self.phoneTF.text isPhoneNumber] == NO) {
        //手机号码不正确
        [self.phoneTF   shakeAnimation];
        return;
    }
    
    [self.phoneTF  resignFirstResponder];
     [self.securityButton startWithSecond:60];
    [[ZZMengBaoPaiRequest  shareMengBaoPaiRequest]postValidPhoneIsResignWithPhoneNumber:self.phoneTF.text andBack:^(id obj) {
       
        if (obj) {
            
            self.phoneTF.userInteractionEnabled = NO;
            self.securityTF.userInteractionEnabled = YES;
            self.keyWordTF.userInteractionEnabled = YES;
            self.userNameTF.userInteractionEnabled = YES;
            
        }else{
        
            [self.securityButton  stop];
        }
        
    }];
    
    
}


//去除字符串 头尾的空格与回车
-(NSString*)strLengthWith:(NSString*)str{
    return  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)dealloc{
    [self.securityButton  clearButton];
}
/**
 *  placeholder位置改变
 *
 *  @param bounds <#bounds description#>
 *
 *  @return <#return value description#>
 */

@end
